import 'package:flutter/material.dart'; // Imports the core Flutter Material library for building UI widgets.
import 'package:shared_preferences/shared_preferences.dart'; // Imports the shared_preferences package to store simple data persistently on the device.
import 'dart:convert'; // Imports the dart:convert library to encode and decode JSON data.

import 'package:pt_25_artro_test/widgets/user_card.dart'; // Imports a custom widget for displaying speaker information.
import 'person_detail_screen.dart'; // Imports the screen for displaying a person's details.
import '../l10n/app_localizations.dart' as loc; // Imports the localization delegate for language support.

class FavoritesScreen extends StatefulWidget { // Defines a StatefulWidget, a widget with mutable state.
  const FavoritesScreen({super.key}); // Constructor for the widget.

  @override // Overrides the createState method.
  State<FavoritesScreen> createState() => _FavoritesScreenState(); // Creates and returns the associated mutable state object.
}

class _FavoritesScreenState extends State<FavoritesScreen> { // The state class for FavoritesScreen.
  List<Map<String, dynamic>> favoriteSpeakers = []; // A list to hold the data for favorite speakers.
  List<Map<String, dynamic>> favoriteSessions = []; // A list to hold the data for favorite sessions.

  @override // Overrides the initState method.
  void initState() { // Called once when the widget is inserted into the widget tree.
    super.initState(); // Calls the parent's initState.
    loadFavorites(); // Calls the function to load saved favorites from storage.
  }

  Future<void> loadFavorites() async { // Asynchronous function to retrieve and load favorites.
    final prefs = await SharedPreferences.getInstance(); // Gets a `SharedPreferences` instance, waiting for it to be ready.
    final favSpeakersString = prefs.getString('favoriteSpeakers') ?? '[]'; // Retrieves the stored string of favorite speakers or defaults to an empty JSON array string.
    final favSessionsString = prefs.getString('favoriteSessions') ?? '[]'; // Retrieves the stored string of favorite sessions or defaults to an empty JSON array string.

    try { // Starts a try-catch block to handle potential JSON decoding errors.
      setState(() { // Triggers a rebuild of the widget's UI.
        favoriteSpeakers = List<Map<String, dynamic>>.from(jsonDecode(favSpeakersString)); // Decodes the speaker string into a list of maps and assigns it to the state variable.
        favoriteSessions = List<Map<String, dynamic>>.from(jsonDecode(favSessionsString)); // Decodes the session string into a list of maps and assigns it to the state variable.
      });
    } catch (e) { // Catches any exceptions during decoding.
      print("Error decoding favorites: $e"); // Prints the error to the console.
      setState(() { // Rebuilds the UI, but with empty lists.
        favoriteSpeakers = []; // Resets the favorite speakers list to empty.
        favoriteSessions = []; // Resets the favorite sessions list to empty.
      });
    }
  }

