import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/location_screen.dart';
import 'screens/qr_screen.dart';
import 'screens/program_screen.dart';
import 'screens/speakers_screen.dart';
import 'screens/sponsors_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/arthrex_screen.dart';
import 'screens/beacon_test.dart';
import 'screens/messages.dart';
import 'widgets/app_drawer.dart';
import 'screens/ask_question_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart' as loc;

//Main is the ENTRY part of the APP
void main() {
  runApp(const MyApp()); //Inserts a Widget To be the ROOT of the APP
}

class MyApp extends StatelessWidget {
  //MyApp NOW BECOMES THE ROOT OF THE APP
  const MyApp({super.key});

  @override
  //Context is the widgets address in the widget tree
  Widget build(BuildContext context) {
    //BUILD describes how to display the WIDGET
    //BUILD ALWAYS RETURNS A WIDGET

    return MaterialApp(
      //Wrapper for the APP --> INCLUDING
      //GLOBAL SETTINGS
      title: 'PT-ARTRO_25',
      theme: ThemeData(primarySwatch: Colors.red), //THEME OF THE APP
      localizationsDelegates: const [
        loc
            .AppLocalizations
            .delegate, //Comes from the translation list made in l10n
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // Which LANGUAGES ARE SUPPORTED
        Locale('en', ''), // English
        Locale('pl', ''), // Polish
      ],
      home: const MainScreen(), //Default SCREEN
      //GLOBAL ACCESSIBLE ROUTE TO MAKE IT EASIER
      //TO ASK THIS SCREEN LATER
      routes: {'/askQuestion': (context) => const AskQuestionScreen()},
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // WHICH SCREEN IS BEING SELECTED
  int _selectedIndex = 0; //DEFAULT IS 0

  final List<Widget> _screens = [
    //The different Screen Widgets
    HomeScreen(), // 0
    ProgramScreen(), // 1
    PlanScreen(), // 2
    SpeakersListScreen(), // 3
    SponsorsScreen(), // 4
    LocationScreen(), // 5
    ArthrexScreen(), // 6
    MessagesScreen(), // 7
    BeaconTest(), // 8
  ];

  List<String> _titles(BuildContext context) { // TITLES FOR THE APPBAR
    //BUILD CONTEXT IS REQUIRED BECAUSE IT GIVES CONTEXT
    //ON WHICH LANGUAGE IS CURRENTLY BEINGUSED
    final locData = loc.AppLocalizations.of(context)!; //language list from l10
    //applocalizations from language portion < -- context is required to know
    //which language is being used
    return [
      locData.meeting_pt, // 0
      locData.program, // 1
      locData.building_plan,// 2
      locData.speakers,// 3
      locData.sponsor_title,// 4
      locData.location,// 5
      locData.menu_sn,// 6
      locData.messages,// 7
      'beacon Test', // 8
    ];
  }

// This Call back is sent to Custom App Drawer as a callback
// The Drawer will return a number depending on a tab selected
// Into this as index
  void _selectTab(int index, {bool fromDrawer = true}) { //Change Screen
    setState(() { //setState tells flutter to rebuild widget (usestate)
      _selectedIndex = index; //Global variable changes to new screen index
    });

    if (fromDrawer) { //if the screen being navigated to is in the drawer widgit
      Navigator.of(context).pop(); //remove from stack
    }
  }

  void _handleQrCodeResult(String? result) { // PROCESS QR CODE RESULTS
    if (result == null) return; // IF NULL JUST EXIT 

    if (result.contains("SPONSOR:ARTHREX")) { //ARTHREX IS SPONSOR then
      _selectTab(6, fromDrawer: false); // GO TO ARTHREX TAB
    } else {
      ScaffoldMessenger.of( // TEMP MESSAGE WILL SHOW 
        context, //CONTEXT REQUIRED
      ).showSnackBar(SnackBar(content: Text('Scanned: $result'))); // SHOWING RESULT
    }
  }

  @override
  Widget build(BuildContext context) { //DESCRIBE HOW TO DISPLAY WIDGET
    final titles = _titles(context); //TITLES FOR APP BAR

    return Scaffold(//BASIC LAY OUT COMPONENT
      appBar: AppBar( //TOP BAR
        title: Text(titles[_selectedIndex]), //TITLE FROM CORRESPONDING INDEX
        actions: [ //Things in the app bar
          IconButton( //Button that is an icon
            onPressed: () { //When it is pressed
              Navigator.of(context) //Navigator using current context
                  .push(MaterialPageRoute(builder: (ctx) => const QrScreen()))
                  //Push -> Navigate to QR screen
                  //MPR -> creates animation on android
                  //builds the QR SCREEN to navigate to
                  .then((result) => _handleQrCodeResult(result as String?));
                  // ******** .THEN  MAKES IT SO THAT NOW 
                  //THIS CODE AFTER .THEN WILL RUN AFTER THE SCREEN IS POPPED
                  //WHEN QR CODE SCANS SOMETHING IT WILL POP AND RETURN DATA
                  
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      drawer: AppDrawer(selectedIndex: _selectedIndex, onSelectTab: _selectTab),
      //DRAWER COMPONENT TO LEFT SIDE OF SCREEN
      //APP DRAWER IS A CUSTOM WIDGET I MADE
      //CURRENT INDEX THAT IS SELECTED
      //CALL BACK THAT CALL SELECT TAB
      body: _screens[_selectedIndex],
      //BODY will display the current selected index from the widgets
    );
  }
}
