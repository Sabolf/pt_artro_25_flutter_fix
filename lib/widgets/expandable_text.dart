import 'package:flutter/material.dart';

class CustomExpandableText extends StatefulWidget {
  final String leadPart;
  final String extendedPart;

  const CustomExpandableText({
    super.key,
    required this.leadPart,
    required this.extendedPart,
  });

  @override
  State<CustomExpandableText> createState() => _CustomExpandableTextState();
}

class _CustomExpandableTextState extends State<CustomExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.leadPart + (_expanded ? widget.extendedPart : "")),
        TextButton(
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Text(_expanded ? 'Show Less' : 'Show More'),
        ),
      ],
    );
  }
}