  Future<void> toggleFavoriteSpeaker(Map<String, dynamic> speaker) async { // Asynchronous function to add/remove a speaker from favorites.
    final prefs = await SharedPreferences.getInstance(); // Gets the SharedPreferences instance.

    setState(() { // Triggers a UI rebuild to reflect the change.
      final index = favoriteSpeakers.indexWhere((s) => s['id'] == speaker['id']); // Finds the index of the speaker in the list based on their ID.
      if (index >= 0) { // Checks if the speaker was found in the list.
        favoriteSpeakers.removeAt(index); // Removes the speaker if they are already a favorite.
      } else { // If the speaker was not found.
        favoriteSpeakers.add(speaker); // Adds the speaker to the list.
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers)); // Saves the updated list of favorite speakers to storage.
  }

  Future<void> toggleFavoriteSession(Map<String, dynamic> session) async { // Asynchronous function to add/remove a session from favorites.
    final prefs = await SharedPreferences.getInstance(); // Gets the SharedPreferences instance.

    setState(() { // Triggers a UI rebuild.
      final index = favoriteSessions.indexWhere((s) => s['id'] == session['id']); // Finds the index of the session by its ID.
      if (index >= 0) { // Checks if the session was found.
        favoriteSessions.removeAt(index); // Removes the session if it's already a favorite.
      } else { // If the session was not found.
        favoriteSessions.add(session); // Adds the session to the list.
      }
    });

    await prefs.setString('favoriteSessions', jsonEncode(favoriteSessions)); // Saves the updated list of favorite sessions to storage.
  }

  @override // Overrides the build method.
  Widget build(BuildContext context) { // This method builds the widget's UI.
    final locData = loc.AppLocalizations.of(context)!; // Gets the localized text data.
    return Scaffold( // Provides a basic visual structure for the screen.
      appBar: AppBar(title:  Text(locData.favorites)), // Displays an app bar with a localized title.
      body: SingleChildScrollView( // Allows the content to be scrollable if it exceeds the screen size.
        padding: const EdgeInsets.all(8.0), // Adds padding around the entire content.
        child: Column( // Arranges its children in a vertical column.
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left) of the column.
          children: [ // The list of widgets inside the column.
            if (favoriteSessions.isNotEmpty) ...[ // A conditional check; if there are favorite sessions, these widgets are added to the column. The `...` is the spread operator.
              Text(locData.favorite_sessions, // Displays a localized heading for favorite sessions.
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Styles the text.
              const SizedBox(height: 8), // Adds a small vertical space.
              ...favoriteSessions.map((session) { // Iterates through each favorite session.
                return Card( // Returns a card widget for each session.
                  margin: const EdgeInsets.symmetric(vertical: 4), // Adds vertical margin to the card.
                  child: ListTile( // A convenient widget for a single row with a title, subtitle, and trailing widget.
                    title: Text(session['title_pl'] ?? session['title_en'] ?? "No Title"), // Displays the session title, trying Polish first, then English, then a default.
                    subtitle: Text( // Displays the session details as a subtitle.
                      "Day: ${session['day'] ?? ''} | Room: ${session['room'] ?? ''} | ${session['start_time'] ?? ''}-${session['end_time'] ?? ''}" // Formats the subtitle text, providing empty strings if data is missing.
                    ),
                    trailing: IconButton( // An icon button at the end of the list tile.
                      icon: const Icon(Icons.star, color: Colors.amber), // Displays a filled star icon.
                      onPressed: () => toggleFavoriteSession(session), // Calls the `toggleFavoriteSession` function when pressed.
                    ),
                    onTap: () { // A callback that runs when the list tile is tapped.
                      showDialog( // Displays a dialog box.
                        context: context, // The context of the widget tree.
                        builder: (_) => AlertDialog( // Builds the content of the dialog.
                          title: Text(session['title_pl'] ?? session['title_en'] ?? "Session"), // Dialog title, with fallbacks.
                          content: Text(session['description'] ?? "No description"), // Dialog content, with fallback.
                          actions: [ // List of actions (buttons) in the dialog.
                            TextButton( // A text button.
                              onPressed: () => Navigator.pop(context), // Closes the dialog when pressed.
                              child: const Text("Close"), // The text of the button.
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }), // Converts the mapped iterable to a list of widgets.
              const SizedBox(height: 20), // Adds a larger vertical space.
            ],
            if (favoriteSpeakers.isNotEmpty) ...[ // Conditional check; if there are favorite speakers, adds these widgets.
              const Text("Favorite Speakers", // Displays a heading for favorite speakers.
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Styles the text.
              const SizedBox(height: 8), // Adds a small vertical space.
              ...favoriteSpeakers.map((speaker) { // Iterates through each favorite speaker.
                return UserCard( // Returns a custom widget for displaying a speaker.
                  wholeObject: speaker, // Passes the speaker data to the UserCard widget.
                  onTap: (x) { // Defines the action when the card is tapped.
                    Navigator.push( // Navigates to a new screen.
                      context, // The current context.
                      MaterialPageRoute( // A route that uses a full-screen transition.
                        builder: (context) => PersonDetailScreen(speaker: speaker), // The screen to navigate to, passing the speaker data.
                      ),
                    );
                  },
                  trailing: IconButton( // An icon button to be displayed at the end of the card.
                    icon: const Icon(Icons.star, color: Colors.amber), // A filled star icon.
                    onPressed: () => toggleFavoriteSpeaker(speaker), // Calls the `toggleFavoriteSpeaker` function when pressed.
                    tooltip: "Remove from favorites", // A hint that appears when the user long-presses the button.
                  ),
                );
              }), // Converts the mapped iterable to a list of widgets.
            ],
            if (favoriteSessions.isEmpty && favoriteSpeakers.isEmpty) // A conditional check; if both lists are empty.
              const Center( // Centers the child widget.
                child: Padding( // Adds padding around the child.
                  padding: EdgeInsets.all(20), // Adds 20 pixels of padding on all sides.
                  child: Text("You have no favorites yet."), // Displays a message to the user.
                ),
              ),
          ],
        ),
      ),
    );
  }
}