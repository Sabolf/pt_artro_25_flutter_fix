import 'package:flutter/material.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';

class NamedBeacon {
  final Beacon beacon;
  final String name;

  const NamedBeacon({required this.beacon, required this.name});
}

class BeaconTest extends StatefulWidget {
  const BeaconTest({super.key});

  @override
  State<BeaconTest> createState() => _BeaconTestState();
}

class _BeaconTestState extends State<BeaconTest> {
  final List<NamedBeacon> _beacons = [];
  late final DchsFlutterBeacon _beaconScanner;
  StreamSubscription<RangingResult>? _rangingSubscription;
  bool _isInitializing = false;
  String _statusMessage = 'Initializing...';
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _beaconScanner = DchsFlutterBeacon();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add a small delay to ensure everything is loaded
    await Future.delayed(const Duration(milliseconds: 500));
    _startBeaconScan();
  }

  Future<void> _startBeaconScan() async {
    if (_isInitializing) return;
    _isInitializing = true;

    setState(() {
      _statusMessage = 'Checking permissions...';
    });

    // First, check current status without requesting
    await _checkPermissionStatus();

    // If not granted, then request
    if (!_permissionsGranted) {
      final granted = await _requestPermissions();
      if (!granted) {
        debugPrint('Permissions not granted. Beacon scanning aborted.');
        setState(() {
          _statusMessage = 'Permissions required for Bluetooth scanning';
          _isInitializing = false;
        });
        return;
      }
    }

    setState(() {
      _statusMessage = 'Initializing beacon scanner...';
    });

    try {
      await _beaconScanner.initializeScanning;
    } catch (e) {
      debugPrint('Error initializing beacon scanning: $e');
      setState(() {
        _statusMessage = 'Failed to initialize scanner: $e';
        _isInitializing = false;
      });
      return;
    }

    setState(() {
      _statusMessage = 'Scanning for beacons...';
    });

    final regions = [
      Region(
        identifier: 'HolyIoTBeacon',
        proximityUUID: '12345678-1234-1234-1234-123456789012',
      )
    ];

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

        for (final oldNamedBeacon in _beacons) {
          final key = '${oldNamedBeacon.beacon.proximityUUID}-${oldNamedBeacon.beacon.major}-${oldNamedBeacon.beacon.minor}';
          if (newBeaconsMap.containsKey(key)) {
            updatedBeacons.add(NamedBeacon(
              beacon: newBeaconsMap[key]!,
              name: getNameForBeacon(newBeaconsMap[key]!),
            ));
            foundKeys.add(key);
          }
        }

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
        _statusMessage = 'Found ${_beacons.length} beacon(s)';
      });
    }, onError: (error) {
      debugPrint('Beacon scanning error: $error');
      setState(() {
        _statusMessage = 'Scanning error: $error';
      });
    });
  }

  Future<void> _checkPermissionStatus() async {
    if (Platform.isIOS) {
      final bluetoothStatus = await Permission.bluetooth.status;
      final locationStatus = await Permission.locationWhenInUse.status;
      
      debugPrint('Current Bluetooth status: $bluetoothStatus');
      debugPrint('Current Location status: $locationStatus');
      
      _permissionsGranted = bluetoothStatus.isGranted && locationStatus.isGranted;
      
      if (_permissionsGranted) {
        debugPrint('Permissions already granted!');
      } else {
        debugPrint('Permissions not granted yet');
      }
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isIOS) {
      debugPrint('Requesting iOS permissions...');
      
      // Request Bluetooth first
      var bluetoothStatus = await Permission.bluetooth.status;
      debugPrint('Initial Bluetooth status: $bluetoothStatus');
      
      if (bluetoothStatus.isDenied) {
        debugPrint('Requesting Bluetooth permission...');
        bluetoothStatus = await Permission.bluetooth.request();
        debugPrint('After Bluetooth request: $bluetoothStatus');
        
        // Add a small delay between requests
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Then request Location
      var locationStatus = await Permission.locationWhenInUse.status;
      debugPrint('Initial Location status: $locationStatus');
      
      if (locationStatus.isDenied) {
        debugPrint('Requesting Location permission...');
        locationStatus = await Permission.locationWhenInUse.request();
        debugPrint('After Location request: $locationStatus');
      }

      debugPrint('Final - Bluetooth: $bluetoothStatus, Location: $locationStatus');
      
      // Check if we need to show the rationale (why we need these permissions)
      if (bluetoothStatus.isPermanentlyDenied || locationStatus.isPermanentlyDenied) {
        debugPrint('Permissions permanently denied');
        return false;
      }
      
      return bluetoothStatus.isGranted && locationStatus.isGranted;
    }
    return false;
  }

  // Open app settings
  Future<void> _openAppSettings() async {
    await openAppSettings();
    // Check permissions again after returning from settings
    await Future.delayed(const Duration(seconds: 2));
    _retryPermissions();
  }

  Future<void> _retryPermissions() async {
    setState(() {
      _isInitializing = false;
      _statusMessage = 'Checking permissions again...';
    });
    await _startBeaconScan();
  }

  @override
  void dispose() {
    _rangingSubscription?.cancel();
    _beaconScanner.close;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beacon Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openAppSettings,
            tooltip: 'Open Settings',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryPermissions,
            tooltip: 'Retry Permissions',
          ),
        ],
      ),
      body: _beacons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_statusMessage, 
                       textAlign: TextAlign.center,
                       style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 20),
                  if (_statusMessage.contains('required') || 
                      _statusMessage.contains('denied'))
                    ElevatedButton(
                      onPressed: _retryPermissions,
                      child: const Text('Request Permissions Again'),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _openAppSettings,
                    child: const Text('Open App Settings'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_statusMessage),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _beacons.length,
                    itemBuilder: (context, index) {
                      final namedBeacon = _beacons[index];
                      final isClosest = _beacons.isNotEmpty
                          ? namedBeacon == _beacons.reduce((a, b) => 
                              a.beacon.rssi > b.beacon.rssi ? a : b)
                          : false;
                      
                      return ListTile(
                        tileColor: isClosest ? Colors.yellow.withOpacity(0.3) : null,
                        title: Text('Name: ${namedBeacon.name}'),
                        subtitle: Text(
                            'Major: ${namedBeacon.beacon.major}, '
                            'Minor: ${namedBeacon.beacon.minor}, '
                            'RSSI: ${namedBeacon.beacon.rssi}'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}