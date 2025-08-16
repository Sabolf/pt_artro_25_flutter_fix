import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:pt_25_artro_test/widgets/user_card.dart';
import 'person_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteSpeakers = [];
  List<Map<String, dynamic>> favoriteSessions = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
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
      final index = favoriteSpeakers.indexWhere((s) => s['id'] == speaker['id']);
      if (index >= 0) {
        favoriteSpeakers.removeAt(index);
      } else {
        favoriteSpeakers.add(speaker);
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers));
  }

  Future<void> toggleFavoriteSession(Map<String, dynamic> session) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final index = favoriteSessions.indexWhere((s) => s['id'] == session['id']);
      if (index >= 0) {
        favoriteSessions.removeAt(index);
      } else {
        favoriteSessions.add(session);
      }
    });

    await prefs.setString('favoriteSessions', jsonEncode(favoriteSessions));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorites")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (favoriteSessions.isNotEmpty) ...[
              const Text("Favorite Sessions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...favoriteSessions.map((session) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    title: Text(session['title_pl'] ?? session['title_en'] ?? "No Title"),
                    subtitle: Text(
                      "Day: ${session['day'] ?? ''} | Room: ${session['room'] ?? ''} | ${session['start_time'] ?? ''}-${session['end_time'] ?? ''}"
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.star, color: Colors.amber),
                      onPressed: () => toggleFavoriteSession(session),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(session['title_pl'] ?? session['title_en'] ?? "Session"),
                          content: Text(session['description'] ?? "No description"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
            if (favoriteSpeakers.isNotEmpty) ...[
              const Text("Favorite Speakers",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...favoriteSpeakers.map((speaker) {
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
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => toggleFavoriteSpeaker(speaker),
                    tooltip: "Remove from favorites",
                  ),
                );
              }),
            ],
            if (favoriteSessions.isEmpty && favoriteSpeakers.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("You have no favorites yet."),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
