import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

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
  final Map<String, NamedBeacon> _beaconsMap = {};
  late final DchsFlutterBeacon _beaconScanner;
  StreamSubscription<RangingResult>? _rangingSubscription;

  @override
  void initState() {
    super.initState();
    _beaconScanner = DchsFlutterBeacon();
    _startScan();
  }

  Future<void> _startScan() async {
    // Request permissions
    bool granted = false;
    if (Platform.isIOS) {
      granted = await Permission.locationWhenInUse.status.isGranted;
      //final bt = await Permission.bluetooth.request();
      if (!granted) {
        final loc = await Permission.locationWhenInUse.request();
        granted =  loc.isGranted;
      }
    } else if (Platform.isAndroid) {
      final btScan = await Permission.bluetoothScan.request();
      final btConnect = await Permission.bluetoothConnect.request();
      final loc = await Permission.locationWhenInUse.request();
      granted = btScan.isGranted && btConnect.isGranted && loc.isGranted;
    }

    if (!granted) return;

    // Initialize scanner
    await _beaconScanner.initializeScanning;

    // Define regions
    final regions = [
      Region(
        identifier: 'HolyIoTBeacon',
        proximityUUID: '12345678-1234-1234-1234-123456789012',
      ),
    ];

    // Start scanning
    _rangingSubscription = _beaconScanner.ranging(regions).listen((result) {
      setState(() {
        for (var b in result.beacons) {
          final key = '${b.proximityUUID}-${b.major}-${b.minor}';
          String getName(Beacon b) {
            if (b.major == 10011 && b.minor == 1) return 'black';
            if (b.major == 10011 && b.minor == 2) return 'white';
            if (b.major == 10011 && b.minor == 3) return 'green';
            if (b.major == 10011 && b.minor == 4) return 'blue';
            return 'Unknown';
          }

          _beaconsMap[key] = NamedBeacon(beacon: b, name: getName(b));
        }
      });
    });
  }

  @override
  void dispose() {
    _rangingSubscription?.cancel();
    _beaconScanner.close;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final beacons = _beaconsMap.values.toList();
    NamedBeacon? closest;
    if (beacons.isNotEmpty) {
      closest = beacons.reduce(
          (a, b) => a.beacon.rssi > b.beacon.rssi ? a : b); // strongest RSSI
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Beacon Test')),
      body: beacons.isEmpty
          ? const Center(child: Text('Scanning for beacons...'))
          : ListView.builder(
              itemCount: beacons.length,
              itemBuilder: (context, index) {
                final beacon = beacons[index];
                final isClosest = beacon == closest;

                return ListTile(
                  tileColor:
                      isClosest ? Colors.yellow.withOpacity(0.3) : null,
                  title: Text(beacon.name),
                  subtitle: Text(
                      'Major: ${beacon.beacon.major}, Minor: ${beacon.beacon.minor}, RSSI: ${beacon.beacon.rssi}'),
                );
              },
            ),
    );
  }
}
