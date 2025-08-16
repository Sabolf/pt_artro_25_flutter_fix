import 'package:flutter/material.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';

// 1. Create a custom data class to hold the Beacon and its name.
class NamedBeacon {
  final Beacon beacon;
  final String name;

  NamedBeacon({required this.beacon, required this.name});
}

class BeaconTest extends StatefulWidget {
  const BeaconTest({super.key});

  @override
  State<BeaconTest> createState() => _BeaconTestState();
}

class _BeaconTestState extends State<BeaconTest> {
  // 2. Change the list to hold the new NamedBeacon objects.
  final List<NamedBeacon> _beacons = [];
  late final DchsFlutterBeacon _beaconScanner;

  @override
  void initState() {
    super.initState();
    _beaconScanner = DchsFlutterBeacon();
    _initBeacon();
  }

  Future<void> _initBeacon() async {
    // 1. Request permissions
    final granted = await _requestPermissions();
    if (!granted) {
      debugPrint('Permissions not granted.');
      return;
    }

    // 2. Initialize scanning using the instance
    try {
      await _beaconScanner.initializeScanning;
    } catch (e) {
      debugPrint('Error initializing beacon scanning: $e');
      return;
    }

    // 3. Start ranging beacons using the instance with the correct UUID
    final regions = [
      Region(
        identifier: 'HolyIoTBeacon',
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825',
        // By not specifying major and minor, all beacons with this UUID will be detected.
      )
    ];

    // 3. Update the ranging listener logic
    _beaconScanner.ranging(regions).listen((RangingResult result) {
      setState(() {
        final List<NamedBeacon> updatedBeacons = [];
        final Map<String, Beacon> newBeaconsMap = {
          for (var b in result.beacons)
            '${b.proximityUUID}-${b.major}-${b.minor}': b
        };
        final Set<String> foundKeys = {};

        // Helper function to map major/minor to a name
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

        // First, iterate through the old list and update or keep existing beacons
        for (final oldNamedBeacon in _beacons) {
          final key =
              '${oldNamedBeacon.beacon.proximityUUID}-${oldNamedBeacon.beacon.major}-${oldNamedBeacon.beacon.minor}';
          if (newBeaconsMap.containsKey(key)) {
            // A new scan result was found for this beacon. Use the new object.
            updatedBeacons.add(NamedBeacon(
              beacon: newBeaconsMap[key]!,
              name: getNameForBeacon(newBeaconsMap[key]!),
            ));
            foundKeys.add(key); // Mark as found
          } else {
            // Beacon was not found in the latest scan, but we keep its last known value.
            updatedBeacons.add(oldNamedBeacon);
          }
        }

        // Then, add any brand new beacons that weren't in our previous list
        for (final newBeacon in result.beacons) {
          final key = '${newBeacon.proximityUUID}-${newBeacon.major}-${newBeacon.minor}';
          if (!foundKeys.contains(key)) {
            updatedBeacons.add(NamedBeacon(
              beacon: newBeacon,
              name: getNameForBeacon(newBeacon),
            ));
          }
        }

        // Replace the old list with the updated list
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

  @override
  void dispose() {
    _beaconScanner.close; // Correct way to call the getter to stop the scanner
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Find the closest beacon based on the highest RSSI (closest to 0)
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