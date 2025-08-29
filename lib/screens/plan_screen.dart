import 'dart:convert'; // Imports the `dart:convert` library for encoding and decoding data.
import 'dart:typed_data'; // Imports `dart:typed_data` for working with lists of numbers.

import 'package:flutter/material.dart'; // Imports the core Flutter material design library.
import 'package:flutter/services.dart' show rootBundle; // Imports `rootBundle` from `services.dart` to access assets.
import 'package:webview_flutter/webview_flutter.dart'; // Imports the `webview_flutter` package to display web content.
import 'package:dchs_flutter_beacon/dchs_flutter_beacon.dart'; // Imports the custom beacon scanning package.
import 'package:permission_handler/permission_handler.dart'; // Imports the `permission_handler` package for managing permissions.

class PlanScreen extends StatefulWidget {
  // Defines a `PlanScreen` class that is a `StatefulWidget`, meaning its state can change.
  const PlanScreen({super.key}); // The constructor for the widget.

  @override
  _PlanScreenState createState() => _PlanScreenState(); // Overrides `createState` to create the mutable state object.
}

class _PlanScreenState extends State<PlanScreen> {
  // The state class for `PlanScreen`.
  late final WebViewController _webViewController; // Declares a `WebViewController` to control the WebView. `late` means it will be initialized before use.
  bool _isLoading = true; // A boolean to track if the content is still loading.

  final List<Beacon> _beacons = []; // A list to store the scanned beacons.
  late final DchsFlutterBeacon _beaconScanner; // The beacon scanner instance.

  @override
  void initState() {
    // `initState` is called when the widget is inserted into the widget tree.
    super.initState(); // Calls the superclass's `initState` method.
    _beaconScanner = DchsFlutterBeacon(); // Initializes the beacon scanner.
    _loadWebViewContent(); // Starts loading the web content.
    _initBeacon(); // Starts the beacon initialization process.
  }

