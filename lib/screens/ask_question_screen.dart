// Imports the Flutter Material library for UI widgets.
import 'package:flutter/material.dart';
// Imports the http package for making network requests.
import 'package:http/http.dart' as http;
// Imports the dart:convert library for JSON encoding and decoding.
import 'dart:convert';
// Imports shared_preferences for local data storage.
import 'package:shared_preferences/shared_preferences.dart';
// Imports the generated localization file with an alias 'loc'.
import '../l10n/app_localizations.dart' as loc;
// Imports the QR scanning screen.
import 'qr_screen.dart';

// A utility class to define common styles.
class CommonStyles {
  final double pillBorderRadius = 25.0; // Defines a consistent border radius value.
}

// A wrapper class to make localization data more accessible and add custom methods.
class AppLocalizations {
  // Holds an instance of the auto-generated localization data.
  final loc.AppLocalizations _localizations;

  // The constructor that initializes the _localizations field.
  AppLocalizations(this._localizations);

  // A custom method to translate a string based on a key.
  String translate(String key) {
    // A switch statement to find the correct translation.
    switch (key) {
      case 'askQuestion':
        return _localizations.askQuestion; // Returns the translated string for 'askQuestion'.
      case 'askingTo':
        return _localizations.askingTo; // Returns the translated string for 'askingTo'.
      case 'prelegent':
        return _localizations.presenters; // Returns the translated string for 'prelegent'.
      case 'yourQuestion':
        return _localizations.yourQuestion; // Returns the translated string for 'yourQuestion'.
      case 'yourName':
        return _localizations.yourName; // Returns the translated string for 'yourName'.
      case 'scan_badge_to_send_question':
        return _localizations.scan_badge_to_send_question; // Returns the translated string for 'scan_badge_to_send_question'.
      case 'send_question':
        return _localizations.send_question; // Returns the translated string for 'send_question'.
      case 'question_saved_ok':
        return _localizations.question_saved_ok; // Returns the translated string for 'question_saved_ok'.
      case 'question_saved_error':
        return _localizations.question_saved_error; // Returns the translated string for 'question_saved_error'.
      case 'Notification':
        return _localizations.notification; // Returns the translated string for 'Notification'.
      case 'OK':
        return 'OK'; // Returns a hardcoded string 'OK'.
      case 'submit_attendance':
        return _localizations.submit_attendance;
      case 'consent_header' :
        return _localizations.consent_header;
      case 'recorded':
        return _localizations.recorded;
      case 'enter_question':
        return _localizations.enter_your_question;
      default:
        return key; // Returns the key itself if no translation is found.
    }
  }

  // This is a static factory method to get the correct localization object from the widget tree.
  static AppLocalizations? of(BuildContext context) {
    final localization = loc.AppLocalizations.of(
      context,
    ); // Finds the raw localization object from the context.
    return localization != null
        ? AppLocalizations(localization)
        : null; // Returns a new AppLocalizations instance with the found data, or null if not found.
  }
}

// A utility class for file-like data management using shared preferences.
class FileManager {
  // An asynchronous static method to add an item to a list stored on the device.
  static Future<void> addToFileArray(
    String key,
    Map<String, dynamic> item,
  ) async {
    final prefs =
        await SharedPreferences.getInstance(); // Gets the SharedPreferences instance asynchronously.
    List<String> existingItems =
        prefs.getStringList(key) ??
        []; // Gets the existing list for the key, or an empty list if it doesn't exist.
    existingItems.add(
      jsonEncode(item),
    ); // Converts the new item to a JSON string and adds it to the list.
    await prefs.setStringList(
      key,
      existingItems,
    ); // Saves the updated list back to SharedPreferences.
  }
}

// Defines a StatefulWidget for the AskQuestionScreen.
class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key}); // A constant constructor with a key.

  @override
  _AskQuestionScreenState createState() =>
      _AskQuestionScreenState(); // Creates and returns the state object for this widget.
}

// The state class for the AskQuestionScreen.
class _AskQuestionScreenState extends State<AskQuestionScreen> {
  // Private fields to hold the mutable state of the screen.
  bool _consent = false;
  String _question = ''; // Stores the text of the user's question.
  String _yourName = ''; // Stores the name entered by the user.
  String? _ean; // Stores the scanned QR code or EAN, can be null.
  bool _isWorking =
      false; // A flag to indicate if an asynchronous process is running.

  // Late fields that will be initialized later, after the widget is created.
  late Map<String, dynamic>
      _itemDetails; // Will hold details about the item the question is for.
  late String _day; // Will hold the day of the event.
  late bool _submission;

  // Controllers to manage the text in the input fields.
  final TextEditingController _questionController =
      TextEditingController(); // Controller for the question text field.
  final TextEditingController _nameController =
      TextEditingController(); // Controller for the name text field.

