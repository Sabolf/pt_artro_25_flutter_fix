// Import the Flutter Material library for widgets like Scaffold, AppBar, ListView, etc.
import 'package:flutter/material.dart';
// Import the beacon scanning plugin you're using (DCHS Flutter Beacon).
// This provides Beacon, Region, and DchsFlutterBeacon classes.
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
// Import the permission_handler plugin for requesting runtime permissions.
import 'package:permission_handler/permission_handler.dart';

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
  NamedBeacon({required this.beacon, required this.name});
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
  // Using final for the list reference (we mutate contents, not the reference).
  final List<NamedBeacon> _beacons = [];
  // The scanner instance. 'late final' means:
  //  - late: it will be initialized later (not at declaration time),
  //  - final: after first assignment, it can't be reassigned.
  late final DchsFlutterBeacon _beaconScanner;

  // initState is called once when the State is inserted into the widget tree.
  @override
  void initState() {
    // Always call super.initState() first to let Flutter run its setup.
    super.initState();
    // Create the scanner instance you'll use to initialize and start ranging.
    _beaconScanner = DchsFlutterBeacon();
    // Kick off your async initialization (permissions + start scanning).
    _initBeacon();
  }

  // Async function to request permissions, initialize scanning, and start listening to ranges.
  Future<void> _initBeacon() async {
    // --- Step 1: Request the runtime permissions you need for BLE scanning. ---
    final granted = await _requestPermissions();
    // If the user denies, bail out early (no scanning without permissions).
    if (!granted) {
      debugPrint('Permissions not granted.');
      return;
    }

    // --- Step 2: Initialize the scanner. Many plugins need this before scanning. ---
    try {
      // Await the plugin's initialize operation.
      // NOTE: This line assumes `initializeScanning` is a Future-returning *getter*.
      // If it's actually a method, it should be: await _beaconScanner.initializeScanning();
      await _beaconScanner.initializeScanning;
    } catch (e) {
      // If the plugin throws (e.g., hardware off, platform error), log and stop.
      debugPrint('Error initializing beacon scanning: $e');
      return;
    }

    // --- Step 3: Define the regions (filters) to range for. ---
    // A region describes which beacons to look for (UUID, and optionally major/minor).
    final regions = [
      Region(
        // Identifier is an arbitrary string to label this region in logs.
        identifier: 'HolyIoTBeacon',
        // This is the iBeacon UUID to filter on. Only beacons with this UUID will be ranged.
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825',
        // Since major and minor are not specified, ALL majors/minors under this UUID will be detected.
      )
    ];

    // --- Step 4: Start ranging and listen to the stream of results. ---
    // ranging(regions) returns a Stream<RangingResult>. We subscribe with listen(...)
    _beaconScanner.ranging(regions).listen((RangingResult result) {
      // setState schedules a rebuild and allows us to update state safely.
      setState(() {
        // We'll create a fresh list that merges old + new while preserving order and names.
        final List<NamedBeacon> updatedBeacons = [];
        // Build a lookup table from the latest scan: compositeKey -> Beacon.
        // The composite key uniquely identifies a beacon by UUID/major/minor.
        final Map<String, Beacon> newBeaconsMap = {
          for (var b in result.beacons)
            '${b.proximityUUID}-${b.major}-${b.minor}': b
        };
        // Track which keys from the new scan we’ve already handled, to avoid duplicates later.
        final Set<String> foundKeys = {};

        // Helper that maps a beacon's major/minor to a friendly display name.
        String getNameForBeacon(Beacon b) {
          if (b.major == 10011 && b.minor == 1) {
            return 'black';
          } else if (b.major == 10011 && b.minor == 2) {
            return 'white';
          } else if (b.major == 10011 && b.minor == 3) {
            return 'green';
          }
          // Fallback if the major/minor pair isn't recognized.
          return 'Unknown Beacon';
        }

        // --- Pass 1: Walk the previous list and update entries that appeared again. ---
        for (final oldNamedBeacon in _beacons) {
          // Compute the composite key for the old item to see if it reappeared in this scan.
          final key =
              '${oldNamedBeacon.beacon.proximityUUID}-${oldNamedBeacon.beacon.major}-${oldNamedBeacon.beacon.minor}';
          if (newBeaconsMap.containsKey(key)) {
            // If present, replace the old beacon data with the fresh one (e.g., new RSSI).
            updatedBeacons.add(NamedBeacon(
              beacon: newBeaconsMap[key]!, // The latest Beacon object
              name: getNameForBeacon(newBeaconsMap[key]!), // Derive (or re-derive) its name
            ));
            // Mark this key as processed so we don’t add it again in Pass 2.
            foundKeys.add(key);
          } else {
            // If the beacon didn't show up this cycle, keep the old entry (stale, but preserves UI).
            updatedBeacons.add(oldNamedBeacon);
          }
        }

        // --- Pass 2: Add any brand-new beacons we haven't seen before. ---
        for (final newBeacon in result.beacons) {
          // Compute key for each beacon in the latest scan.
          final key = '${newBeacon.proximityUUID}-${newBeacon.major}-${newBeacon.minor}';
          // If it wasn't already added in Pass 1 (i.e., it wasn’t in old list), append it.
          if (!foundKeys.contains(key)) {
            updatedBeacons.add(NamedBeacon(
              beacon: newBeacon,
              name: getNameForBeacon(newBeacon),
            ));
          }
        }

        // Replace the old list in place to trigger UI to reflect the merged results.
        _beacons.clear();
        _beacons.addAll(updatedBeacons);
      });
    });
    // NOTE: listen(...) returns a StreamSubscription. You might want to keep it
    // in a field and cancel it in dispose() to avoid leaks if the widget goes away.
  }

  // Request the necessary runtime permissions for BLE scanning.
  Future<bool> _requestPermissions() async {
    // Ask for Android 12+ BLUETOOTH_SCAN permission (or iOS equivalent handling via plugin).
    final bluetoothScanStatus = await Permission.bluetoothScan.request();
    // Ask for BLUETOOTH_CONNECT permission (needed to interact with the adapter).
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request();
    // Ask for location (some platforms gate BLE scan results behind location access).
    final locationStatus = await Permission.locationWhenInUse.request();

    // Return true only if ALL three permissions were granted.
    return bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted;
  }

  // dispose() is called once when the State is permanently removed from the tree.
  @override
  void dispose() {
    // Stop/cleanup the scanner. This line assumes `close` is a *getter* that performs cleanup.
    // If `close` is actually a method, call: _beaconScanner.close();
    _beaconScanner.close; // Correct way to call the getter to stop the scanner
    // Always call super.dispose() last to let Flutter finish tearing down.
    super.dispose();
  }

  // build() runs on every setState and returns the widget tree for the current state.
  @override
  Widget build(BuildContext context) {
    // Determine the "closest" beacon based on RSSI strength.
    // RSSI is typically a negative number; closer to zero (greater value) means stronger signal.
    final closestBeacon = _beacons.isNotEmpty
        // Reduce over the list to pick the item with the highest RSSI value.
        ? _beacons.reduce((a, b) => a.beacon.rssi > b.beacon.rssi ? a : b)
        // If list is empty, there is no closest beacon.
        : null;

    // Return a full-screen page structure with an app bar and a body.
    return Scaffold(
      // The title bar at the top of the page.
      appBar: AppBar(title: const Text('Beacon Test')),
      // The body adapts based on whether any beacons are currently tracked.
      body: _beacons.isEmpty
          // If no beacons yet, show a centered message.
          ? const Center(child: Text('No beacons detected'))
          // Otherwise, render a vertical, lazily-built list of tiles—one per beacon.
          : ListView.builder(
              // How many items to render.
              itemCount: _beacons.length,
              // Builder callback that constructs each row on demand.
              itemBuilder: (context, index) {
                // Grab the NamedBeacon for this row.
                final namedBeacon = _beacons[index];
                // Is this item the same reference as the computed closestBeacon?
                final isClosest = namedBeacon == closestBeacon;
                
                // Render a Material ListTile summarizing the beacon.
                return ListTile(
                  // Highlight the tile if it's the closest, using a light yellow background.
                  tileColor: isClosest ? Colors.yellow.withOpacity(0.3) : null,
                  // Show the friendly name as the main line.
                  title: Text('Name: ${namedBeacon.name}'),
                  // Show major/minor/RSSI in the subtitle line for debugging/inspection.
                  subtitle: Text(
                      'Major: ${namedBeacon.beacon.major}, Minor: ${namedBeacon.beacon.minor}, RSSI: ${namedBeacon.beacon.rssi}'),
                );
              },
            ),
    );
  }
}
