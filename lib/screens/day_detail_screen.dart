import 'package:flutter/material.dart';

class DayDetailScreen extends StatefulWidget {
  const DayDetailScreen({super.key});

  @override
  State<DayDetailScreen> createState() => _DayDetailScreenState();
}

class _DayDetailScreenState extends State<DayDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      body: Text("THIS IS SOME DETAIL"),
    ));
  }
}