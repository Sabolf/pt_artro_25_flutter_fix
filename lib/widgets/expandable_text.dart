import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart' as loc;

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
    const Color toggleColor = Color.fromARGB(255, 136, 19, 60);
    final locData = loc.AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.leadPart,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.left,
        ),
        if (_expanded)
          Text(
            widget.extendedPart,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        // Add a vertical space here
        const SizedBox(height: 8.0), 
        TextButton(
          onPressed: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: Text(
            _expanded ? locData.show_less : locData.show_more,
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