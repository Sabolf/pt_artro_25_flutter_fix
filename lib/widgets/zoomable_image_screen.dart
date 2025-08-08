import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ZoomableImageScreen extends StatelessWidget {
  const ZoomableImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the new, consistent color palette
    const backgroundColor = Color(0xFF1A1A2E); // A dark, rich blue-purple
    const cardColor = Color(0xFF2E2E4E);      // A slightly lighter shade for cards
    const accentColor = Color(0xFFE4287C);    // The original vibrant pink
    const primaryTextColor = Colors.white;
    const secondaryTextColor = Color(0xFFB0B0C4); // A light grey for secondary text
    const mutedIconColor = Color(0xFFB0B0C4); // Lighter icons for contrast
    
    // Widget to display a hotel card
    Widget hotelCard({
      required String name,
      required String address,
      required String distance,
      required List<Map<String, String>> prices,
    }) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel name
            Text(
              name,
              style: const TextStyle(
                color: accentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            
            // Address and distance
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, color: mutedIconColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(color: secondaryTextColor),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.directions_walk, color: mutedIconColor, size: 16),
                const SizedBox(width: 4),
                Text(
                  "$distance away",
                  style: const TextStyle(color: secondaryTextColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Prices list
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Prices per night:",
                  style: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ...prices.map((price) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.arrow_right, color: accentColor, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${price['label']}: ${price['value']}",
                            style: const TextStyle(color: secondaryTextColor),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Accommodation',
          style: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: cardColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryTextColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zoomable image container
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: PhotoView(
                  imageProvider: const AssetImage('assets/images/accom.png'),
                  backgroundDecoration: BoxDecoration(color: cardColor),
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.covered * 3.0,
                ),
              ),
            ),
          ),
          
          // Caption text
          const Center(
            child: Text(
              "Double tap or pinch to zoom",
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Accommodation list header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Hotels Near ICE Krakow",
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Accommodation info scrollable list
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView(
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
        ],
      ),
    );
  }
}