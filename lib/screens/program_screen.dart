// program_screen.dart

import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/cached_request.dart';
import 'package:pt_25_artro_test/screens/day_detail_screen.dart';
import 'favorite_screen.dart';
// Import the new screen
import 'my_questions_screen.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  Map<String, dynamic>? _apiData;
  List<dynamic> dayTabs = [];
  List<Widget> dayTabView = [];
  List<dynamic> dayRoomAmounts = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    cachedRequest.readDataOrCached(
      endpoint: 'https://voteptartro.wisehub.pl/api/?action=get-program-flat',
      method: 'GET',
      onData: (data) {
        if (data != null) {
          setState(() {
            _apiData = data;
          });

          data.forEach((key, value) {
            if (key.startsWith('day') && !key.contains('rooms')) {
              dayTabs.add(value);
            } else if (key.contains('rooms')) {
              dayRoomAmounts.add(value);
            }
          });

          // Add day info to each session
          for (var i = 0; i < dayTabs.length; i++) {
            for (var session in dayTabs[i]) {
              session['day'] = i + 1; // inject day number
              if (dayRoomAmounts.length > i && session['room_index'] != null) {
                session['room'] = dayRoomAmounts[i][session['room_index']];
              } else {
                session['room'] = session['room'] ?? 'Unknown Room';
              }
            }

            dayTabView.add(
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    height: 70,
                    child: Card(
                      shadowColor: Colors.red,
                      child: Center(
                        child: Text(
                          "Day: ${i + 1}",
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DayDetailScreen(
                        dayRoomAmount: dayRoomAmounts[i],
                        dayInformation: dayTabs[i],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // Favorites button
          dayTabView.add(
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 70,
                  child: Card(
                    shadowColor: Colors.red,
                    child: const Center(
                      child: Text(
                        "Favorites",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
          );

          // Add the new "My Questions" button
          dayTabView.add(
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 70,
                  child: Card(
                    shadowColor: Colors.red,
                    child: const Center(
                      child: Text(
                        "My Questions",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyQuestionsScreen()),
                );
              },
            ),
          );

         
          
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_apiData == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "DATA IS LOADING",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(14.0),
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dayTabView,
        ),
      ),
    );
  }
}