  Future<void> _loadWebViewContent() async {
    // An async method to load the HTML content into the WebView.
    _webViewController = WebViewController() // Creates a new `WebViewController` instance.
      ..setJavaScriptMode(JavaScriptMode.unrestricted); // Sets JavaScript to be unrestricted, allowing it to run freely.

    // Load all images as base64
    final String base64Ground =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_0-Model.jpg'); // Loads the ground floor image as a Base64 string.
    final String base64First =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_1-Model.jpg'); // Loads the first floor image as Base64.
    final String base64Second =
        await _loadImageAsBase64('assets/images/New_Plan/Foyer_3-Model.jpg'); // Loads the second floor image as Base64.

    final String base64PopupOne =
        await _tryLoadPopup('assets/images/popup_image.png'); // Tries to load the first popup image, using a placeholder if it fails.
    final String base64PopupTwo =
        await _tryLoadPopup('assets/images/another_popup_image.png'); // Tries to load a second popup image.

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

    <div id="smith-nephew-popup" class="popup-info" style="top: 50px; left: 50px;">
      <img src="data:image/png;base64,$base64PopupOne" />
    </div>
    <div id="another-popup" class="popup-info" style="top: 50px; left: 100px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
    <div id="another-popupp" class="popup-info" style="top: 50px; left: 150px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>

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
    const smithNephewPopup = document.getElementById('smith-nephew-popup'); // Gets the HTML element for the first popup.
    const anotherPopup = document.getElementById('another-popup'); // Gets the second popup element.
    const anotherPopupp = document.getElementById('another-popupp'); // Gets the third popup element.
    const zoomThreshold = 1.5; // Defines the zoom level at which popups should appear.

    function handleZoom() {
      // A function to handle the visibility of popups based on zoom level.
      const currentScale = window.visualViewport ? window.visualViewport.scale || 1 : 1; // Gets the current zoom scale.
      if (currentScale > zoomThreshold) {
        // Checks if the zoom level is above the threshold.
        smithNephewPopup.style.display = 'block'; // Shows the first popup.
        anotherPopup.style.display = 'block'; // Shows the second popup.
        anotherPopupp.style.display = 'block'; // Shows the third popup.
      } else {
        smithNephewPopup.style.display = 'none'; // Hides the first popup.
        anotherPopup.style.display = 'none'; // Hides the second popup.
        anotherPopupp.style.display = 'none'; // Hides the third popup.
      }
    }

    if (window.visualViewport) {
      // Checks if `visualViewport` is supported.
      window.visualViewport.addEventListener('resize', handleZoom); // Adds an event listener for zoom changes.
    }
    window.addEventListener('load', handleZoom); // Adds an event listener to run `handleZoom` when the page loads.

    // Highlight beacon function (called from Flutter)
    function highlightBeacon(closest) {
      // A JavaScript function to highlight the closest beacon.
      const ids = ['green','black','white']; // An array of beacon IDs.
      ids.forEach(id => {
        // Iterates through each beacon ID.
        const el = document.querySelector('#' + id + ' img'); // Finds the image element for the current beacon.
        if (el) {
          el.style.opacity = (id === closest) ? '1' : '0.2'; // Sets the opacity to 1 (fully visible) for the closest beacon and 0.2 for others.
        }
      });
    }
  </script>
</body>
</html>
'''; // The end of the HTML string.

    await _webViewController.loadHtmlString(htmlContent, baseUrl: 'about:blank'); // Loads the HTML content into the WebView.
    setState(() => _isLoading = false); // Sets `_isLoading` to false and rebuilds the widget.
  }

  Future<void> _initBeacon() async {
    // An async method to initialize the beacon scanning.
    final granted = await _requestPermissions(); // Requests necessary permissions and waits for the result.
    if (!granted) return; // If permissions were not granted, stop here.

    try {
      await _beaconScanner.initializeScanning; // Initializes the beacon scanning.
    } catch (e) {
      debugPrint('Beacon init error: $e'); // Prints any initialization errors to the console.
      return; // Stops if an error occurred.
    }

    final regions = [
      Region(
        identifier: 'HolyIoTBeacon', // Defines a region to scan for beacons.
        proximityUUID: 'FDA50693A4E24FB1AFCFC6EB07647825', // The UUID of the beacons to look for.
      )
    ];

    _beaconScanner.ranging(regions).listen((result) {
      // Starts ranging for beacons in the defined regions and listens for results.
      setState(() {
        // Calls `setState` to trigger a rebuild when new data is available.
        _beacons.clear(); // Clears the previous list of beacons.
        _beacons.addAll(result.beacons); // Adds the newly found beacons to the list.

        if (_beacons.isNotEmpty) {
          // Checks if any beacons were found.
          final closest = _beacons.reduce((a, b) => a.rssi > b.rssi ? a : b); // Finds the beacon with the highest RSSI (strongest signal, therefore closest).

          String closestName; // Declares a string to store the name of the closest beacon.
          if (closest.major == 10011 && closest.minor == 1) {
            closestName = 'black'; // Maps major/minor ID to a beacon name.
          } else if (closest.major == 10011 && closest.minor == 2) {
            closestName = 'white';
          } else if (closest.major == 10011 && closest.minor == 3) {
            closestName = 'green';
          } else {
            closestName = ''; // No match found.
          }

          if (closestName.isNotEmpty) {
            // Checks if a closest beacon was identified.
            _webViewController.runJavaScript("highlightBeacon('$closestName');"); // Calls the JavaScript function in the WebView to highlight the beacon.
          }
        }
      });
    });
  }

  Future<bool> _requestPermissions() async {
    // An async method to request necessary permissions.
    final bluetoothScanStatus = await Permission.bluetoothScan.request(); // Requests Bluetooth scan permission.
    final bluetoothConnectStatus = await Permission.bluetoothConnect.request(); // Requests Bluetooth connect permission.
    final locationStatus = await Permission.locationWhenInUse.request(); // Requests location permission.

    return bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted &&
        locationStatus.isGranted; // Returns `true` if all permissions are granted, `false` otherwise.
  }

  Future<String> _loadImageAsBase64(String path) async {
    // An async method to load an image from assets and convert it to Base64.
    final ByteData data = await rootBundle.load(path); // Loads the image data from the asset bundle.
    return base64Encode(Uint8List.view(data.buffer)); // Converts the image data to a Base64 string.
  }

  Future<String> _tryLoadPopup(String path) async {
    // An async method to try loading an image, with a fallback placeholder.
    try {
      return await _loadImageAsBase64(path); // Tries to load the image.
    } catch (_) {
      final placeholder =
          await _loadImageAsBase64('assets/images/placeholder_image.png'); // If loading fails, load the placeholder image.
      return placeholder; // Returns the placeholder's Base64 string.
    }
  }

  @override
  void dispose() {
    // `dispose` is called when the widget is removed from the widget tree.
    _beaconScanner.close; // Closes the beacon scanner to release resources.
    super.dispose(); // Calls the superclass's `dispose` method.
  }

  @override
  Widget build(BuildContext context) {
    // The `build` method describes the UI.
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // If loading, shows a loading indicator.
          : Padding(
              padding: const EdgeInsets.all(14.0), // Adds padding around the WebView.
              child: WebViewWidget(controller: _webViewController), // Displays the WebView with the controller.
            ),
    );
  }
}