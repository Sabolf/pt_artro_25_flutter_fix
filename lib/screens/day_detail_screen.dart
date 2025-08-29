import 'package:flutter/material.dart'; // Imports the core Flutter Material library, which contains all the standard UI widgets and tools.
import '../widgets/room_selection.dart'; // Imports a custom widget that displays the room selection buttons.
import '../widgets/session_container.dart'; // Imports a custom widget used to display grouped session data.
import '../l10n/app_localizations.dart' as loc; // Imports the localization delegate to handle multi-language support.

class DayDetailScreen extends StatefulWidget { // Defines a StatefulWidget, a widget that can hold mutable state.
  // A final variable to hold all the session data for the day.
  // The type is 'dynamic' which suggests it's a flexible data structure, likely a list of maps.
  final dynamic dayInformation; // A final field to receive the day's session information. 'final' means it's set once in the constructor.
  // A final variable that determines the number of rooms, used to create the correct number of buttons and pages.
  // The length of this list dictates the count of rooms and the "All" tab.
  final dynamic dayRoomAmount; // A final field to receive the number of available rooms.
  final dynamic date;

  // The constructor requires the day's information and room count to be passed in.
  const DayDetailScreen({ // The constructor for the DayDetailScreen widget.
    super.key, // Passes the key to the parent class.
    required this.dayRoomAmount, // Requires the dayRoomAmount to be provided.
    required this.dayInformation, // Requires the dayInformation to be provided.
    required this.date
  });

  @override // Indicates that the following method overrides a method from the parent class.
  // This method creates the mutable state for the StatefulWidget.
  State<DayDetailScreen> createState() => _DayDetailScreenState(); // Creates and returns the associated State object.
}

class _DayDetailScreenState extends State<DayDetailScreen> { // The private State class for DayDetailScreen.
  // late PageController: A PageController is a class that manages a PageView.
  // The 'late' keyword means it will be initialized before its first use, which happens in initState.
  late PageController _pageController; // Declares a PageController that will be initialized later.

  @override // Overrides the initState method.
  void initState() { // Called once when the widget is inserted into the widget tree.
    super.initState(); // Calls the parent's initState method.
    // Instantiate the PageController. It's now ready to be used by a PageView.
    _pageController = PageController(); // Initializes the PageController.
    // A print statement for debugging purposes, to confirm the widget has initialized.
    print("DAY DETAIL PAGE LOADING *************************************"); // Prints a message for debugging.
  }

  @override // Overrides the dispose method.
  void dispose() { // Called when the widget is permanently removed from the tree.
    // This is a critical step. When the widget is removed from the widget tree,
    // the PageController and its resources must be disposed of to prevent memory leaks.
    _pageController.dispose(); // Releases the resources used by the PageController.
    super.dispose(); // Calls the parent's dispose method.
  }

  // This is the active method for building content for a specific room page.
  // It's called by the PageView's builder.
  List<Widget> _buildRoomContent(int roomIndex) { // A helper method that builds the content (list of widgets) for a specific room.
    String roomToLookFor = ""; // A variable to hold the room name to filter by.

    // The logic to map an index to a room name.
    if (roomIndex < widget.dayRoomAmount.length - 1) { // Checks if the index corresponds to a specific room, not the 'All' page.
      switch (roomIndex) { // Uses a switch statement to map the index to a room name.
        case 0: // If the index is 0.
          roomToLookFor = "SALA S1"; // Sets the room name to "SALA S1".
          break; // Exits the switch statement.
        case 1:
          roomToLookFor = "SALA S2";
          break;
        case 2:
          roomToLookFor = "SALA S3";
          break;
        case 3:
          roomToLookFor = "SALA S4";
          break;
        case 4:
          roomToLookFor = "SALA S5";
          break;
        case 5:
          roomToLookFor = "SALA S6";
          break;
        default: // If the index doesn't match any of the above.
          roomToLookFor = "NO ROOM FOUND"; // Sets a default value.
      }
    } else { // If the index is the last one (for the 'All' page).
      // The last page is for "All" rooms.
      roomToLookFor = "ALL"; // Sets the room name to "ALL".
    }

    List<dynamic> tmpSessionContainer = []; // A temporary list to group sessions.
    List<List<dynamic>> arrayOfSessionContainers = []; // A list to store the final grouped sessions.

    // Filter and group sessions for the specified room.
    for (int i = 0; i < widget.dayInformation.length; i++) { // Loops through all the sessions for the day.
      // The `if` condition correctly handles both specific rooms and the "ALL" case.
      if (widget.dayInformation[i]["place_pl"] == roomToLookFor || roomToLookFor == "ALL") { // Checks if the session belongs to the current room or if it's the 'All' page.
        bool nextIsContainer = false; // A flag to check if the next session is the start of a new container.

        if (i + 1 < widget.dayInformation.length) { // Prevents an out-of-bounds error when looking ahead.
          nextIsContainer = widget.dayInformation[i + 1]["is_session_container"] == 1; // Checks the `is_session_container` field of the next session.
        }

        tmpSessionContainer.add(widget.dayInformation[i]); // Adds the current session to the temporary list.

        if (nextIsContainer) { // If the next session marks a new container.
          arrayOfSessionContainers.add(tmpSessionContainer); // Adds the completed session container to the main list.
          tmpSessionContainer = []; // Resets the temporary list for the next container.
        }

        if (i + 1 >= widget.dayInformation.length && tmpSessionContainer.isNotEmpty) { // Checks if it's the last session and the temporary list isn't empty.
          arrayOfSessionContainers.add(tmpSessionContainer); // Adds the final session container to the main list.
          tmpSessionContainer = []; // Resets the temporary list.
        }
      }
    }

    // The method returns a list of SessionContainer widgets based on the filtered data.
    return arrayOfSessionContainers // Returns the list of grouped sessions.
        .map((sessionGroup) => SessionContainer(sessionContainer: sessionGroup)) // Maps each session group to a SessionContainer widget.
        .toList(); // Converts the mapped iterable to a final list.
  }

