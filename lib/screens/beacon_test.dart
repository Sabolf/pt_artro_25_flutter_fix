import 'package:flutter/material.dart'; // Imports the core Flutter Material library, which contains all the standard UI widgets and tools.
// This is required for building a visual application.

import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart'; // Imports a third-party plugin specifically for interacting with Bluetooth Low Energy (BLE) beacons.
// This library provides the classes and methods needed to scan for beacons.

import 'package:permission_handler/permission_handler.dart'; // Imports a plugin that simplifies requesting and checking runtime permissions on Android and iOS.
// This is necessary because beacon scanning requires Bluetooth and location permissions.

import 'dart:async'; // Imports the 'dart:async' library, which provides classes for working with asynchronous operations, like Streams and Futures.
// It's needed for the StreamSubscription class, which manages the stream of beacon data.

// -----------------------------------------------------------------------------
// 1) A tiny data holder class that pairs a Beacon object with a human-readable name
// -----------------------------------------------------------------------------

// Defines a new class to combine beacon data with a simple name.
class NamedBeacon {
  // A final field to hold a Beacon object, which contains all the raw data from the scanned beacon. 'final' means it can only be set once.
  final Beacon beacon;
  // A final field to hold a descriptive name for the beacon, like "black" or "white".
  final String name;

  // A constant constructor. It requires a Beacon object and a String name to create a new NamedBeacon instance.
  const NamedBeacon({required this.beacon, required this.name});
}

// -----------------------------------------------------------------------------
// 2) The stateful widget that renders the screen and manages scanning lifecycle
// -----------------------------------------------------------------------------

// Defines a StatefulWidget, a type of widget that can have mutable state that changes over time.
class BeaconTest extends StatefulWidget {
  // A constructor for the widget, accepting an optional 'key' to identify it uniquely in the widget tree.
  const BeaconTest({super.key});

  // Overrides the createState method to create the mutable state object for this widget.
  @override
  State<BeaconTest> createState() => _BeaconTestState();
}

// This is the private State class that holds the mutable data for the BeaconTest widget.
class _BeaconTestState extends State<BeaconTest> {
  // A list of NamedBeacon objects to store all detected beacons. 'final' means the list itself cannot be reassigned, but its contents can be modified.
  final List<NamedBeacon> _beacons = [];
  // A 'late final' field for the beacon scanner instance. 'late' means it will be initialized later, but before its first use. 'final' means it will only be initialized once.
  late final DchsFlutterBeacon _beaconScanner;
  // A nullable StreamSubscription. This will hold the subscription to the beacon stream so it can be canceled later to prevent memory leaks.
  StreamSubscription<RangingResult>? _rangingSubscription;

  // The `initState` method is part of the Flutter widget lifecycle and is called exactly once when the widget is inserted into the widget tree.
  @override
  void initState() {
    // Calls the parent class's `initState` method first, which is a required best practice.
    super.initState();
    // Initializes the beacon scanner instance.
    _beaconScanner = DchsFlutterBeacon();
    // Calls the asynchronous function to start the beacon scanning process.
    _initBeacon();
  }

