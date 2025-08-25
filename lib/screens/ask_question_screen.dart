import 'package:flutter/material.dart'; // Imports the Flutter Material library for UI widgets.
import 'package:http/http.dart' as http; // Imports the http package for making network requests.
import 'dart:convert'; // Imports the dart:convert library for JSON encoding and decoding.
import 'package:shared_preferences/shared_preferences.dart'; // Imports shared_preferences for local data storage.
import '../l10n/app_localizations.dart' as loc; // Imports the generated localization file with an alias 'loc'.
import 'qr_screen.dart'; // Imports the QR scanning screen.

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
      default:
        return key; // Returns the key itself if no translation is found.
    }
  }
// This is a static factory method to get the correct localization object from the widget tree.
  static AppLocalizations? of(BuildContext context) {
    final localization = loc.AppLocalizations.of(context); // Finds the raw localization object from the context.
    return localization != null ? AppLocalizations(localization) : null; // Returns a new AppLocalizations instance with the found data, or null if not found.
  }
}

// A utility class for file-like data management using shared preferences.
class FileManager {
  // An asynchronous static method to add an item to a list stored on the device.
  static Future<void> addToFileArray(
      String key, Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance(); // Gets the SharedPreferences instance asynchronously.
    List<String> existingItems = prefs.getStringList(key) ?? []; // Gets the existing list for the key, or an empty list if it doesn't exist.
    existingItems.add(jsonEncode(item)); // Converts the new item to a JSON string and adds it to the list.
    await prefs.setStringList(key, existingItems); // Saves the updated list back to SharedPreferences.
  }
}

// Defines a StatefulWidget for the AskQuestionScreen.
class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key}); // A constant constructor with a key.

  @override
  _AskQuestionScreenState createState() => _AskQuestionScreenState(); // Creates and returns the state object for this widget.
}

// The state class for the AskQuestionScreen.
class _AskQuestionScreenState extends State<AskQuestionScreen> {
  // Private fields to hold the mutable state of the screen.
  String _question = ''; // Stores the text of the user's question.
  String _yourName = ''; // Stores the name entered by the user.
  String? _ean; // Stores the scanned QR code or EAN, can be null.
  bool _isWorking = false; // A flag to indicate if an asynchronous process is running.

  // Late fields that will be initialized later, after the widget is created.
  late Map<String, dynamic> _itemDetails; // Will hold details about the item the question is for.
  late String _day; // Will hold the day of the event.

  // Controllers to manage the text in the input fields.
  final TextEditingController _questionController = TextEditingController(); // Controller for the question text field.
  final TextEditingController _nameController = TextEditingController(); // Controller for the name text field.

