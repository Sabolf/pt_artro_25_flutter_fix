import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../widgets/user_card.dart';
import '../screens/person_detail_screen.dart';

class SpeakersListScreen extends StatefulWidget {
  const SpeakersListScreen({super.key});

  @override
  State<SpeakersListScreen> createState() => _SpeakersListScreenState();
}

class _SpeakersListScreenState extends State<SpeakersListScreen> {
  // Initialize lists to empty to avoid LateInitializationError
  List<dynamic> allSpeakers = [];
  List<dynamic> filteredSpeakers = [];
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
        filteredSpeakers = peopleJson; // Initialize filtered list as well
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

  // This method handles the search logic
  void filterSpeakers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSpeakers = allSpeakers;
      } else {
        filteredSpeakers = allSpeakers.where((speaker) {
          final nameLower = speaker['name']?.toLowerCase() ?? '';
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle case where no speakers are found
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
              onChanged: filterSpeakers, // Call filterSpeakers on text change
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
            itemCount:
                filteredSpeakers.length, // Use the filtered list for the count
            itemBuilder: (context, index) {
              final speaker =
                  filteredSpeakers[index]; // Use the filtered list for the item
              return UserCard(
                imagePathWay: '',
                wholeObject: speaker,
                onTap: (x) {
                    print("Pulling info from ${x['name']}");
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetailScreen(speaker: speaker,)));
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