  // An asynchronous function to handle the entire beacon initialization and scanning process.
  Future<void> _initBeacon() async {
    // --- Step 1: Request the runtime permissions you need for BLE scanning. ---
    final granted = await _requestPermissions(); // Calls the permission request function and waits for its result.
    if (!granted) { // Checks if permissions were not granted.
      debugPrint('Permissions not granted.'); // Prints a debug message.
      return; // Exits the function if permissions were denied.
    }

    // --- Step 2: Initialize the scanner.
    try { // Begins a try-catch block to handle potential errors during initialization.
      // CORRECTED: await _beaconScanner.initializeScanning;
      await _beaconScanner.initializeScanning; // Asynchronously initializes the beacon scanner and waits for it to complete.
    } catch (e) { // Catches any exceptions thrown during initialization.
      debugPrint('Error initializing beacon scanning: $e'); // Prints the error to the console.
      return; // Exits the function.
    }

    // --- Step 3: Define the regions (filters) to range for. ---
    final regions = [ // Defines a list of Region objects to specify which beacons to look for.
      Region( // Creates a Region object.
        identifier: 'HolyIoTBeacon', // A friendly name for the region.
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825', // The unique ID of the beacons to scan for.
      )
    ];

    // --- Step 4: Start ranging and listen to the stream of results. ---
    // CORRECTED: Store the subscription to cancel it later.
    _rangingSubscription = _beaconScanner.ranging(regions).listen((RangingResult result) { // Starts the ranging process for the defined regions and listens to the stream of results.
      setState(() { // Calls `setState` to rebuild the UI with new data.
        final List<NamedBeacon> updatedBeacons = []; // A temporary list to build the new list of beacons.
        final Map<String, Beacon> newBeaconsMap = { // Creates a map for quick lookup of newly found beacons.
          for (var b in result.beacons) // Iterates through the list of beacons from the ranging result.
            '${b.proximityUUID}-${b.major}-${b.minor}': b // Creates a unique key for each beacon and adds it to the map.
        };
        final Set<String> foundKeys = {}; // A set to keep track of beacons that have been processed.

        String getNameForBeacon(Beacon b) { // A helper function to assign a name based on major/minor IDs.
          if (b.major == 10011 && b.minor == 1) { // Checks for a specific major and minor ID.
            return 'black'; // Returns "black" if the conditions are met.
          } else if (b.major == 10011 && b.minor == 2) { // Checks for another specific major and minor ID.
            return 'white'; // Returns "white".
          } else if (b.major == 10011 && b.minor == 3) { // Checks for another specific major and minor ID.
            return 'green'; // Returns "green".
          }
          return 'Unknown Beacon'; // Returns "Unknown Beacon" if no match is found.
        }

        // Pass 1: Update existing beacons that are still in range
        for (final oldNamedBeacon in _beacons) { // Iterates through the currently displayed beacons.
          final key = '${oldNamedBeacon.beacon.proximityUUID}-${oldNamedBeacon.beacon.major}-${oldNamedBeacon.beacon.minor}'; // Creates a unique key for the current beacon.
          if (newBeaconsMap.containsKey(key)) { // Checks if the beacon from the old list is also in the new scan result.
            updatedBeacons.add(NamedBeacon( // If yes, adds an updated version of the beacon to the new list.
              beacon: newBeaconsMap[key]!, // Gets the latest data for the beacon.
              name: getNameForBeacon(newBeaconsMap[key]!), // Gets the name for the updated beacon.
            ));
            foundKeys.add(key); // Adds the key to a set to prevent re-adding it later.
          } else { // If the old beacon is no longer in range.
            updatedBeacons.add(oldNamedBeacon); // Adds the old beacon to the list (this part might be a bug, as it would never remove old beacons unless changed).
          }
        }

        // Pass 2: Add any new beacons detected in the current scan
        for (final newBeacon in result.beacons) { // Iterates through the beacons from the latest scan.
          final key = '${newBeacon.proximityUUID}-${newBeacon.major}-${newBeacon.minor}'; // Creates a unique key for the new beacon.
          if (!foundKeys.contains(key)) { // Checks if the beacon is genuinely new (not already processed in Pass 1).
            updatedBeacons.add(NamedBeacon( // If it's a new beacon, adds it to the list.
              beacon: newBeacon, // The new beacon data.
              name: getNameForBeacon(newBeacon), // The name for the new beacon.
            ));
          }
        }

        _beacons.clear(); // Clears the original list of beacons.
        _beacons.addAll(updatedBeacons); // Replaces the old list with the newly built updated list.
      });
    });
  }

  Future<bool> _requestPermissions() async { // An asynchronous function to request necessary permissions.
    final bluetoothScanStatus = await Permission.bluetoothScan.request(); // Requests permission to scan for Bluetooth devices and waits for the user's response.
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request(); // Requests permission to connect to Bluetooth devices and waits for the user's response.
    final locationStatus = await Permission.locationWhenInUse.request(); // Requests location permission (required for BLE scanning) and waits for the user's response.

    return bluetoothScanStatus.isGranted && // Returns true only if all three permissions were granted by the user.
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted;
  }

  // The `dispose` method is part of the Flutter widget lifecycle and is called when the widget is permanently removed from the tree.
  @override
  void dispose() {
    // CORRECTED: _rangingSubscription?.cancel();
    _rangingSubscription?.cancel(); // Cancels the stream subscription to stop listening for new beacons and prevent memory leaks.
    // CORRECTED: _beaconScanner.close;
    _beaconScanner.close; // Closes the beacon scanner to release system resources.
    super.dispose(); // Always call the parent class's `dispose` method last.
  }

  @override
  Widget build(BuildContext context) { // The `build` method is where the UI is defined. It runs every time the state changes.
    final closestBeacon = _beacons.isNotEmpty // A conditional expression to find the beacon with the highest RSSI (closest).
        ? _beacons.reduce((a, b) => a.beacon.rssi > b.beacon.rssi ? a : b) // If the list is not empty, it finds the beacon with the highest RSSI value.
        : null; // If the list is empty, `closestBeacon` is null.

    return Scaffold( // A basic widget that provides the app bar and a body for the screen.
      appBar: AppBar(title: const Text('Beacon Test')), // The top app bar with a title.
      body: _beacons.isEmpty // Checks if the beacons list is empty.
          ? const Center(child: Text('No beacons detected')) // If empty, displays a centered text message.
          : ListView.builder( // If not empty, builds a scrollable list of beacons.
              itemCount: _beacons.length, // Sets the number of items in the list to the number of beacons.
              itemBuilder: (context, index) { // A function that builds a widget for each item in the list.
                final namedBeacon = _beacons[index]; // Gets the `NamedBeacon` object for the current index.
                final isClosest = namedBeacon == closestBeacon; // Checks if the current beacon is the closest one.
                
                return ListTile( // A convenient widget to display a single row item in a list.
                  tileColor: isClosest ? Colors.yellow.withOpacity(0.3) : null, // Sets a background color if the beacon is the closest one.
                  title: Text('Name: ${namedBeacon.name}'), // Displays the name of the beacon.
                  subtitle: Text( // Displays the details of the beacon.
                      'Major: ${namedBeacon.beacon.major}, Minor: ${namedBeacon.beacon.minor}, RSSI: ${namedBeacon.beacon.rssi}'),
                );
              },
            ),
    );
  }
}