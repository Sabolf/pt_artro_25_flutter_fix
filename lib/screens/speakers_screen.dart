import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/user_card.dart';
import '../screens/person_detail_screen.dart';

class SpeakersListScreen extends StatefulWidget {
  const SpeakersListScreen({super.key});

  @override
  State<SpeakersListScreen> createState() => _SpeakersListScreenState();
}

class _SpeakersListScreenState extends State<SpeakersListScreen> {
  List<dynamic> allSpeakers = [];
  List<dynamic> filteredSpeakers = [];
  bool isLoading = true;

  // Store full favorite speaker objects here
  List<Map<String, dynamic>> favoriteSpeakers = [];

  @override
  void initState() {
    super.initState();
    loadPeopleJson();
    loadFavorites();
  }

  Future<void> loadPeopleJson() async {
    try {
      final String peopleString = await rootBundle.loadString('assets/data/people.json');
      final List<dynamic> peopleJson = jsonDecode(peopleString);
      setState(() {
        allSpeakers = peopleJson;
        filteredSpeakers = peopleJson;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading JSON: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favListString = prefs.getString('favoriteSpeakers') ?? '[]';

    try {
      final List<dynamic> favListDecoded = jsonDecode(favListString);
      setState(() {
        favoriteSpeakers = favListDecoded.cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print("Error decoding favorites: $e");
      setState(() {
        favoriteSpeakers = [];
      });
    }
  }

  void filterSpeakers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSpeakers = allSpeakers;
      } else {
        filteredSpeakers = allSpeakers.where((speaker) {
          final nameLower = speaker['name']?.toString().toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();
      }
    });
  }

  bool isFavorite(String speakerId) {
    return favoriteSpeakers.any((s) => s['id'].toString() == speakerId);
  }

  Future<void> toggleStar(dynamic speakerId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final existingIndex = favoriteSpeakers.indexWhere(
        (s) => s['id'].toString() == speakerId.toString(),
      );

      if (existingIndex >= 0) {
        favoriteSpeakers.removeAt(existingIndex);
      } else {
        // Add full speaker object to favorites
        final speakerToAdd = allSpeakers.firstWhere(
          (sp) => sp['id'].toString() == speakerId.toString(),
          orElse: () => null,
        );
        if (speakerToAdd != null) {
          favoriteSpeakers.add(Map<String, dynamic>.from(speakerToAdd));
        }
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers));
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (allSpeakers.isEmpty) {
      return const Center(child: Text("No speakers found."));
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: TextField(
              onChanged: filterSpeakers,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "Search For Speaker",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredSpeakers.length,
            itemBuilder: (context, index) {
              final speaker = filteredSpeakers[index];
              final speakerId = speaker['id'].toString();

              return UserCard(
                wholeObject: speaker,
                onTap: (x) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonDetailScreen(speaker: speaker),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: Icon(
                    isFavorite(speakerId) ? Icons.star : Icons.star_border,
                    color: isFavorite(speakerId) ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => toggleStar(speakerId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
