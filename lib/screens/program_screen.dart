import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/cached_request.dart';
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
            

            if (key == 'day0' || key =='day1' || key == 'day2' || key == 'day3') {
              dayTabs.add(value);
            }
            else if (key == "day0rooms" || key == "day1rooms"|| key == "day2rooms" || key == "day3rooms" ){
              dayRoomAmounts.add(value);
            }
          });
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
      child: (Column(children: [
      ],)),
    ); // top will have my component with buttons from a seperate compinent
  }
}
