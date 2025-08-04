import 'package:flutter/material.dart';
import '../widgets/room_selection.dart';

class DayDetailScreen extends StatefulWidget {
  final dynamic dayRoomAmount;
  const DayDetailScreen({super.key, required this.dayRoomAmount});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text("DAY DETAILS")),
      body: Column(children: [RoomSelection(numberOfButtons: widget.dayRoomAmount.length - 1)]),
    ));
  }
}
