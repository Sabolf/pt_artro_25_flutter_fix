import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart';
import 'package:permission_handler/permission_handler.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  final List<Beacon> _beacons = [];
  late final DchsFlutterBeacon _beaconScanner;

  @override
  void initState() {
    super.initState();
    _beaconScanner = DchsFlutterBeacon();
    _loadWebViewContent();
    _initBeacon();
  }

  Future<void> _loadWebViewContent() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Load all images as base64
    final String base64Ground =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_0-Model.jpg');
    final String base64First =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_1-Model.jpg');
    final String base64Second =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_3-Model.jpg');

    final String base64PopupOne =
        await _tryLoadPopup('assets/images/popup_image.png');
    final String base64PopupTwo =
        await _tryLoadPopup('assets/images/another_popup_image.png');

    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes" />
  <style>
    body { margin: 0; padding: 0; }
    #plan-container { position: relative; }
    .floor-image { width: 100%; height: auto; }

    /* Popups */
    .popup-info {
      position: absolute;
      transform: translate(-50%, -50%);
      display: none;
      z-index: 100;
    }
    .popup-info img {
      width: 50px;
      height: auto;
      border: 1px solid #000;
      border-radius: 8px;
    }

    /* Beacons */
    .beacon {
      position: absolute;
      transform: translate(-50%, -50%);
      z-index: 99;
    }
    .beacon img {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      object-fit: contain;
      opacity: 1; /* default fully visible */
    }
  </style>
</head>
<body>
  <div id="plan-container">
    <img class="floor-image" src="data:image/jpeg;base64,$base64Ground" />
    <img class="floor-image" src="data:image/jpeg;base64,$base64First" />
    <img class="floor-image" src="data:image/jpeg;base64,$base64Second" />

    <!-- Popups -->
    <div id="smith-nephew-popup" class="popup-info" style="top: 50px; left: 50px;">
      <img src="data:image/png;base64,$base64PopupOne" />
    </div>
    <div id="another-popup" class="popup-info" style="top: 50px; left: 100px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
    <div id="another-popupp" class="popup-info" style="top: 50px; left: 150px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>

    <!-- Beacons (same positions as before) -->
    <div id="green" class="beacon" style="top: 150px; left: 50px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
    <div id="black" class="beacon" style="top: 350px; left: 150px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
    <div id="white" class="beacon" style="top: 300px; left: 320px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
  </div>

  <script>
    const smithNephewPopup = document.getElementById('smith-nephew-popup');
    const anotherPopup = document.getElementById('another-popup');
    const anotherPopupp = document.getElementById('another-popupp');
    const zoomThreshold = 1.5; 

    function handleZoom() {
      const currentScale = window.visualViewport ? window.visualViewport.scale || 1 : 1;
      if (currentScale > zoomThreshold) {
        smithNephewPopup.style.display = 'block';
        anotherPopup.style.display = 'block';
        anotherPopupp.style.display = 'block';
      } else {
        smithNephewPopup.style.display = 'none';
        anotherPopup.style.display = 'none';
        anotherPopupp.style.display = 'none';
      }
    }

    if (window.visualViewport) {
      window.visualViewport.addEventListener('resize', handleZoom);
    }
    window.addEventListener('load', handleZoom);

    // Highlight beacon function (called from Flutter)
    function highlightBeacon(closest) {
      const ids = ['green','black','white'];
      ids.forEach(id => {
        const el = document.querySelector('#' + id + ' img');
        if (el) {
          el.style.opacity = (id === closest) ? '1' : '0.2';
        }
      });
    }
  </script>
</body>
</html>
''';

    await _webViewController.loadHtmlString(htmlContent, baseUrl: 'about:blank');
    setState(() => _isLoading = false);
  }

  Future<void> _initBeacon() async {
    final granted = await _requestPermissions();
    if (!granted) return;

    try {
      await _beaconScanner.initializeScanning;
    } catch (e) {
      debugPrint('Beacon init error: $e');
      return;
    }

    final regions = [
      Region(
        identifier: 'HolyIoTBeacon',
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825',
      )
    ];

    _beaconScanner.ranging(regions).listen((result) {
      setState(() {
        _beacons.clear();
        _beacons.addAll(result.beacons);

        if (_beacons.isNotEmpty) {
          final closest = _beacons.reduce((a, b) => a.rssi > b.rssi ? a : b);

          String closestName;
          if (closest.major == 10011 && closest.minor == 1) {
            closestName = 'black';
          } else if (closest.major == 10011 && closest.minor == 2) {
            closestName = 'white';
          } else if (closest.major == 10011 && closest.minor == 3) {
            closestName = 'green';
          } else {
            closestName = '';
          }

          if (closestName.isNotEmpty) {
            _webViewController.runJavaScript("highlightBeacon('$closestName');");
          }
        }
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

  Future<String> _loadImageAsBase64(String path) async {
    final ByteData data = await rootBundle.load(path);
    return base64Encode(Uint8List.view(data.buffer));
  }

  Future<String> _tryLoadPopup(String path) async {
    try {
      return await _loadImageAsBase64(path);
    } catch (_) {
      final placeholder =
          await _loadImageAsBase64('assets/images/placeholder_image.png');
      return placeholder;
    }
  }

  @override
  void dispose() {
    _beaconScanner.close;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Building Plan')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(14.0),
              child: WebViewWidget(controller: _webViewController),
            ),
    );
  }
}
