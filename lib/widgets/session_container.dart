import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/user_card.dart';
import '../screens/person_detail_screen.dart';
// Import the new screen

class SessionContainer extends StatefulWidget {
  final List<dynamic> sessionContainer;
  final Function(List<dynamic>)? onSpeakerTap;
  final Color? backgroundColor;
  final String? roomName;

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
  List<Map<String, dynamic>> favoriteSpeakers = [];
  List<Map<String, dynamic>> favoriteSessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPeopleJson();
    loadFavorites();
  }

  Future<void> loadPeopleJson() async {
    try {
      final String peopleString =
          await rootBundle.loadString('assets/data/people.json');
      final List<dynamic> peopleJson = jsonDecode(peopleString);
      setState(() {
        allSpeakers = peopleJson;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favSpeakersString = prefs.getString('favoriteSpeakers') ?? '[]';
    final favSessionsString = prefs.getString('favoriteSessions') ?? '[]';
    
    try {
      setState(() {
        favoriteSpeakers = List<Map<String, dynamic>>.from(jsonDecode(favSpeakersString));
        favoriteSessions = List<Map<String, dynamic>>.from(jsonDecode(favSessionsString));
      });
    } catch (e) {
      print("Error decoding favorites: $e");
      setState(() {
        favoriteSpeakers = [];
        favoriteSessions = [];
      });
    }
  }

  Future<void> toggleFavoriteSpeaker(Map<String, dynamic> speaker) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final existingIndex = favoriteSpeakers
          .indexWhere((s) => s['id'].toString() == speaker['id'].toString());

      if (existingIndex >= 0) {
        favoriteSpeakers.removeAt(existingIndex);
      } else {
        favoriteSpeakers.add(speaker);
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers));
  }

  Future<void> toggleFavoriteSession(Map<String, dynamic> session) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final index = favoriteSessions.indexWhere((s) => s['id'].toString() == session['id'].toString());
      if (index >= 0) {
        favoriteSessions.removeAt(index);
      } else {
        favoriteSessions.add(session);
      }
    });
    await prefs.setString('favoriteSessions', jsonEncode(favoriteSessions));
  }

  bool isFavoriteSpeaker(String speakerId) {
    return favoriteSpeakers.any((s) => s['id'].toString() == speakerId);
  }

  bool isFavoriteSession(String sessionId) {
    return favoriteSessions.any((s) => s['id'].toString() == sessionId);
  }

  @override
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
    final speakers = (item["speakers"] is List) ? item["speakers"] : [];
    final bool isSessionFav = isFavoriteSession(item['id'].toString());

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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    return AlertDialog(
                                      title: Text(
                                        unescape.convert(
                                          item["title_pl"] ??
                                              item["title_en"] ??
                                              "",
                                        ),
                                      ),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if ((item['short_description_pl'] ?? '')
                                                .isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text(
                                                  unescape.convert(item[
                                                          'short_description_pl'] ??
                                                      ''),
                                                  style:
                                                      const TextStyle(fontSize: 14),
                                                ),
                                              ),
                                            if (speakers.isNotEmpty)
                                              Column(
                                                children: speakers
                                                    .map<Widget>((speaker) {
                                                  dynamic tmpPerson;
                                                  for (var person in allSpeakers) {
                                                    if (person['id'] ==
                                                        speaker['symbol']) {
                                                      tmpPerson = person;
                                                      break;
                                                    }
                                                  }
                                                  if (tmpPerson == null) {
                                                    return const SizedBox();
                                                  }
                                                  bool isFav = isFavoriteSpeaker(
                                                      speaker['symbol'].toString());
                                                  return ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Text(speaker["name"] ??
                                                        "Unknown"),
                                                    trailing: IconButton(
                                                      icon: Icon(
                                                        isFav
                                                            ? Icons.star
                                                            : Icons.star_border,
                                                        color: isFav
                                                            ? Colors.amber
                                                            : Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        toggleFavoriteSpeaker(
                                                                Map<String, dynamic>.from(
                                                                    tmpPerson))
                                                            .then((_) {
                                                          setState(() {});
                                                          setStateDialog(() {});
                                                        });
                                                      },
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
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
                                                  );
                                                }).toList(),
                                              )
                                            else if (!isFirst)
                                              const Text(
                                                  "No speakers for this session."),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text("Ask a Question"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.pushNamed(
                                              context,
                                              '/askQuestion',
                                              arguments: {
                                                'details': Map<String, dynamic>.from(item),
                                                'day': item['day'].toString(),
                                              },
                                            );
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Close"),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            unescape.convert(
                              item["title_pl"] ?? item["title_en"] ?? "",
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isSessionFav ? Icons.star : Icons.star_border,
                          color: isSessionFav ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          toggleFavoriteSession(Map<String, dynamic>.from(item)).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
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
                  if (widget.sessionContainer.length > 1 && speakers.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List<Widget>.from(
                          speakers.map<Widget>((speaker) {
                            return InkWell(
                              onTap: () {
                                dynamic tmpPerson;
                                for (var person in allSpeakers) {
                                  if (person['id'] == speaker['symbol']) {
                                    tmpPerson = person;
                                  }
                                }

                                if (tmpPerson == null) return;

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    bool isFav = isFavoriteSpeaker(speaker['symbol'].toString());

                                    return StatefulBuilder(
                                      builder: (context, setStateDialog) {
                                        return AlertDialog(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  speaker['name'] ??
                                                      'Unknown Speaker',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  isFav
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: isFav
                                                      ? Colors.amber
                                                      : Colors.grey,
                                                ),
                                                onPressed: () {
                                                  toggleFavoriteSpeaker(
                                                          Map<String, dynamic>.from(
                                                              tmpPerson))
                                                      .then((_) {
                                                    setState(() {});
                                                    setStateDialog(() {
                                                      isFav = isFavoriteSpeaker(
                                                          speaker['symbol']
                                                              .toString());
                                                    });
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          content: UserCard(
                                            wholeObject: tmpPerson,
                                            onTap: (x) {
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      speaker["name"] ?? "Unknown",
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    isFavoriteSpeaker(speaker['symbol'].toString())
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: isFavoriteSpeaker(
                                            speaker['symbol'].toString())
                                        ? Colors.amber
                                        : Colors.grey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            );
                          }),
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