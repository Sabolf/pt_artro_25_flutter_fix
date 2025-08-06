import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/expandable_text.dart';
import '../widgets/zoomable_image_screen.dart'; // import the zoom screen

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  void openMapLocation() async {
    final Uri mapUri = Uri.parse(
      'https://www.google.com/maps/place/ICE+Krakow+Congress+Centre/@50.0471274,19.9296233,16.92z/data=!3m1!5s0x47165b6f9f2cb59d:0x2827947df8eeb366!4m6!3m5!1s0x47165b6f745b8217:0xc6efab206a2ecca!8m2!3d50.0477778!4d19.9313889!16s%2Fg%2F1ygbcft5d',
    );

    if (await canLaunchUrl(mapUri)) {
      await launchUrl(mapUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch the map URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFE82166);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: primaryColor),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "ICE Krakow Congress Center",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        "International Conferences and Entertainment",
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Divider(height: 28, thickness: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.place, color: primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Marii Konopnickiej 17,\n30-302 Krakow",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "The ICE Krakow Congress Center is located in the very center of Krakow, opposite the Wawel Royal Castle...",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Around the Congress Center there is a special communication system including parking lots and underground garages.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "We recommend using public transport. The nearest stop is just 50 meters from ICE Krakow.",
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // MAP BUTTON
            ElevatedButton.icon(
              onPressed: openMapLocation,
              icon: const Icon(Icons.map, color: primaryColor),
              label: const Text(
                "Open in Google Maps",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 240, 240),
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: primaryColor),
                ),
                elevation: 6,
              ),
            ),

            const SizedBox(height: 24),

            // Normal Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/loc.jpg'),
            ),

            const SizedBox(height: 24),

            // Styled accommodation info text
            Text(
              "ACCOMMODATION BELOW, CLICK IMAGE TO SEE MORE DETAILS",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Tappable image to open zoom screen with shadow
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ZoomableImageScreen(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset('assets/images/accom.png'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // City Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: primaryColor),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Krakow. Royal City",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomExpandableText(
                      leadPart:
                          "Krakow has been the main destination for incoming tourism for years, the most recognizable Polish city in the world. Many millions of tourists from Poland and abroad come here every year. They are attracted by countless monuments and museums, as well as festivals, hundreds of excellent restaurants, pubs and cafes, and hotels located in the most prestigious Polish scenery of the Old Town and the Wawel area. Krakow is a complete city – both modern and rich in history and heritage.",
                      extendedPart:
                          "\n\nFor hundreds of years, the heart of the city has been the Main Market Square – the largest city square in medieval Europe, preserved unchanged since 1257 and included on the first UNESCO World Heritage List in 1978. From the tower of St. Mary’s Basilica, for 600 years, a song has been played every hour to the four corners of the world. In the middle there is the Cloth Hall – a medieval market hall – one of the most recognizable Polish monuments. Krakow has the second oldest university in Central Europe, after the University of Prague, the Jagiellonian University. Wawel inhabited since the Paleolithic times, was the residence of Polish rulers and a religious center from the mid-11th century. Currently, the Wawel Royal Castle serves as a museum. You can see monuments of Renaissance art here; the arcaded courtyard – a pearl of 16th-century architecture – arouses admiration.",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
