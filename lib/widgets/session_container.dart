import 'package:flutter/material.dart';

class SessionContainer extends StatelessWidget {
  final List<dynamic> sessionContainer;
  final Function(List<dynamic>)? onSpeakerTap;

  const SessionContainer({
    super.key,
    required this.sessionContainer,
    this.onSpeakerTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sessionContainer.isEmpty) return SizedBox();

    final first = sessionContainer[0];
    final rest = sessionContainer.sublist(1);

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFFE82166), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // FIRST ITEM
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text("${first['start_time']}-${first['end_time']}"),
                ),
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Description'),
                          content: Text(first['short_description_pl'] ?? 'No description'),
                          actions: [
                            TextButton(
                              child: Text("OK"),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ),
                      );
                    },
                    child: Text(
                      first["title_pl"] ?? first["title_en"] ?? "",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // REMAINING ITEMS
            ...rest.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        color: Colors.grey.shade700,
                        child: Text(
                          "${item['start_time']}-${item['end_time']}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    // Title and Speakers
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: Colors.grey.shade300,
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            GestureDetector(
                              onTap: () {
                                // You can add more behavior here
                              },
                              child: Text(
                                item["title_en"] ?? "",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),

                            // Speakers
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
                                          speaker["name"] ?? "",
                                          style: TextStyle(
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
            }).toList(),
          ],
        ),
      ),
    );
  }
}
