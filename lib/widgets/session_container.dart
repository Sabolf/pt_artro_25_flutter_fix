import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

class SessionContainer extends StatelessWidget {
  final List<dynamic> sessionContainer;
  final Function(List<dynamic>)? onSpeakerTap;
  final Color? backgroundColor;
  final roomName;

  const SessionContainer({
    super.key,
    required this.sessionContainer,
    this.onSpeakerTap,
    this.backgroundColor,
    this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    if (sessionContainer.isEmpty) return const SizedBox();

    final unescape = HtmlUnescape();

    return Card(
      margin: const EdgeInsets.all(10),
      color: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE82166), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildSessionItem(context, sessionContainer[0], isFirst: true, unescape: unescape),
            if (sessionContainer.length > 1)
              const Divider(color: Colors.grey, height: 20),
            ...sessionContainer.sublist(1).map((item) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildSessionItem(context, item, unescape: unescape),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(BuildContext context, dynamic item, {bool isFirst = false, required HtmlUnescape unescape}) {
    final timeBgColor = !isFirst ? Colors.grey.shade200 : Colors.grey.shade700;
    final titleBgColor = !isFirst ? Colors.white : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: timeBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "${item['start_time']}-${item['end_time']}",
                style: TextStyle(
                  color: !isFirst ? Colors.black : Colors.white,
                  fontWeight: !isFirst ? FontWeight.normal : FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: titleBgColor,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isFirst) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Description'),
                            content: Text(unescape.convert(item['short_description_pl'] ?? 'No description')),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      unescape.convert(item["title_pl"] ?? item["title_en"] ?? ""),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (item['place_pl'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item['place_pl'] != "" ? item['place_pl'] : 'OPEN STAGE',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (item["speakers"] != null &&
                      item["speakers"] is List &&
                      item["speakers"].isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        if (onSpeakerTap != null) {
                          onSpeakerTap!(item["speakers"]);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Widget>.from(
                            item["speakers"].map<Widget>((speaker) {
                              return Text(
                                speaker["name"] ?? "*****************************************",
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}