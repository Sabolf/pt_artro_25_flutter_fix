// Flutter's core UI library
import 'package:flutter/material.dart';

// Import custom screens (widgets for each tab)
import 'screens/home_screen.dart';
import 'screens/location_screen.dart';
// Import the drawer widget used for navigation
import 'widgets/app_drawer.dart';
import 'screens/qr_screen.dart';
import 'screens/program_screen.dart';
import 'screens/speakers_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/sponsors_screen.dart';

/// ---
/// ENTRY POINT OF THE APP
void main() {
  // runApp tells Flutter what widget to display first — this becomes the root of the widget tree
  runApp(MyApp());
}

/// ---
/// A StatelessWidget means this widget never changes (no internal state)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // The build method describes what the UI should look like
  // context = location of this widget in the widget tree
  Widget build(BuildContext context) {
    // MaterialApp provides app-wide configuration: theme, routing, etc.
    return MaterialApp(
      title:
          'Drawer Navigation Demo', // App title shown in Android task switcher
      theme: ThemeData(
        primarySwatch: Colors.red, // Sets the primary color scheme
      ),
      home:
          MainScreen(), // This is the screen that loads first when the app starts
    );
  }
}

/// ---
/// A StatefulWidget can change over time (e.g., switching between tabs)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // This connects the widget to its state class (logic and mutable data)
  _MainScreenState createState() => _MainScreenState();
}

/// ---
/// The state (logic + data + UI) for MainScreen
class _MainScreenState extends State<MainScreen> {
  // Tracks which tab/screen is currently selected
  int _selectedIndex = 0;

  // List of widgets that represent each screen
  final List<Widget> _screens = [
    HomeScreen(), // 0
    LocationScreen(), // 1
    QrScreen(), // 2
    ProgramScreen(), // 3
    SpeakersListScreen(), //4
    SponsorsScreen() // 5

  ];

  // Titles that match each screen — shown in AppBar
  final List<String> _titles = ['Home', 'Location', 'QR CODE', 'Program', 'Speakers', 'Sponsors'];

  // Called when a tab in the drawer is tapped
  void _selectTab(int index, {bool fromDrawer = true}) {
    setState(() {
      _selectedIndex = index; // Update which screen is shown
    });

    if (fromDrawer) {
      // Close the drawer after selecting a tab
      Navigator.of(context).pop();
    }
  }

  /// ---
  /// Builds the UI of this state
  @override
  Widget build(BuildContext context) {
    // Scaffold gives structure: AppBar, Drawer, Body, etc.
    return Scaffold(
      // Top app bar (shows the screen title)
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {
              _selectTab(2, fromDrawer: false);
            },
            icon: Icon(Icons.qr_code),
          ),
        ], // Set title based on current tab
      ),
      // Drawer (side menu)
      drawer: AppDrawer(
        selectedIndex: _selectedIndex, // Tell drawer which tab is active
        onSelectTab: _selectTab, // Pass the tab-switching function
      ),
      // Body of the screen — shows the selected screen's widget
      body: _screens[_selectedIndex],
    );
  }
}