  @override // Overrides the build method.
  Widget build(BuildContext context) { // The method that builds the UI for the screen.
    final locData = loc.AppLocalizations.of(context)!; // Gets the localized text data.
    // The main layout of the screen is a Scaffold.
    return Scaffold( // Returns a Scaffold, providing a standard screen layout.
      // The AppBar provides the title for the screen.
      appBar: AppBar(title: Text("${locData.day_detail} ${widget.date}")), // Sets the app bar with a localized title.
      // A Column arranges its children vertically.
      body: Column( // Lays out its children in a vertical column.
        children: [ // The list of widgets inside the Column.
          // The RoomSelection widget is placed at the top of the column.
          RoomSelection( // Displays the room selection buttons.
            // The number of buttons is based on the dayRoomAmount list.
            numberOfButtons: widget.dayRoomAmount.length - 1, // Determines the number of buttons to display (excluding the 'All' page).
            // The 'onRoomSelected' callback is triggered when a button is tapped.
            // It calls the PageController's animateToPage method to smoothly scroll the PageView.
            onRoomSelected: (roomIndex) { // A callback function that runs when a button is tapped.
              _pageController.animateToPage( // Animates the PageView to the specified page.
                roomIndex, // The index of the page to navigate to.
                duration: const Duration(milliseconds: 300), // The duration of the animation.
                curve: Curves.easeIn, // The animation curve.
              );
            },
            // The PageController is passed to the RoomSelection widget,
            // so it can listen for swipes and keep its state in sync.
            pageController: _pageController, // Passes the controller to the RoomSelection widget for synchronization.
          ),
          // The Expanded widget ensures the PageView fills the rest of the available space.
          Expanded( // A widget that causes its child to fill the remaining space.
            // PageView.builder is a highly performant widget that builds pages on demand.
            child: PageView.builder( // A widget that creates a scrollable, paged list.
              controller: _pageController, // Links the PageView to the PageController.
              // The number of pages is equal to the number of rooms plus the "All" page.
              itemCount: widget.dayRoomAmount.length, // Sets the total number of pages.
              // This callback is executed when a page changes, typically from a swipe.
              // A comment explains that the RoomSelection widget's listener handles the state update,
              // so this callback is empty.
              onPageChanged: (index) { // A callback that runs when the page changes.
                // The RoomSelection widget's listener on the PageController handles the state update,
                // so no additional setState is needed here.
              }, // The body is empty as another widget handles the state update.
              // The itemBuilder function is called for each page to build its content.
              itemBuilder: (context, index) { // A function that builds the content for each page.
                // It calls _buildRoomContent to get the list of widgets for the current page index.
                final visibleSession = _buildRoomContent(index); // Calls the helper method to get the list of widgets for the current page.
                // The content for each page is a scrollable ListView containing the session widgets.
                return ListView(children: visibleSession); // Returns a scrollable list containing the generated session widgets.
              },
            ),
          ),
        ],
      ),
    );
  }
}