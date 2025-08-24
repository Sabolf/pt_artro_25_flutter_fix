import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/expandable_text.dart';
import '../widgets/zoomable_image_screen.dart';
import '../l10n/app_localizations.dart' as loc;

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

  /// Normalize text to remove extra spaces, newlines, and non-breaking spaces
  String normalizeText(String text) {
    return text.trim().replaceAll(RegExp(r'[\s\u00A0]+'), ' ');
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF0F2F5);
    const cardColor = Colors.white;
    const accentColor = Color(0xFFA8415B);
    const secondAccentColor = Color(0xFFE4287C);
    const primaryTextColor = Color(0xFF1F1F1F);
    const secondaryTextColor = Color(0xFF6B6B7C);

    final locData = loc.AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Info Card
            Card(
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: accentColor),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children:  [
                        Icon(Icons.location_on, color: accentColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            locData.location_title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                     Padding(
                      padding: EdgeInsets.only(left: 32),
                      child: Text(
                        locData.location_ice,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 28,
                      thickness: 1,
                      color: secondaryTextColor,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.place, color: accentColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Marii Konopnickiej 17,\n30-302 Krakow",
                            style: TextStyle(
                              fontSize: 15,
                              color: primaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      normalizeText(locData.location_info_lead),
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      textAlign: TextAlign.left, // CORRECTED HERE
                    ),
                    const SizedBox(height: 12),
                    Text(
                      normalizeText(locData.location_info_detail),
                      style: TextStyle(fontSize: 14, color: secondaryTextColor),
                      textAlign: TextAlign.left, // CORRECTED HERE
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.directions_bus, color: accentColor),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            normalizeText(locData.location_rec),
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: secondaryTextColor,
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
              icon: const Icon(Icons.map, color: secondAccentColor),
              label: Text(
                normalizeText(locData.open_in_google),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondAccentColor,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cardColor,
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: accentColor),
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
              normalizeText(locData.accom),
              style: TextStyle(
                color: accentColor,
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
                      color: Colors.black.withOpacity(0.1),
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
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: accentColor),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      normalizeText("Krakow. Royal City"),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: secondAccentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomExpandableText(
                      leadPart: normalizeText(locData.location_lead),
                      extendedPart: normalizeText(locData.location_body),
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