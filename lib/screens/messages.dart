// lib/screens/messages.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../cached_request.dart'; // <-- Your cached request class


// --- Message model ---
class Message {
  final int id;
  final String dateTime;
  final String content;

  Message({
    required this.id,
    required this.dateTime,
    required this.content,
  });

  factory Message.fromJson(Map<String, dynamic> json, String langKey) {
    return Message(
      id: int.tryParse(json['id'].toString()) ?? 0,
      dateTime: json['dateTime'] ?? '',
      content: json[langKey] ?? '',
    );
  }
}

// --- Messages Screen ---
class MessagesScreen extends StatefulWidget {
  final Function(List<int>)? setUnreadNumber;

  const MessagesScreen({super.key, this.setUnreadNumber});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with WidgetsBindingObserver {
  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isError = false;

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
      _loadMessages();
    }
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    await cachedRequest.readDataOrCached(
      endpoint: cachedRequest.urlMessages,
      onData: (data) {
        try {
          if (data != null && data['message'] is List) {
            final langKey = (globalLang == 'pl') ? 'messagePl' : 'messageEn';
            final msgs = (data['message'] as List)
                .map((e) => Message.fromJson(e, langKey))
                .toList();

            final ids = msgs.map((m) => m.id).toList();

            // Save read IDs
            FileManager.writeFile(GlobalData.readMessagesIdFile, jsonEncode(ids));

            // Reset unread
            GlobalData.unreadMessagesNumber = 0;

            if (widget.setUnreadNumber != null) {
              widget.setUnreadNumber!(ids);
            }

            if (mounted) {
              setState(() {
                _messages = msgs;
                _isLoading = false;
              });
            }
          } else {
            setState(() {
              _messages = [];
              _isLoading = false;
            });
          }
        } catch (e) {
          debugPrint("Parse error: $e");
          setState(() {
            _isError = true;
            _isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t("messages")),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadMessages,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isError
                  ? Center(
                      child: Text(
                        "Error loading messages",
                        style: theme.textTheme.bodyLarge,
                      ),
                    )
                  : _messages.isEmpty
                      ? ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                t("no_messages"),
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final msg = _messages[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_month,
                                            size: 20,
                                            color: theme
                                                .colorScheme.secondary),
                                        const SizedBox(width: 8),
                                        Text(
                                          msg.dateTime,
                                          style: theme.textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      msg.content,
                                      style: theme.textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
        ),
      ),
    );
  }
}
