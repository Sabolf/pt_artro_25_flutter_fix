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
    final ByteData imageDataOne = await rootBundle.load(
      'assets/images/New_Plan/Foyer_0-Model.jpg',
    );
    final ByteData imageDataTwo = await rootBundle.load(
      'assets/images/New_Plan/Foyer_1-Model.jpg',
    );
    final ByteData imageDataThree = await rootBundle.load(
      'assets/images/New_Plan/Foyer_3-Model.jpg',
    );
    
    // Define a fallback image for the popups
    final ByteData imageDataPlaceholder = await rootBundle.load(
      'assets/images/placeholder_image.png', // Make sure this asset exists
    );
    final String base64PlaceholderImage = base64Encode(
      Uint8List.view(imageDataPlaceholder.buffer),
    );

    // Load Image 1
    String base64PopupImageOne;
    try {
      final ByteData imageDataPopup = await rootBundle.load(
        'assets/images/popup_image.png',
      );
      base64PopupImageOne = base64Encode(
        Uint8List.view(imageDataPopup.buffer),
      );
    } catch (e) {
      print('Failed to load popup_image.png. Using placeholder.');
      base64PopupImageOne = base64PlaceholderImage;
    }

    // Load Image 2
    String base64PopupImageTwo;
    try {
      final ByteData imageDataPopupTwo = await rootBundle.load(
        'assets/images/another_popup_image.png', // Add a new image path here
      );
      base64PopupImageTwo = base64Encode(
        Uint8List.view(imageDataPopupTwo.buffer),
      );
    } catch (e) {
      print('Failed to load another_popup_image.png. Using placeholder.');
      base64PopupImageTwo = base64PlaceholderImage;
    }

    final String base64Ground = base64Encode(
      Uint8List.view(imageDataOne.buffer),
    );
    final String base64First = base64Encode(
      Uint8List.view(imageDataTwo.buffer),
    );
    final String base64Second = base64Encode(
      Uint8List.view(imageDataThree.buffer),
    );

    final String htmlContent =
        '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes" />
  <style>
    body { margin: 0; padding: 0; }
    #plan-container { 
        position: relative; 
    }
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
      <img src="data:image/png;base64,$base64PopupImageOne" />
    </div>

    <div id="another-popup" class="popup-info" style="top: 350px; left: 200px;">
      <img src="data:image/png;base64,$base64PopupImageTwo" />
    </div>

  </div>
  <script>
    const smithNephewPopup = document.getElementById('smith-nephew-popup');
    const anotherPopup = document.getElementById('another-popup');
    const zoomThreshold = 1.5; 
    
    function handleZoom() {
      const currentScale = window.visualViewport.scale || 1;
      if (currentScale > zoomThreshold) {
        smithNephewPopup.style.display = 'block';
        anotherPopup.style.display = 'block';
      } else {
        smithNephewPopup.style.display = 'none';
        anotherPopup.style.display = 'none';
      }
    }

    window.visualViewport.addEventListener('resize', handleZoom);
    window.addEventListener('load', handleZoom);
    
  </script>
</body>
</html>
''';

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) => NavigationDecision.prevent,
        ),
      )
      ..addJavaScriptChannel(
        'flutter_channel',
        onMessageReceived: (message) {
          print('Message from JS: ${message.message}');
        },
      )
      ..loadHtmlString(htmlContent, baseUrl: 'about:blank');

    setState(() {
      _isLoading = false;
    });
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