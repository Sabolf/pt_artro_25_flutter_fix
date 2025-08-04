import 'package:flutter/material.dart';
import '../widgets/room_selection.dart';

class DayDetailScreen extends StatefulWidget {
  const DayDetailScreen({super.key});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(title: Text("DAY DETAILS")),
      body: Column(children: [RoomSelection(numberOfButtons: 4)]),
    ));
  }
}
