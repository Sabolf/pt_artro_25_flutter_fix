import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Import the QR screen to navigate to it
import 'qr_screen.dart';

// Placeholder classes for demonstration
// In a real app, these would be in their own files
class CommonStyles {
  final double pillBorderRadius = 25.0;
}

class AppLocalizations {
  String translate(String key) {
    switch (key) {
      case 'askQuestion':
        return 'Ask a Question';
      case 'askingTo':
        return 'Asking to';
      case 'prelegent':
        return 'Presenter';
      case 'yourQuestion':
        return 'Your Question';
      case 'yourName':
        return 'Your Name';
      case 'scan_badge_to_send_question':
        return 'Scan Badge to Send Question';
      case 'send_question':
        return 'Send Question';
      case 'question_saved_ok':
        return 'Question saved successfully!';
      case 'question_saved_error':
        return 'Error saving question.';
      case 'Notification':
        return 'Notification';
      case 'OK':
        return 'OK';
      default:
        return key;
    }
  }

  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations();
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

    _itemDetails['question'] = _question;
    _itemDetails['userName'] = _yourName;
    _itemDetails['day'] = _day;
    _itemDetails['user'] = _ean;

    // Replace with your actual API URL
    const String saveQuestionUrl =
        'https://voteptartro.wisehub.pl/api/index.php?action=save-question';

    try {
      final response = await http.post(
        Uri.parse(saveQuestionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_itemDetails),
      );

      if (response.statusCode == 200) {
        await FileManager.addToFileArray('user_question', _itemDetails);
        _showMessage(
            AppLocalizations.of(context)!.translate('question_saved_ok'));
      } else {
        print('HTTP Error: ${response.statusCode}');
        _showMessage(
            AppLocalizations.of(context)!.translate('question_saved_error'));
      }
    } catch (e) {
      print('Error: $e');
      _showMessage(
          AppLocalizations.of(context)!.translate('question_saved_error'));
    } finally {
      setState(() {
        _isWorking = false;
      });
      // Navigate back after showing the message
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate('Notification')),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('OK')),
              onPressed: () {
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
    if (result != null && result is String) {
      setState(() {
        _ean = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CommonStyles commonStyles = CommonStyles();
    
    // Check if _itemDetails has been initialized
    if (!mounted || !(_itemDetails is Map<String, dynamic>)) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extract prelegent names
    String prelegentNames = (_itemDetails['speakers'] as List<dynamic>?)
        ?.map((speaker) => speaker['name'])
        .where((name) => name != null)
        .join(', ') ?? 'N/A';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('askQuestion')),
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
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
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
                        AppLocalizations.of(context)!.translate('askingTo'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        _itemDetails['title_pl'] ?? _itemDetails['title_en'] ?? 'N/A',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.translate('prelegent'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        prelegentNames,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.translate('yourQuestion'),
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
                        AppLocalizations.of(context)!.translate('yourName'),
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            minimumSize: const Size(double.infinity, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(commonStyles.pillBorderRadius),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('scan_badge_to_send_question'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_ean != null && _question.isNotEmpty && !_isWorking)
                        ElevatedButton(
                          onPressed: _isWorking ? null : _sendData,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(commonStyles.pillBorderRadius),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('send_question'),
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