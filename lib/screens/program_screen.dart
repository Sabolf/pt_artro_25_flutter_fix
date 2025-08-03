import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/cached_request.dart';
import '../widgets/expandable_text.dart';
import '../widgets/user_card.dart';

class ProgramScreen extends StatefulWidget {
  const ProgramScreen({super.key});

  @override
  State<ProgramScreen> createState() => _ProgramScreenState();
}

class _ProgramScreenState extends State<ProgramScreen> {
  //MAP<String Key, Value>?
  Map<String, dynamic>? _apiData;

  @override
  void initState() {
    //When the app loads
    super.initState(); //<-REQUIRED
    _loadData();
  }

  Future<void> _loadData() async {
    final data = null;

    cachedRequest.readDataOrCached(
      endpoint: 'https://voteptartro.wisehub.pl/api/?action=get-program-flat',
      method: 'GET',
      onData: (data) {
        if (data != null) {
          setState(() {
            _apiData = data;
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
    return const Text("THIS SHIT HAS LOADED");
  }
}
