import 'package:flutter/material.dart';
import '../widgets/room_selection.dart';
import '../widgets/session_container.dart';
import '../l10n/app_localizations.dart' as loc;

class DayDetailScreen extends StatefulWidget {
  // A final variable to hold all the session data for the day.
  // The type is 'dynamic' which suggests it's a flexible data structure, likely a list of maps.
  final dynamic dayInformation;
  // A final variable that determines the number of rooms, used to create the correct number of buttons and pages.
  // The length of this list dictates the count of rooms and the "All" tab.
  final dynamic dayRoomAmount;

  // The constructor requires the day's information and room count to be passed in.
  const DayDetailScreen({
    super.key,
    required this.dayRoomAmount,
    required this.dayInformation,
  });

  @override
  // This method creates the mutable state for the StatefulWidget.
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  // late PageController: A PageController is a class that manages a PageView.
  // The 'late' keyword means it will be initialized before its first use, which happens in initState.
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Instantiate the PageController. It's now ready to be used by a PageView.
    _pageController = PageController();
    // A print statement for debugging purposes, to confirm the widget has initialized.
    print("DAY DETAIL PAGE LOADING *************************************");
  }

  @override
  void dispose() {
    // This is a critical step. When the widget is removed from the widget tree,
    // the PageController and its resources must be disposed of to prevent memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  // This is the active method for building content for a specific room page.
  // It's called by the PageView's builder.
  List<Widget> _buildRoomContent(int roomIndex) {
    String roomToLookFor = "";

    // The logic to map an index to a room name.
    if (roomIndex < widget.dayRoomAmount.length - 1) {
      switch (roomIndex) {
        case 0:
          roomToLookFor = "SALA S1";
          break;
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
        default:
          roomToLookFor = "NO ROOM FOUND";
      }
    } else {
      // The last page is for "All" rooms.
      roomToLookFor = "ALL";
    }

    List<dynamic> tmpSessionContainer = [];
    List<List<dynamic>> arrayOfSessionContainers = [];

    // Filter and group sessions for the specified room.
    for (int i = 0; i < widget.dayInformation.length; i++) {
      // The `if` condition correctly handles both specific rooms and the "ALL" case.
      if (widget.dayInformation[i]["place_pl"] == roomToLookFor || roomToLookFor == "ALL") {
        bool nextIsContainer = false;

        if (i + 1 < widget.dayInformation.length) {
          nextIsContainer = widget.dayInformation[i + 1]["is_session_container"] == 1;
        }

        tmpSessionContainer.add(widget.dayInformation[i]);

        if (nextIsContainer) {
          arrayOfSessionContainers.add(tmpSessionContainer);
          tmpSessionContainer = [];
        }

        if (i + 1 >= widget.dayInformation.length && tmpSessionContainer.isNotEmpty) {
          arrayOfSessionContainers.add(tmpSessionContainer);
          tmpSessionContainer = [];
        }
      }
    }

    // The method returns a list of SessionContainer widgets based on the filtered data.
    return arrayOfSessionContainers
        .map((sessionGroup) => SessionContainer(sessionContainer: sessionGroup))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final locData = loc.AppLocalizations.of(context)!;
    // The main layout of the screen is a Scaffold.
    return Scaffold(
      // The AppBar provides the title for the screen.
      appBar: AppBar(title: Text(locData.day_detail)),
      // A Column arranges its children vertically.
      body: Column(
        children: [
          // The RoomSelection widget is placed at the top of the column.
          RoomSelection(
            // The number of buttons is based on the dayRoomAmount list.
            numberOfButtons: widget.dayRoomAmount.length - 1,
            // The 'onRoomSelected' callback is triggered when a button is tapped.
            // It calls the PageController's animateToPage method to smoothly scroll the PageView.
            onRoomSelected: (roomIndex) {
              _pageController.animateToPage(
                roomIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            // The PageController is passed to the RoomSelection widget,
            // so it can listen for swipes and keep its state in sync.
            pageController: _pageController,
          ),
          // The Expanded widget ensures the PageView fills the rest of the available space.
          Expanded(
            // PageView.builder is a highly performant widget that builds pages on demand.
            child: PageView.builder(
              controller: _pageController,
              // The number of pages is equal to the number of rooms plus the "All" page.
              itemCount: widget.dayRoomAmount.length,
              // This callback is executed when a page changes, typically from a swipe.
              // A comment explains that the RoomSelection widget's listener handles the state update,
              // so this callback is empty.
              onPageChanged: (index) {
                // The RoomSelection widget's listener on the PageController handles the state update,
                // so no additional setState is needed here.
              },
              // The itemBuilder function is called for each page to build its content.
              itemBuilder: (context, index) {
                // It calls _buildRoomContent to get the list of widgets for the current page index.
                final visibleSession = _buildRoomContent(index);
                // The content for each page is a scrollable ListView containing the session widgets.
                return ListView(children: visibleSession);
              },
            ),
          ),
        ],
      ),
    );
  }
}