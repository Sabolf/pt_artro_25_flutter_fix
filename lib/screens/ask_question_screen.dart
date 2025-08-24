import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart' as loc;

// Import the QR screen to navigate to it
import 'qr_screen.dart';

// Placeholder classes for demonstration
// In a real app, these would be in their own files
class CommonStyles {
  final double pillBorderRadius = 25.0;
}

// NOTE: Removed the top-level declaration:
// final locData = loc.AppLocalizations.of(context)!;

class AppLocalizations {
  final loc.AppLocalizations _localizations;

  AppLocalizations(this._localizations);

  String translate(String key) {
    switch (key) {
      case 'askQuestion':
        return _localizations.askQuestion;
      case 'askingTo':
        return _localizations.askingTo;
      case 'prelegent':
        return _localizations.presenters;
      case 'yourQuestion':
        return _localizations.yourQuestion;
      case 'yourName':
        return _localizations.yourName;
      case 'scan_badge_to_send_question':
        return _localizations.scan_badge_to_send_question;
      case 'send_question':
        return _localizations.send_question;
      case 'question_saved_ok':
        return _localizations.question_saved_ok;
      case 'question_saved_error':
        return _localizations.question_saved_error;
      case 'Notification':
        return _localizations.notification;
      case 'OK':
        return 'OK';
      default:
        return key;
    }
  }

  static AppLocalizations? of(BuildContext context) {
    final localization = loc.AppLocalizations.of(context);
    return localization != null ? AppLocalizations(localization) : null;
  }
}

class FileManager {
  static Future<void> addToFileArray(
      String key, Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> existingItems = prefs.getStringList(key) ?? [];
    existingItems.add(jsonEncode(item));
    await prefs.setStringList(key, existingItems);
  }
}

// Define the StatefulWidget for the AskQuestion screen
class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  _AskQuestionScreenState createState() => _AskQuestionScreenState();
}

// State class for AskQuestionScreen
class _AskQuestionScreenState extends State<AskQuestionScreen> {
  String _question = '';
  String _yourName = '';
  String? _ean;
  bool _isWorking = false;

  late Map<String, dynamic> _itemDetails;
  late String _day;

  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _questionController.addListener(() {
      setState(() {
        _question = _questionController.text;
      });
    });
    _nameController.addListener(() {
      setState(() {
        _yourName = _nameController.text;
      });
    });

    // Access route arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _itemDetails = args['details'] as Map<String, dynamic>;
          _day = args['day'] as String;
        });
      }
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _sendData() async {
    if (_isWorking) return;
    setState(() {
      _isWorking = true;
    });

    // Construct the data map to be sent to the API
    final Map<String, dynamic> dataToSend = {
      'user': _ean,
      'id': _itemDetails['id'], // Assuming the 'id' is in _itemDetails
      'question': _question,
      'title': _itemDetails['title_pl'] ?? _itemDetails['title_en'],
      'userName': _yourName,
      'prelegent': (_itemDetails['speakers'] as List<dynamic>?)
              ?.map((speaker) => speaker['name'])
              .where((name) => name != null)
              .join(', ') ??
          '',
    };

    const String saveQuestionUrl =
        'https://voteptartro.wisehub.pl/api/index.php?action=save-question';

    try {
      final response = await http.post(
        Uri.parse(saveQuestionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dataToSend), // Use the new dataToSend map
      );

      // Check if the widget is still mounted after the async operation
      if (!mounted) return;

      if (response.statusCode == 200) {
        // Create a map to save locally that includes the title
        final Map<String, dynamic> localQuestionData = {
          'id': _itemDetails['id'],
          'question': _question,
          'title': _itemDetails['title_pl'] ?? _itemDetails['title_en'],
          'userName': _yourName,
          'user': _ean,
          'prelegent': (_itemDetails['speakers'] as List<dynamic>?)
                  ?.map((speaker) => speaker['name'])
                  .where((name) => name != null)
                  .join(', ') ??
              '',
          'day': _day,
        };

        await FileManager.addToFileArray('user_question', localQuestionData);
        _showMessage(
            AppLocalizations.of(context)!.translate('question_saved_ok'));
      } else {
        print('HTTP Error: ${response.statusCode}');
        _showMessage(
            AppLocalizations.of(context)!.translate('question_saved_error'));
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        _showMessage(
            AppLocalizations.of(context)!.translate('question_saved_error'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
        // The navigation is now handled by the dialog's dismiss button
      }
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(localizations.translate('Notification')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.translate('OK')),
              onPressed: () {
                // First, pop the dialog
                Navigator.of(context).pop();
                // Then, navigate back to the previous screen
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBadge() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const QrScreen()),
    );
    // Check if the widget is still mounted after the async operation
    if (!mounted) return;
    if (result != null && result is String) {
      setState(() {
        _ean = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final CommonStyles commonStyles = CommonStyles();

    // Check if _itemDetails has been initialized
    if (!mounted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract prelegent names
    String prelegentNames = (_itemDetails['speakers'] as List<dynamic>?)
            ?.map((speaker) => speaker['name'])
            .where((name) => name != null)
            .join(', ') ??
        'N/A';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('askQuestion')),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.translate('askingTo'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        _itemDetails['title_pl'] ??
                            _itemDetails['title_en'] ??
                            'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizations.translate('prelegent'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        prelegentNames,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.translate('yourQuestion'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextField(
                        controller: _questionController,
                        maxLines: 5,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '',
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizations.translate('yourName'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextField(
                        controller: _nameController,
                        maxLines: 1,
                        maxLength: 70,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '',
                          contentPadding: EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      if (_ean == null)
                        ElevatedButton(
                          onPressed: _isWorking ? null : _scanBadge,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  commonStyles.pillBorderRadius),
                            ),
                          ),
                          child: Text(
                            localizations.translate(
                                'scan_badge_to_send_question'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_ean != null && _question.isNotEmpty && !_isWorking)
                        ElevatedButton(
                          onPressed: _isWorking ? null : _sendData,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  commonStyles.pillBorderRadius),
                            ),
                          ),
                          child: Text(
                            localizations.translate('send_question'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_isWorking)
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}