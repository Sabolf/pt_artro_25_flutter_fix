// program_screen.dart

import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/cached_request.dart';
import 'package:pt_25_artro_test/screens/day_detail_screen.dart';
import 'favorite_screen.dart';
import '../l10n/app_localizations.dart' as loc;
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
    // This ensures context is available when _loadData is called.
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData(context));
  }

  Future<void> _loadData(BuildContext context) async {
    final locData = loc.AppLocalizations.of(context)!;

    cachedRequest.readDataOrCached(
      endpoint: 'https://voteptartro.wisehub.pl/api/?action=get-program-flat',
      method: 'GET',
      onData: (data) {
        if (data != null) {
          setState(() {
            _apiData = data;
            dayTabs.clear();
            dayTabView.clear();
            dayRoomAmounts.clear();
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
              
              // Use the language-specific place fields directly from the session
              final currentLocale = Localizations.localeOf(context).languageCode;
              String roomName;
              
              if (currentLocale == 'pl') {
                roomName = session['place_pl'] ?? session['place_en'] ?? 'Unknown Room';
              } else {
                roomName = session['place_en'] ?? session['place_pl'] ?? 'Unknown Room';
              }
              session['room'] = roomName;
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
                          "${locData.day} ${i + 1}",
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
                    child: Center(
                      child: Text(
                        locData.favorites,
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
                    child: Center(
                      child: Text(
                        locData.my_questions,
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
    final locData = loc.AppLocalizations.of(context)!;
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    locData.load,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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