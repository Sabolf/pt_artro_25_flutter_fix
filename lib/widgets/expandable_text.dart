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
    const Color toggleColor = Color.fromARGB(255, 136, 19, 60); // Primary pink

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.leadPart + (_expanded ? widget.extendedPart : ""),
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.justify,
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Text(
            _expanded ? 'Show Less' : 'Show More',
            style: const TextStyle(
              color: toggleColor,
              fontWeight: FontWeight.w500,
              
            ),
          ),
        ),
      ],
    );
  }
}
