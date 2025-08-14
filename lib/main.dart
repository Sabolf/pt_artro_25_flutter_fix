import 'package:flutter/material.dart';

// Import custom screens (widgets for each tab)
import 'screens/home_screen.dart';
import 'screens/location_screen.dart';
import 'screens/qr_screen.dart';
import 'screens/program_screen.dart';
import 'screens/speakers_screen.dart';
import 'screens/sponsors_screen.dart';
import 'screens/plan_screen.dart';
import 'screens/arthrex_screen.dart';

// Import the drawer widget used for navigation
import 'widgets/app_drawer.dart';

// Import the new screens to add to the routes
import 'screens/ask_question_screen.dart';

/// ---
/// GLOBAL KEY is no longer needed.
// final GlobalKey<_MainScreenState> mainScreenKey = GlobalKey<_MainScreenState>();

/// ---
/// ENTRY POINT OF THE APP
void main() {
  runApp(const MyApp());
}

/// ---
/// A StatelessWidget means this widget never changes (no internal state)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // The home property is a more direct way to start with MainScreen
      home: const MainScreen(),
      routes: {
        // You can still keep named routes for other screens if needed
        '/askQuestion': (context) => const AskQuestionScreen(),
      },
    );
  }
}

/// ---
/// A StatefulWidget can change over time (e.g., switching between tabs)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

/// ---
/// The state (logic + data + UI) for MainScreen
class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(), // 0
    LocationScreen(), // 1
    // The QrScreen is a new route, not part of the main body, so we can use a placeholder
    const Text('QR Code scanner is a new route'), // 2
    ProgramScreen(), // 3
    SpeakersListScreen(), // 4
    SponsorsScreen(), // 5
    PlanScreen(), // 6
    ArthrexScreen(), // 7
  ];

  final List<String> _titles = [
    'Home',
    'Location',
    'QR CODE',
    'Program',
    'Speakers',
    'Sponsors',
    'Plan',
    'Arthrex',
  ];

  void _selectTab(int index, {bool fromDrawer = true}) {
    setState(() {
      _selectedIndex = index;
    });

    if (fromDrawer) {
      Navigator.of(context).pop();
    }
  }

  // This method handles the result from the QrScreen after it's popped.
  void _handleQrCodeResult(String? result) {
    if (result == null) return;
    
    // Check for the specific Arthrex code
    if (result.contains("SPONSOR:ARTHREX")) {
      // Switch the main screen's tab
      _selectTab(7, fromDrawer: false);
    } else {
      // Handle other QR codes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {
              // Push the QrScreen as a new route and wait for a result
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const QrScreen()),
              ).then((result) => _handleQrCodeResult(result as String?));
            },
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),
      drawer: AppDrawer(
        selectedIndex: _selectedIndex,
        onSelectTab: _selectTab,
      ),
      body: _screens[_selectedIndex],
    );
  }
}