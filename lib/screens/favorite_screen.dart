import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:pt_25_artro_test/widgets/user_card.dart';
import 'person_detail_screen.dart'; // adjust the path as needed

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favoriteSpeakers = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
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

  Future<void> toggleFavorite(Map<String, dynamic> speaker) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      final existingIndex = favoriteSpeakers.indexWhere(
        (s) => s['id'].toString() == speaker['id'].toString(),
      );

      if (existingIndex >= 0) {
        favoriteSpeakers.removeAt(existingIndex);
      } else {
        favoriteSpeakers.add(speaker);
      }
    });

    await prefs.setString('favoriteSpeakers', jsonEncode(favoriteSpeakers));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Speakers")),
      body: favoriteSpeakers.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: favoriteSpeakers.length,
              itemBuilder: (context, index) {
                final speaker = favoriteSpeakers[index];
                return UserCard(
                  wholeObject: speaker,
                  onTap: (x) {
                    // Example: Navigate to person detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonDetailScreen(speaker: speaker),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () => toggleFavorite(speaker),
                    tooltip: "Remove from favorites",
                  ),
                );
              },
            ),
    );
  }
}