  @override
  void initState() { // Called once when the widget is inserted into the tree.
    super.initState(); // Always call the parent's initState first.

    _questionController.addListener(() { // Adds a listener to the question controller.
      setState(() { // Tells Flutter to rebuild the UI.
        _question = _questionController.text; // Updates the private state variable with the new text.
      });
    });

    _nameController.addListener(() { // Adds a listener to the name controller.
      setState(() { // Tells Flutter to rebuild the UI.
        _yourName = _nameController.text; // Updates the private state variable with the new text.
      });
    });

    // Schedules a callback to run after the first frame is rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // Gets arguments passed to this route from the previous screen.
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) { // Checks if arguments were provided.
        setState(() { // Rebuilds the UI with the new data.
          _itemDetails = args['details'] as Map<String, dynamic>; // Assigns the 'details' from arguments to _itemDetails.
          _day = args['day'] as String; // Assigns the 'day' from arguments to _day.
        });
      }
    });
  }

  @override
  void dispose() { // Called when the widget is removed from the tree.
    _questionController.dispose(); // Disposes the question controller to free up memory.
    _nameController.dispose(); // Disposes the name controller.
    super.dispose(); // Always call the parent's dispose method last.
  }

  Future<void> _sendData() async { // An asynchronous method to send data.
    if (_isWorking) return; // Prevents the function from running if it's already working.
    setState(() { // Rebuilds the UI to show that work has started.
      _isWorking = true; // Sets the working flag to true.
    });

    // Creates a map of data to send to the server.
    final Map<String, dynamic> dataToSend = {
      'user': _ean, // The user's EAN.
      'id': _itemDetails['id'], // The item ID.
      'question': _question, // The question text.
      'title': _itemDetails['title_pl'] ?? _itemDetails['title_en'], //****NEEDS TO BE CHANGED BASED ON LANGUAGE  */
      'userName': _yourName, // The user's name.
      // Gets a comma-separated list of speaker names.
      'prelegent': (_itemDetails['speakers'] as List<dynamic>?)
              ?.map((speaker) => speaker['name']) // Maps each speaker object to their name.
              .where((name) => name != null) // Filters out any null names.
              .join(', ') ?? // Joins the names into a single string.
          '', // Default value if the list is null.
    };

    const String saveQuestionUrl =
        'https://voteptartro.wisehub.pl/api/index.php?action=save-question'; // The API endpoint URL.

    try { // Starts a try-catch block to handle errors.
      final response = await http.post( // Sends a POST request to the server.
        Uri.parse(saveQuestionUrl), // Parses the URL.
        headers: {'Content-Type': 'application/json'}, // Sets the request headers.
        body: jsonEncode(dataToSend), // Encodes the data map into a JSON string for the request body.
      );

      if (!mounted) return; // Checks if the widget is still in the tree before proceeding.

      if (response.statusCode == 200) { // Checks if the request was successful (HTTP status code 200).
        // Creates a map of question data to save locally.
        final Map<String, dynamic> localQuestionData = {
          'id': _itemDetails['id'],
          'question': _question,
          'title': _itemDetails['title_pl'] ?? _itemDetails['title_en'],
          'userName': _yourName,
          'user': _ean,
          // Gets the speaker names again.
          'prelegent': (_itemDetails['speakers'] as List<dynamic>?)
                  ?.map((speaker) => speaker['name'])
                  .where((name) => name != null)
                  .join(', ') ??
              '',
          'day': _day,
        };

        await FileManager.addToFileArray('user_question', localQuestionData); // Saves the question data locally.
        _showMessage( // Shows a success message.
            AppLocalizations.of(context)!.translate('question_saved_ok'));
      } else { // If the HTTP status code is not 200.
        print('HTTP Error: ${response.statusCode}'); // Prints the HTTP error code.
        _showMessage( // Shows an error message.
            AppLocalizations.of(context)!.translate('question_saved_error'));
      }
    } catch (e) { // Catches any network or other errors.
      print('Error: $e'); // Prints the error.
      if (mounted) { // Checks if the widget is still in the tree.
        _showMessage( // Shows an error message.
            AppLocalizations.of(context)!.translate('question_saved_error'));
      }
    } finally { // This block runs regardless of success or error.
      if (mounted) { // Checks if the widget is still in the tree.
        setState(() { // Tells Flutter to rebuild the UI.
          _isWorking = false; // Sets the working flag to false, which would hide the progress indicator.
        });
      }
    }
  }

  void _showMessage(String message) { // A method to show a dialog message.
    showDialog( // Displays a dialog box.
      context: context, // The context for the dialog.
      builder: (BuildContext context) { // The builder function that creates the dialog's content.
        final localizations = AppLocalizations.of(context)!; // Gets the localization object for the dialog's context.
        return AlertDialog( // Returns an AlertDialog widget.
          title: Text(localizations.translate('Notification')), // Sets the title of the dialog using a translation.
          content: Text(message), // Sets the body of the dialog to the passed-in message.
          actions: <Widget>[ // A list of widgets for the dialog's actions (buttons).
            TextButton( // Creates a text button.
              child: Text(localizations.translate('OK')), // Sets the button text using a translation.
              onPressed: () { // The function to run when the button is pressed.
                Navigator.of(context).pop(); // Closes the current dialog.
                Navigator.of(context).pop(); // Navigates back one screen (likely the AskQuestionScreen itself).
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _scanBadge() async { // An asynchronous method to scan a QR code.
    // Pushes a new screen onto the stack and waits for a result.
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => const QrScreen()), // Builds the QrScreen widget.
    );
    if (!mounted) return; // Checks if the widget is still in the tree.
    if (result != null && result is String) { // Checks if the result is not null and is a string.
      setState(() { // Rebuilds the UI.
        _ean = result; // Assigns the scanned string result to the _ean field.
      });
    }
  }

  @override
  Widget build(BuildContext context) { // The build method that creates the widget's UI.
    final localizations = AppLocalizations.of(context)!; // Gets the localization object.
    final CommonStyles commonStyles = CommonStyles(); // Creates an instance of the CommonStyles class.

    if (!mounted) { // Checks if the widget is still in the tree.
      return const Scaffold( // Returns an empty scaffold with a loading indicator.
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Extracts speaker names from the item details and joins them into a string.
    String prelegentNames = (_itemDetails['speakers'] as List<dynamic>?)
            ?.map((speaker) => speaker['name'])
            .where((name) => name != null)
            .join(', ') ??
        'N/A';

    return Scaffold( // Returns the main UI structure for the screen.
      appBar: AppBar( // Creates the app bar at the top of the screen.
        title: Text(localizations.translate('askQuestion')), // Sets the app bar title using a translation.
      ),
      body: Stack( // Allows widgets to be layered on top of each other.
        children: [ // A list of widgets to be stacked.
          SingleChildScrollView( // Allows the content to be scrollable.
            padding: const EdgeInsets.all(10), // Adds padding around the content.
            child: Column( // Arranges widgets in a vertical column.
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretches children horizontally.
              children: [ // A list of widgets inside the column.
                Container( // A container for styling the main content box.
                  padding: const EdgeInsets.all(16.0), // Adds padding inside the container.
                  margin: const EdgeInsets.symmetric( // Adds margin around the container.
                      horizontal: 10.0, vertical: 20.0),
                  decoration: BoxDecoration( // Defines the container's visual decoration.
                    color: Colors.white, // Sets the background color.
                    borderRadius: BorderRadius.circular(10.0), // Sets rounded corners.
                    boxShadow: [ // Adds a shadow to the container.
                      BoxShadow( // Defines the shadow properties.
                        color: Colors.grey.withOpacity(0.2), // Shadow color.
                        spreadRadius: 2, // How far the shadow spreads.
                        blurRadius: 5, // The blurriness of the shadow.
                        offset: const Offset(0, 3), // The shadow's position relative to the container.
                      ),
                    ],
                  ),
                  child: Column( // A column for the content inside the container.
                    crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left.
                    children: [ // List of widgets inside this column.
                      Text( // Displays the "askingTo" translation.
                        localizations.translate('askingTo'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text( // Displays the session title.
                        _itemDetails['title_pl'] ?? // Tries to get the Polish title. ***** NEED TO BE UPDATED ON LANGUAGE SETTINGS
                            _itemDetails['title_en'] ?? // Falls back to the English title.
                            'N/A', // Default to 'N/A' if neither is found.
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10), // Adds vertical space.
                      Text( // Displays the "prelegent" translation.
                        localizations.translate('prelegent'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text( // Displays the names of the speakers.
                        prelegentNames,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20), // Adds vertical space.
                      Text( // Displays the "yourQuestion" translation.
                        localizations.translate('yourQuestion'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextField( // The question input field.
                        controller: _questionController, // Links the text field to its controller.
                        maxLines: 5, // Allows multiple lines of text.
                        maxLength: 500, // Sets the maximum number of characters.
                        decoration: const InputDecoration( // Defines the text field's appearance.
                          border: OutlineInputBorder(), // Adds a border around the field.
                          hintText: '', // No hint text.
                          contentPadding: EdgeInsets.all(12), // Adds padding inside the field.
                        ),
                      ),
                      const SizedBox(height: 10), // Adds vertical space.
                      Text( // Displays the "yourName" translation.
                        localizations.translate('yourName'),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextField( // The name input field.
                        controller: _nameController, // Links the text field to its controller.
                        maxLines: 1, // Restricts to a single line.
                        maxLength: 70, // Sets the maximum number of characters.
                        decoration: const InputDecoration( // Defines the text field's appearance.
                          border: OutlineInputBorder(), // Adds a border.
                          hintText: '', // No hint text.
                          contentPadding: EdgeInsets.all(12), // Adds padding.
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Adds vertical space.
                Center( // Centers the child widget.
                  child: Column( // A column to hold the buttons.
                    children: [ // List of widgets inside this column.
                      if (_ean == null) // Shows the button only if _ean is null.
                        ElevatedButton( // The button for scanning the badge.
                          onPressed: _isWorking ? null : _scanBadge, // Disables the button if a process is running.
                          style: ElevatedButton.styleFrom( // Defines the button's style.
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            minimumSize: const Size(double.infinity, 52), // Makes the button full width.
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  commonStyles.pillBorderRadius), // Sets the border radius from the common style.
                            ),
                          ),
                          child: Text( // The button's text.
                            localizations.translate(
                                'scan_badge_to_send_question'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_ean != null && _question.isNotEmpty && !_isWorking) // Shows this button only if a badge is scanned and a question is entered.
                        ElevatedButton( // The send question button.
                          onPressed: _isWorking ? null : _sendData, // Disables the button if a process is running.
                          style: ElevatedButton.styleFrom( // Defines the button's style.
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  commonStyles.pillBorderRadius), // Sets the border radius.
                            ),
                          ),
                          child: Text( // The button's text.
                            localizations.translate('send_question'),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      if (_isWorking) // Shows a loading indicator if the app is busy.
                        const Padding( // Adds padding.
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 50), // Adds vertical space.
              ],
            ),
          ),
        ],
      ),
    );
  }
}