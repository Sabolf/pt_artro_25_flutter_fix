import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWebViewContent();
  }

  Future<void> _loadWebViewContent() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    // Load all images as base64 (works on both Android & iOS)
    final String base64Ground = await _loadImageAsBase64('assets/images/New_Plan/Foyer_0-Model.jpg');
    final String base64First = await _loadImageAsBase64('assets/images/New_Plan/Foyer_1-Model.jpg');
    final String base64Second = await _loadImageAsBase64('assets/images/New_Plan/Foyer_3-Model.jpg');

    final String base64PopupOne = await _tryLoadPopup('assets/images/popup_image.png');
    final String base64PopupTwo = await _tryLoadPopup('assets/images/another_popup_image.png');

    final htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes" />
  <style>
    body { margin: 0; padding: 0; }
    #plan-container { position: relative; }
    .floor-image { width: 100%; height: auto; }
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
  </style>
</head>
<body>
  <div id="plan-container">
    <img class="floor-image" src="data:image/jpeg;base64,$base64Ground" />
    <img class="floor-image" src="data:image/jpeg;base64,$base64First" />
    <img class="floor-image" src="data:image/jpeg;base64,$base64Second" />

    <div id="smith-nephew-popup" class="popup-info" style="top: 100px; left: 200px;">
      <img src="data:image/png;base64,$base64PopupOne" />
    </div>

    <div id="another-popup" class="popup-info" style="top: 350px; left: 200px;">
      <img src="data:image/png;base64,$base64PopupTwo" />
    </div>
  </div>

  <script>
    const smithNephewPopup = document.getElementById('smith-nephew-popup');
    const anotherPopup = document.getElementById('another-popup');
    const zoomThreshold = 1.5; 

    function handleZoom() {
      const currentScale = window.visualViewport ? window.visualViewport.scale || 1 : 1;
      if (currentScale > zoomThreshold) {
        smithNephewPopup.style.display = 'block';
        anotherPopup.style.display = 'block';
      } else {
        smithNephewPopup.style.display = 'none';
        anotherPopup.style.display = 'none';
      }
    }

    if (window.visualViewport) {
      window.visualViewport.addEventListener('resize', handleZoom);
    }
    window.addEventListener('load', handleZoom);
  </script>
</body>
</html>
''';

    await _webViewController.loadHtmlString(htmlContent, baseUrl: 'about:blank');

    setState(() => _isLoading = false);
  }

  /// Helper to load any asset image and convert to base64
  Future<String> _loadImageAsBase64(String path) async {
    final ByteData data = await rootBundle.load(path);
    return base64Encode(Uint8List.view(data.buffer));
  }

  /// Tries to load a popup image, falls back to placeholder if missing
  Future<String> _tryLoadPopup(String path) async {
    try {
      return await _loadImageAsBase64(path);
    } catch (_) {
      final placeholder = await _loadImageAsBase64('assets/images/placeholder_image.png');
      return placeholder;
    }
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
