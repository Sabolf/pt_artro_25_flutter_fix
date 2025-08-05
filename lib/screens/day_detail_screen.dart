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
  List<Widget> visibleSession = [];

  @override
  void initState() {
    super.initState();
    print("\n\n\n\n\n\n\n---------------------- LOAD SCREEN ----------------------------\n");
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

    setState(() {
      visibleSession = tmpVisibleDetailComponent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DAY DETAILS")),
      body: Column(
        children: [
          RoomSelection(
            numberOfButtons: widget.dayRoomAmount.length - 1,
            onRoomSelected: (x) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                getRoominfo(x);
              });
            },
          ),
          Expanded(
            child: ListView(children: visibleSession),
          ),
        ],
      ),
    );
  }
}
