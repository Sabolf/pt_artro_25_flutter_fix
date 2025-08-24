// lib/screens/messages.dart

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- API and Cache Handling Class ---

typedef OnData<T> = void Function(T? data);

class CachedRequest {
  final Duration defaultLifetime = const Duration(minutes: 10);

  final String urlMessages = 'https://voteptartro.wisehub.pl/api/index.php?action=get-messages';
  final String urlDay0 = 'https://voteptartro.wisehub.pl/api/index.php?action=get-day-0';
  final String urlDay1 = 'https://voteptartro.wisehub.pl/api/index.php?action=get-day-1';
  final String urlDay2 = 'https://voteptartro.wisehub.pl/api/index.php?action=get-day-2';

  Future<void> readDataOrCached({
    required String endpoint,
    String method = 'GET',
    Map<String, dynamic>? params,
    required OnData<dynamic> onData,
    bool disableCache = false,
    Duration? cacheLifetime,
  }) async {
    final cacheLifetimeDuration = cacheLifetime ?? defaultLifetime;
    debugPrint('Calling ENDPOINT: $endpoint');

    if (kReleaseMode == false && false /* your global expired flag logic here */) {
      readCached(endpoint: endpoint, onData: onData);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final timestampKey = 'time_${_sanitize(endpoint)}';
    final lastSaved = prefs.getInt(timestampKey) ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastSaved;

    if (!disableCache && elapsed < cacheLifetimeDuration.inMilliseconds) {
      debugPrint('--- GRABBING CACHED DATA');
      readCached(endpoint: endpoint, onData: onData);
      return;
    }

    try {
      debugPrint('--- FETCHING FROM API');
      final uri = Uri.parse(endpoint);
      http.Response response;
      if (method.toUpperCase() == 'POST') {
        response = await http.post(
          uri,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(params),
        );
      } else {
        response = await http.get(uri);
      }

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/${_sanitize(endpoint)}');
        await file.writeAsString(jsonEncode(jsonData));
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        onData(jsonData);
        debugPrint('Downloaded from web');
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        readCached(endpoint: endpoint, onData: onData);
      }
    } catch (e) {
      debugPrint('Fetch error: $e');
      readCached(endpoint: endpoint, onData: onData);
    }
  }

  Future<void> readCached({
    required String endpoint,
    required OnData<dynamic> onData,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${_sanitize(endpoint)}');
      if (await file.exists()) {
        final content = await file.readAsString();
        onData(jsonDecode(content));
      } else {
        onData(null);
      }
    } catch (e) {
      debugPrint('Read cache error: $e');
      onData(null);
    }
  }

  String _sanitize(String endpoint) {
    return endpoint.replaceAll(RegExp(r'[^a-z0-9]'), '').toLowerCase();
  }
}

final cachedRequest = CachedRequest();

// --- Simplified global language and FileManager ---
String globalLang = 'en';

String t(String key) {
  final Map<String, Map<String, String>> translations = {
    'en': {'messages': 'Messages', 'no_messages': 'No messages to display.'},
    'pl': {'messages': 'Wiadomości', 'no_messages': 'Brak wiadomości do wyświetlenia.'}
  };
  return translations[globalLang]?[key] ?? key;
}

class FileManager {
  static Future<void> writeFile(String key, String content) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, content);
    debugPrint('FileManager: Wrote $content to $key');
  }

  static Future<String?> readFile(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final content = prefs.getString(key);
    debugPrint('FileManager: Read $content from $key');
    return content;
  }
}

class GlobalData {
  static int unreadMessagesNumber = 0;
  static String readMessagesIdFile = 'readMessagesIds.json';
}

// --- CommonStyles equivalent for Flutter ---
class CommonStyles {
  static ThemeData getAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blueGrey,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blueGrey,
        accentColor: Colors.deepPurpleAccent,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16.0),
        bodyMedium: TextStyle(fontSize: 14.0),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      ),
      useMaterial3: true,
    );
  }
}

// --- Messages Screen (Flutter equivalent) ---
class MessagesScreen extends StatefulWidget {
  final Function(List<int>)? setUnreadNumber;

  const MessagesScreen({super.key, this.setUnreadNumber});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with WidgetsBindingObserver {
  List<Widget> _msgs = [];
  Color _iconFillColor = Colors.deepPurpleAccent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadMessages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("MessagesScreen: resumed (screen focused)");
      setState(() {
        _msgs = [];
      });
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _msgs = [
        const Center(
          child: CircularProgressIndicator(),
        ),
      ];
    });

    await cachedRequest.readDataOrCached(
      endpoint: cachedRequest.urlMessages,
      onData: (data) {
        debugPrint("Fetched data: $data");
        List<Widget> tempMessages = [];
        List<int> messageIds = [];
        String languageKey = (globalLang == "pl") ? "messagePl" : "messageEn";

        if (data != null && data['message'] is List && data['message'].isNotEmpty) {
          for (var element in data['message']) {
            final id = element['id'];
            if (id != null) {
              final parsedId = int.tryParse(id.toString());
              if (parsedId != null) {
                messageIds.add(parsedId);
              }
            }
            tempMessages.add(
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 20, color: _iconFillColor),
                          const SizedBox(width: 8),
                          Text(
                            element['dateTime'] ?? 'Unknown Date',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                        child: Text(
                          element[languageKey] ?? 'No message content',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        } else {
          tempMessages.add(
            Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(t("no_messages"), style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          );
        }

        if (mounted) {
          setState(() {
            _msgs = tempMessages;
          });
          GlobalData.unreadMessagesNumber = 0;
          final String idxs = jsonEncode(messageIds);
          FileManager.writeFile(GlobalData.readMessagesIdFile, idxs);
          if (widget.setUnreadNumber != null) {
            // widget.setUnreadNumber(messageIds);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _iconFillColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      appBar: AppBar(
        title: Text(t("messages")),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _msgs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      ..._msgs,
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}