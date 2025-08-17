// my_questions_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyQuestionsScreen extends StatefulWidget {
  const MyQuestionsScreen({super.key});

  @override
  State<MyQuestionsScreen> createState() => _MyQuestionsScreenState();
}

class _MyQuestionsScreenState extends State<MyQuestionsScreen> {
  List<Map<String, dynamic>> _askedQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? questionsJson = prefs.getStringList('user_question');

    if (questionsJson != null) {
      setState(() {
        _askedQuestions = questionsJson
            .map((jsonString) => jsonDecode(jsonString) as Map<String, dynamic>)
            .toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return  Scaffold(
        appBar: AppBar(title: Text("My Questions")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_askedQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("My Questions")),
        body: const Center(
          child: Text(
            "You haven't asked any questions yet.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("My Questions")),
      body: ListView.builder(
        itemCount: _askedQuestions.length,
        itemBuilder: (context, index) {
          final question = _askedQuestions[index];
          // Assuming 'title_pl' is the name of the session
          final sessionTitle = question['title'] ?? 'N/A'; // CHANGED THIS LINE
          final myQuestion = question['question'] ?? 'No question text';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                sessionTitle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(myQuestion),
            ),
          );
        },
      ),
    );
  }
}