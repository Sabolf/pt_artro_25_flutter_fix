import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:pt_25_artro_test/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/user_card.dart';
import '../screens/person_detail_screen.dart';

class SessionContainer extends StatefulWidget {
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
  State<SessionContainer> createState() => _SessionContainerState();
}

class _SessionContainerState extends State<SessionContainer> {
  List<dynamic> allSpeakers = [];
  bool isLoading = true; // Use a boolean to manage loading state

  @override
  void initState() {
    super.initState();
    loadPeopleJson();
  }

  Future<void> loadPeopleJson() async {
    try {
      final String peopleString = await rootBundle.loadString(
        'assets/data/people.json',
      );
      final List<dynamic> peopleJson = jsonDecode(peopleString);
      setState(() {
        allSpeakers = peopleJson;
        isLoading = false;
      });
    } catch (e) {
      // Handle the error if the file can't be loaded
      print("Error loading JSON: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    if (widget.sessionContainer.isEmpty) return const SizedBox();

    final unescape = HtmlUnescape();

    return Card(
      margin: const EdgeInsets.all(10),
      color: widget.backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFE82166), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildSessionItem(
              context,
              widget.sessionContainer[0],
              isFirst: true,
              unescape: unescape,
            ),
            if (widget.sessionContainer.length > 1)
              const Divider(color: Colors.grey, height: 20),
            ...widget.sessionContainer.sublist(1).map((item) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _buildSessionItem(context, item, unescape: unescape),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(
    BuildContext context,
    dynamic item, {
    bool isFirst = false,
    required HtmlUnescape unescape,
  }) {
    final timeBgColor = !isFirst ? Colors.grey.shade200 : Colors.grey.shade700;
    final titleBgColor = !isFirst ? Colors.white : Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
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
                            content: Text(
                              unescape.convert(
                                item['short_description_pl'] ??
                                    'No description',
                              ),
                            ),
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
                      unescape.convert(
                        item["title_pl"] ?? item["title_en"] ?? "",
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (item['place_pl'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        item['place_pl'] != ""
                            ? item['place_pl']
                            : 'OPEN STAGE',
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
                        if (widget.onSpeakerTap != null) {
                          widget.onSpeakerTap!(item["speakers"]);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List<Widget>.from(
                            item["speakers"].map<Widget>((speaker) {
                              return InkWell(
                                onTap: () {
                                  dynamic tmpPerson;

                                  for (var person in allSpeakers) {
                                    if (person['id'] == speaker['symbol']) {
                                      tmpPerson = person;
                                    }
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      bool isFavorite =
                                          false; // Local state for the dialog

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Speaker name
                                                Expanded(
                                                  child: Text(
                                                    speaker['name'] ??
                                                        'Unknown Speaker',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),

                                                // Star toggle
                                                IconButton(
                                                  icon: Icon(
                                                    isFavorite
                                                        ? Icons.star
                                                        : Icons.star_border,
                                                    color: isFavorite
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      isFavorite = !isFavorite;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                            content: UserCard(
                                              wholeObject: tmpPerson,
                                              onTap: (x) {
                                                print(
                                                  "Pulling info from ${x['name']}",
                                                );
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PersonDetailScreen(
                                                          speaker: tmpPerson,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  speaker["name"] ??
                                      "*****************************************",
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
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
