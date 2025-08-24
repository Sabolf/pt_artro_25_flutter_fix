import 'package:flutter/material.dart';
// Import custom screens
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

// Import the drawer widget
import 'widgets/app_drawer.dart';

// Import the new screens for routes
import 'screens/ask_question_screen.dart';

// Flutter localization
import 'package:flutter_localizations/flutter_localizations.dart';
// Generated localization (use alias)
import 'l10n/app_localizations.dart' as loc;

/// ENTRY POINT
void main() {
  runApp(const MyApp());
}

/// StatelessWidget: does not hold state
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Navigation Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      localizationsDelegates: const [
        loc.AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('pl', ''), // Polish
      ],
      home: const MainScreen(),
      routes: {'/askQuestion': (context) => const AskQuestionScreen()},
    );
  }
}

/// StatefulWidget: holds state (like selected tab)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

/// State for MainScreen
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProgramScreen(),
    PlanScreen(),
    SpeakersListScreen(),
    SponsorsScreen(),
    LocationScreen(),
    ArthrexScreen(),
    MessagesScreen(),
    BeaconTest(),
  ];

  /// Returns the localized titles dynamically
  List<String> _titles(BuildContext context) {
    final locData = loc.AppLocalizations.of(context)!;
    return [
      locData.meeting_pt,
      locData.program,
      locData.building_plan,
      locData.speakers,
      locData.sponsor_title,
      locData.location,
      locData.menu_sn,
      locData.messages,
      'beacon Test',
    ];
  }

  void _selectTab(int index, {bool fromDrawer = true}) {
    setState(() {
      _selectedIndex = index;
    });

    if (fromDrawer) {
      Navigator.of(context).pop();
    }
  }

  void _handleQrCodeResult(String? result) {
    if (result == null) return;

    if (result.contains("SPONSOR:ARTHREX")) {
      _selectTab(7, fromDrawer: false);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scanned: $result')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = _titles(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => const QrScreen()))
                  .then((result) => _handleQrCodeResult(result as String?));
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      drawer: AppDrawer(selectedIndex: _selectedIndex, onSelectTab: _selectTab),
      body: _screens[_selectedIndex],
    );
  }
}
