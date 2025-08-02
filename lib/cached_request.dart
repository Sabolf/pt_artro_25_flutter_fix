import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
