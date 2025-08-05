import 'package:flutter/material.dart';
import '../widgets/room_selection.dart';
import '../widgets/session_container.dart';

class DayDetailScreen extends StatefulWidget {
  final dynamic dayInformation;
  final dynamic dayRoomAmount;

  const DayDetailScreen({
    super.key,
    required this.dayRoomAmount,
    required this.dayInformation,
  });

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void getRoominfo(int room) {
    print("GRABBING ROOM INFO FROM ROOM ${room + 1}");

    String roomToLookFor = "";

    if (room < widget.dayRoomAmount.length - 1) {
      switch (room) {
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
      roomToLookFor = "ALL";
    }

    List<dynamic> tmpSessionContainer = [];
    List<List<dynamic>> arrayOfSessionContainers = [];

    for (int i = 0; i < widget.dayInformation.length; i++) {
      if (widget.dayInformation[i]["place_pl"] == roomToLookFor) {
        bool nextIsContainer = false;

        // ✅ Safe next-item check
        if (i + 1 < widget.dayInformation.length) {
          nextIsContainer = widget.dayInformation[i + 1]["is_session_container"] == 1;
        }

        tmpSessionContainer.add(widget.dayInformation[i]);

        if (nextIsContainer) {
          arrayOfSessionContainers.add(tmpSessionContainer);
          tmpSessionContainer = [];
        }

        // ✅ Add final chunk if at the end
        if (i + 1 >= widget.dayInformation.length && tmpSessionContainer.isNotEmpty) {
          arrayOfSessionContainers.add(tmpSessionContainer);
          tmpSessionContainer = [];
        }
      }
    }

    List<Widget> tmpVisibleDetailComponent = arrayOfSessionContainers
        .map((sessionGroup) => SessionContainer(sessionContainer: sessionGroup))
        .toList();

    // The logic to update visibleSession is now handled by the PageView.
    // Instead of setting state, we return the list of widgets.
    // This method can now be used to build the content for each page.
    // We will restructure this logic slightly to make it work with PageView.
  }

  List<Widget> _buildRoomContent(int roomIndex) {
    String roomToLookFor = "";

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
      roomToLookFor = "ALL";
    }

    List<dynamic> tmpSessionContainer = [];
    List<List<dynamic>> arrayOfSessionContainers = [];

    for (int i = 0; i < widget.dayInformation.length; i++) {
      if (widget.dayInformation[i]["place_pl"] == roomToLookFor) {
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

    return arrayOfSessionContainers
        .map((sessionGroup) => SessionContainer(sessionContainer: sessionGroup))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DAY DETAILS")),
      body: Column(
        children: [
          RoomSelection(
            numberOfButtons: widget.dayRoomAmount.length - 1,
            onRoomSelected: (roomIndex) {
              _pageController.animateToPage(
                roomIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            },
            pageController: _pageController,
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.dayRoomAmount.length,
              onPageChanged: (index) {
                // We'll update the RoomSelection state via a callback
                // This will be handled by a change in RoomSelection itself.
                // We don't need a setState here.
              },
              itemBuilder: (context, index) {
                final visibleSession = _buildRoomContent(index);
                return ListView(children: visibleSession);
              },
            ),
          ),
        ],
      ),
    );
  }
}