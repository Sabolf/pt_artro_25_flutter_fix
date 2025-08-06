import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/cached_request.dart';
import 'package:pt_25_artro_test/screens/day_detail_screen.dart';
import '../widgets/expandable_text.dart';
import '../widgets/user_card.dart';
import '../widgets/room_selection.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  //MAP<String Key, Value>?
  Map<String, dynamic>? _apiData;
  List<dynamic> dayTabs = [];
  List<Widget> dayTabView = [];
  List<dynamic> dayRoomAmounts = [];

  @override
  void initState() {
    //When the app loads
    super.initState(); //<-REQUIRED
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

          //checks for each day and then adds it to the array

          data.forEach((key, value) {
            if (key == 'day0' ||
                key == 'day1' ||
                key == 'day2' ||
                key == 'day3') {
              dayTabs.add(value);
            } else if (key == "day0rooms" ||
                key == "day1rooms" ||
                key == "day2rooms" ||
                key == "day3rooms") {
              dayRoomAmounts.add(value);
            }

            //-------------------------------------- Make The Day Tabs Dynamically
          });
          for (var i = 0; i < dayTabs.length; i++) {
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
                        "Favorites",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
          );

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
                        "Sponsors",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {},
            ),
          );
        }
      },
    );

    // if (data != null) {
    //   //rebuild the value to
    //   setState(() {
    //     _apiData = data;
    //   });
    // }
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: (Text(
                    "DATA IS LOADING",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
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
          children: dayTabView ,
          
        ),
      ),
    ); // top will have my component with buttons from a seperate compinent
  }
}
