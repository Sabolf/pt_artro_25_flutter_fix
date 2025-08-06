import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImageScreen extends StatelessWidget {
  const ZoomableImageScreen({super.key});

  Widget hotelCard({
    required String name,
    required String address,
    required String distance,
    required List<Map<String, String>> prices,
    Color primaryColor = const Color(0xFFE82166),
  }) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel name
            Text(
              name,
              style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            // Address and distance
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.directions_walk, color: Colors.white54, size: 16),
                const SizedBox(width: 6),
                Text(
                  "Distance from ICE Krakow: $distance",
                  style: const TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Prices list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: prices.map((price) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    "${price['label']} – ${price['value']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE82166);
    const Color backgroundColor = Color(0xFF121212); // Dark background

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Accommodation Map'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zoomable image with container and shadow
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: PhotoView(
                  imageProvider: const AssetImage('assets/images/accom.png'),
                  backgroundDecoration: BoxDecoration(color: Colors.grey[900]),
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.covered * 3.0,
                ),
              ),
            ),
          ),

          // Caption text
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                "Double tap or Pinch to zoom",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Accommodation info scrollable list
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    hotelCard(
                      name: "Park Inn by Radisson",
                      address: "ul. Monte Cassino 2, 30-337 Kraków",
                      distance: "50m",
                      prices: [
                        {"label": "Single room", "value": "890.00 PLN/night"},
                        {"label": "Double room", "value": "940.00 PLN/night"},
                        {"label": "Place in a double room", "value": "470.00 PLN/night"},
                      ],
                    ),
                    hotelCard(
                      name: "Q Hotel Plus Kraków",
                      address: "ul. Wygrana 6, 30-311 Kraków",
                      distance: "30m",
                      prices: [
                        {"label": "STANDARD Single room", "value": "780.00 PLN/night"},
                        {"label": "STANDARD Double room", "value": "880.00 PLN/night"},
                        {"label": "STANDARD Place in a double room", "value": "440.00 PLN/night"},
                        {"label": "EXECUTIVE Single room", "value": "930.00 PLN/night"},
                      ],
                    ),
                    hotelCard(
                      name: "Hilton Garden Inn Kraków",
                      address: "ul. Marii Konopnickiej 33, 30-302 Kraków",
                      distance: "500m",
                      prices: [
                        {"label": "Single room", "value": "684.00 PLN/night"},
                        {"label": "Double room", "value": "743.00 PLN/night"},
                        {"label": "Place in a double room", "value": "371.50 PLN/night"},
                      ],
                    ),
                    hotelCard(
                      name: "B&B Hotel Kraków Centrum",
                      address: "ul. Monte Cassino 1, 30-337 Kraków",
                      distance: "200m",
                      prices: [
                        {"label": "Single room", "value": "473.00 PLN/night"},
                        {"label": "Double room", "value": "522.00 PLN/night"},
                        {"label": "Place in a double room", "value": "261.00 PLN/night"},
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
