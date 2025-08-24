// Import the Flutter Material library for widgets like Scaffold, AppBar, ListView, etc.
import 'package:flutter/material.dart';
// Import the beacon scanning plugin you're using (DCHS Flutter Beacon).
// This provides Beacon, Region, and DchsFlutterBeacon classes.
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
// Import the permission_handler plugin for requesting runtime permissions.
import 'package:permission_handler/permission_handler.dart';
// Import 'dart:async' to use StreamSubscription
import 'dart:async';

// -----------------------------------------------------------------------------
// 1) A tiny data holder class that pairs a Beacon object with a human-readable name
// -----------------------------------------------------------------------------

// Define a simple immutable class to couple a Beacon with a display name.
class NamedBeacon {
  // The raw beacon data from the scanner (contains UUID, major, minor, RSSI, etc.).
  final Beacon beacon;
  // A friendly label you assign based on major/minor (e.g., "black", "white").
  final String name;

  // Const-style constructor with required named parameters; sets both fields.
  const NamedBeacon({required this.beacon, required this.name});
}

// -----------------------------------------------------------------------------
// 2) The stateful widget that renders the screen and manages scanning lifecycle
// -----------------------------------------------------------------------------

// Declare a stateful widget because we have dynamic data (beacons list) that changes over time.
class BeaconTest extends StatefulWidget {
  // Optional key for widget identity in Flutter trees; calling super passes it to parent.
  const BeaconTest({super.key});

  // Create the mutable State object tied to this widget.
  @override
  State<BeaconTest> createState() => _BeaconTestState();
}

// The State class holds mutable fields and lifecycle methods (initState/dispose/build).
class _BeaconTestState extends State<BeaconTest> {
  // A list of NamedBeacon objects we maintain as the current "view model".
  final List<NamedBeacon> _beacons = [];
  // The scanner instance. 'late final' means it will be initialized once.
  late final DchsFlutterBeacon _beaconScanner;
  // A subscription to the beacon stream to allow for proper cleanup in dispose().
  StreamSubscription<RangingResult>? _rangingSubscription;

  // initState is called once when the State is inserted into the widget tree.
  @override
  void initState() {
    // Always call super.initState() first to let Flutter run its setup.
    super.initState();
    // Create the scanner instance.
    _beaconScanner = DchsFlutterBeacon();
    // Kick off your async initialization (permissions + start scanning).
    _initBeacon();
  }

  // Async function to request permissions, initialize scanning, and start listening to ranges.
  Future<void> _initBeacon() async {
    // --- Step 1: Request the runtime permissions you need for BLE scanning. ---
    final granted = await _requestPermissions();
    if (!granted) {
      debugPrint('Permissions not granted.');
      return;
    }

    // --- Step 2: Initialize the scanner.
    try {
      // CORRECTED: Remove parentheses as this is a getter.
      await _beaconScanner.initializeScanning;
    } catch (e) {
      debugPrint('Error initializing beacon scanning: $e');
      return;
    }

    // --- Step 3: Define the regions (filters) to range for. ---
    final regions = [
      Region(
        identifier: 'HolyIoTBeacon',
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825',
      )
    ];

    // --- Step 4: Start ranging and listen to the stream of results. ---
    // CORRECTED: Store the subscription to cancel it later.
    _rangingSubscription = _beaconScanner.ranging(regions).listen((RangingResult result) {
      setState(() {
        final List<NamedBeacon> updatedBeacons = [];
        final Map<String, Beacon> newBeaconsMap = {
          for (var b in result.beacons)
            '${b.proximityUUID}-${b.major}-${b.minor}': b
        };
        final Set<String> foundKeys = {};

        String getNameForBeacon(Beacon b) {
          if (b.major == 10011 && b.minor == 1) {
            return 'black';
          } else if (b.major == 10011 && b.minor == 2) {
            return 'white';
          } else if (b.major == 10011 && b.minor == 3) {
            return 'green';
          }
          return 'Unknown Beacon';
        }

        // Pass 1: Update existing beacons that are still in range
        for (final oldNamedBeacon in _beacons) {
          final key = '${oldNamedBeacon.beacon.proximityUUID}-${oldNamedBeacon.beacon.major}-${oldNamedBeacon.beacon.minor}';
          if (newBeaconsMap.containsKey(key)) {
            updatedBeacons.add(NamedBeacon(
              beacon: newBeaconsMap[key]!,
              name: getNameForBeacon(newBeaconsMap[key]!),
            ));
            foundKeys.add(key);
          } else {
            updatedBeacons.add(oldNamedBeacon);
          }
        }

        // Pass 2: Add any new beacons detected in the current scan
        for (final newBeacon in result.beacons) {
          final key = '${newBeacon.proximityUUID}-${newBeacon.major}-${newBeacon.minor}';
          if (!foundKeys.contains(key)) {
            updatedBeacons.add(NamedBeacon(
              beacon: newBeacon,
              name: getNameForBeacon(newBeacon),
            ));
          }
        }

        _beacons.clear();
        _beacons.addAll(updatedBeacons);
      });
    });
  }

  Future<bool> _requestPermissions() async {
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    final locationStatus = await Permission.locationWhenInUse.request();

    return bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted;
  }

  // dispose() is called once when the State is permanently removed from the tree.
  @override
  void dispose() {
    // CORRECTED: Cancel the stream subscription to prevent leaks.
    _rangingSubscription?.cancel();
    // CORRECTED: Remove parentheses as this is a getter.
    _beaconScanner.close;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final closestBeacon = _beacons.isNotEmpty
        ? _beacons.reduce((a, b) => a.beacon.rssi > b.beacon.rssi ? a : b)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Beacon Test')),
      body: _beacons.isEmpty
          ? const Center(child: Text('No beacons detected'))
          : ListView.builder(
              itemCount: _beacons.length,
              itemBuilder: (context, index) {
                final namedBeacon = _beacons[index];
                final isClosest = namedBeacon == closestBeacon;
                
                return ListTile(
                  tileColor: isClosest ? Colors.yellow.withOpacity(0.3) : null,
                  title: Text('Name: ${namedBeacon.name}'),
                  subtitle: Text(
                      'Major: ${namedBeacon.beacon.major}, Minor: ${namedBeacon.beacon.minor}, RSSI: ${namedBeacon.beacon.rssi}'),
                );
              },
            ),
    );
  }
}