  @override
  void initState() {
    // Called once when the widget is inserted into the tree.
    super.initState(); // Always call the parent's initState first.

    _questionController.addListener(() {
      // Adds a listener to the question controller.
      setState(() {
        // Tells Flutter to rebuild the UI.
        _question = _questionController
            .text; // Updates the private state variable with the new text.
      });
    });

    _nameController.addListener(() {
      // Adds a listener to the name controller.
      setState(() {
        // Tells Flutter to rebuild the UI.
        _yourName = _nameController
            .text; // Updates the private state variable with the new text.
      });
    });

    // Schedules a callback to run after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Gets arguments passed to this route from the previous screen.
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        // Checks if arguments were provided.
        setState(() {
          // Rebuilds the UI with the new data.
          _itemDetails = args['details']
              as Map<String, dynamic>; // Assigns the 'details' from arguments to _itemDetails.
          _day =
              args['day'] as String; // Assigns the 'day' from arguments to _day.
          _submission = args['submission'] as bool;
        });
      }
    });
  }

  @override
  void dispose() {
    // Called when the widget is removed from the tree.
    _questionController
        .dispose(); // Disposes the question controller to free up memory.
    _nameController.dispose(); // Disposes the name controller.
    super.dispose(); // Always call the parent's dispose method last.
  }

  Future<void> _sendData() async {
    // An asynchronous method to send data.
    if (_isWorking)
      return; // Prevents the function from running if it's already working.
    setState(() {
      // Rebuilds the UI to show that work has started.
      _isWorking = true; // Sets the working flag to true.
    });

    // Creates a map of data to send to the server.
    final Map<String, dynamic> dataToSend = {
      'user': _ean, // The user's EAN.
      'id': _itemDetails['id'], // The item ID.
      'question': _question, // The question text.
      // Uses the current locale to determine which title to send.
      'title': Localizations.localeOf(context).languageCode == 'pl'
          ? _itemDetails['title_pl']
          : _itemDetails['title_en'],
      'userName': _yourName, // The user's name.
      // Gets a comma-separated list of speaker names.
      'prelegent':
          (_itemDetails['speakers'] as List<dynamic>?)
              ?.map(
                (speaker) => speaker['name'],
              ) // Maps each speaker object to their name.
              .where((name) => name != null) // Filters out any null names.
              .join(', ') ?? // Joins the names into a single string.
          '', // Default value if the list is null.
    };

    const String saveQuestionUrl =
        'https://voteptartro.wisehub.pl/api/index.php?action=save-question'; // The API endpoint URL.

    try {
      // Starts a try-catch block to handle errors.
      final response = await http.post(
        // Sends a POST request to the server.
        Uri.parse(saveQuestionUrl), // Parses the URL.
        headers: {
          'Content-Type': 'application/json',
        }, // Sets the request headers.
        body: jsonEncode(
          dataToSend,
        ), // Encodes the data map into a JSON string for the request body.
      );

      if (!mounted)
        return; // Checks if the widget is still in the tree before proceeding.

      if (response.statusCode == 200) {
        // Checks if the request was successful (HTTP status code 200).
        // Creates a map of question data to save locally.
        final Map<String, dynamic> localQuestionData = {
          'id': _itemDetails['id'],
          'question': _question,
          // Uses the current locale to determine which title to save locally.
          'title': Localizations.localeOf(context).languageCode == 'pl'
              ? _itemDetails['title_pl']
              : _itemDetails['title_en'],
          'userName': _yourName,
          'user': _ean,
          // Gets the speaker names again.
          'prelegent':
              (_itemDetails['speakers'] as List<dynamic>?)
                  ?.map((speaker) => speaker['name'])
                  .where((name) => name != null)
                  .join(', ') ??
              '',
          'day': _day,
        };

        await FileManager.addToFileArray(
          'user_question',
          localQuestionData,
        ); // Saves the question data locally.
        _showMessage(
          // Shows a success message.
          AppLocalizations.of(context)!.translate('question_saved_ok'),
        );
      } else {
        // If the HTTP status code is not 200.
        print(
          'HTTP Error: ${response.statusCode}',
        ); // Prints the HTTP error code.
        _showMessage(
          // Shows an error message.
          AppLocalizations.of(context)!.translate('question_saved_error'),
        );
      }
    } catch (e) {
      // Catches any network or other errors.
      print('Error: $e'); // Prints the error.
      if (mounted) {
        // Checks if the widget is still in the tree.
        _showMessage(
          // Shows an error message.
          AppLocalizations.of(context)!.translate('question_saved_error'),
        );
      }
    } finally {
      // This block runs regardless of success or error.
      if (mounted) {
        // Checks if the widget is still in the tree.
        setState(() {
          // Tells Flutter to rebuild the UI.
          _isWorking =
              false; // Sets the working flag to false, which would hide the progress indicator.
        });
      }
    }
  }

  Future<void> _submitAttendance() async {
    // A placeholder for your attendance submission logic.
    if (_isWorking) return;
    setState(() {
      _isWorking = true;
    });

    try {
      // Your API call to submit attendance goes here.
      // Example:
      // final response = await http.post(Uri.parse('YOUR_ATTENDANCE_API_ENDPOINT'), body: {'user': _ean});
      // if (response.statusCode == 200) {
      //   _showMessage("Attendance submitted successfully.");
      // } else {
      //   _showMessage("Failed to submit attendance.");
      // }

      // Simulating a network delay for demonstration.
      await Future.delayed(const Duration(seconds: 2));
      _showMessage("Attendance submitted successfully.");
    } catch (e) {
      print('Error submitting attendance: $e');
      _showMessage("Failed to submit attendance.");
    } finally {
      if (mounted) {
        setState(() {
          _isWorking = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    // A method to show a dialog message.
    showDialog(
      // Displays a dialog box.
      context: context, // The context for the dialog.
      builder: (BuildContext context) {
        // The builder function that creates the dialog's content.
        final localizations = AppLocalizations.of(
          context,
        )!; // Gets the localization object for the dialog's context.
        return AlertDialog(
          // Returns an AlertDialog widget.
          title: Text(
            localizations.translate('Notification'),
          ), // Sets the title of the dialog using a translation.
          content: Text(
            message,
          ), // Sets the body of the dialog to the passed-in message.
          actions: <Widget>[
            // A list of widgets for the dialog's actions (buttons).
            TextButton(
              // Creates a text button.
              child: Text(
                localizations.translate('OK'),
              ), // Sets the button text using a translation.
              onPressed: () {
                // The function to run when the button is pressed.
                Navigator.of(context).pop(); // Closes the current dialog.
                Navigator.of(
                  context,
                ).pop(); // Navigates back one screen (likely the AskQuestionScreen itself).
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBadge() async {
    // An asynchronous method to scan a QR code.
    // Pushes a new screen onto the stack and waits for a result.
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const QrScreen(),
      ), // Builds the QrScreen widget.
    );
    if (!mounted) return; // Checks if the widget is still in the tree.
    if (result != null && result is String) {
      // Checks if the result is not null and is a string.
      setState(() {
        // Rebuilds the UI.
        _ean = result; // Assigns the scanned string result to the _ean field.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final CommonStyles commonStyles = CommonStyles();

    if (!mounted) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String prelegentNames =
        (_itemDetails['speakers'] as List<dynamic>?)
            ?.map((speaker) => speaker['name'])
            .where((name) => name != null)
            .join(', ') ??
        'N/A';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0), // Lighter background for more contrast
      appBar: AppBar(
        title: _submission
            ?  Text(
                localizations.translate('submit_attendance'), // Cleaned up text
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              )
            : Text(
                localizations.translate('askQuestion'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow for a flat, modern look
        centerTitle: true, // Centers the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event/Session Details Card (Updated style)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: Colors.grey.shade300, width: 1), // Adds a subtle border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!_submission)
                      Text(
                        localizations.translate('askingTo').toUpperCase(), // Uppercase for emphasis
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blueGrey, // A cooler, more professional color
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      Localizations.localeOf(context).languageCode == 'pl'
                          ? _itemDetails['title_pl'] ?? 'N/A'
                          : _itemDetails['title_en'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333), // Darker text for better readability
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      localizations.translate('prelegent').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      prelegentNames,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Question/Consent Section (Updated style)
              if (_submission)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('consent_header'), // More professional text
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFA8415B), // A calm blue
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Checkbox(
                          value: _consent,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _consent = newValue ?? false;
                            });
                          },
                          activeColor: const Color(0xFFA8415B), // New checkbox color
                        ),
                         Expanded( // Use expanded to handle long text
                          child: Text(
                            localizations.translate('recorded'),
                            style: TextStyle(color: Color(0xFF555555)),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.translate('yourQuestion').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _questionController,
                      maxLines: 5,
                      maxLength: 500,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: localizations.translate('enter_question'),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      localizations.translate('yourName').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _nameController,
                      maxLines: 1,
                      maxLength: 70,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        hintText: localizations.translate('yourName'),
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 32),

              // Buttons Section (Updated logic and style)
              Center(
                child: _submission
                    ? (_consent
                        ? _buildElevatedButton(
                            text: localizations.translate('submit_attendance'),
                            onPressed: _submitAttendance,
                            commonStyles: commonStyles,
                          )
                        : const SizedBox.shrink())
                    : (_ean == null
                        ? _buildElevatedButton(
                            text: localizations.translate('scan_badge_to_send_question'),
                            onPressed: _scanBadge,
                            commonStyles: commonStyles,
                          )
                        : (_question.isNotEmpty
                            ? _buildElevatedButton(
                                text: localizations.translate('send_question'),
                                onPressed: _sendData,
                                commonStyles: commonStyles,
                              )
                            : const SizedBox.shrink())),
              ),

              if (_isWorking)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build the common ElevatedButton style
  Widget _buildElevatedButton({
    required String text,
    required void Function() onPressed,
    required CommonStyles commonStyles,
  }) {
    return ElevatedButton(
      onPressed: _isWorking ? null : onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFFA8415B), // A vibrant, clean blue
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Less rounded corners
        ),
        elevation: 2, // Less prominent shadow
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}