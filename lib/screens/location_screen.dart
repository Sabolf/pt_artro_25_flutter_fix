import 'package:flutter/material.dart'; // Imports the core Flutter Material library for building UI widgets.
import 'package:url_launcher/url_launcher.dart'; // Imports a package for launching URLs, like a map application.
import '../widgets/expandable_text.dart'; // Imports a custom widget that displays text that can be expanded.
import '../widgets/zoomable_image_screen.dart'; // Imports a screen widget that allows an image to be zoomed.
import '../l10n/app_localizations.dart' as loc; // Imports the localization delegate for language support.

class LocationScreen extends StatelessWidget { // Defines a StatelessWidget, a widget with no mutable state.
  const LocationScreen({super.key}); // Constructor for the widget.

  void openMapLocation() async { // An asynchronous method to open a location in a map app.
    final Uri mapUri = Uri.parse( // Creates a Uri object from a string URL.
      'https://www.google.com/maps/place/ICE+Krakow+Congress+Centre/@50.0471274,19.9296233,16.92z/data=!3m1!5s0x47165b6f9f2cb59d:0x2827947df8eeb366!4m6!3m5!1s0x47165b6f745b8217:0xc6efab206a2ecca!8m2!3d50.0477778!4d19.9313889!16s%2Fg%2F1ygbcft5d', // The URL to launch a map. This is a malformed URL and will likely fail.
    );

    if (await canLaunchUrl(mapUri)) { // Asynchronously checks if the URL can be launched on the device.
      await launchUrl(mapUri, mode: LaunchMode.externalApplication); // Launches the URL in an external application (e.g., Google Maps).
    } else { // If the URL cannot be launched.
      throw 'Could not launch the map URL'; // Throws an error.
    }
  }

  /// Normalize text to remove extra spaces, newlines, and non-breaking spaces
  String normalizeText(String text) { // A helper method to clean up a string of text.
    return text.trim().replaceAll(RegExp(r'[\s\u00A0]+'), ' '); // Trims leading/trailing whitespace and replaces multiple spaces/newlines with a single space.
  }

  @override // Overrides the build method.
  Widget build(BuildContext context) { // The method that builds the UI for this widget.
    const backgroundColor = Color(0xFFF0F2F5); // Defines a constant color for the background.
    const cardColor = Colors.white; // Defines a constant color for cards.
    const accentColor = Color(0xFFA8415B); // Defines a constant accent color.
    const secondAccentColor = Color(0xFFE4287C); // Defines a second constant accent color.
    const primaryTextColor = Color(0xFF1F1F1F); // Defines a primary text color.
    const secondaryTextColor = Color(0xFF6B6B7C); // Defines a secondary text color.

    final locData = loc.AppLocalizations.of(context)!; // Retrieves the localized text data.

    return Scaffold( // Provides a basic visual structure for the screen.
      backgroundColor: backgroundColor, // Sets the background color of the scaffold.
      body: SingleChildScrollView( // Makes the content scrollable.
        padding: const EdgeInsets.all(16.0), // Adds 16 pixels of padding around the content.
        child: Column( // Arranges its children in a vertical column.
          children: [ // The list of widgets within the column.
            // Info Card
            Card( // A card widget with a rounded, elevated appearance.
              color: cardColor, // Sets the card's background color.
              shape: RoundedRectangleBorder( // Defines the shape of the card.
                borderRadius: BorderRadius.circular(16), // Sets the corner radius to 16.
                side: const BorderSide(color: accentColor), // Adds a border with the accent color.
              ),
              elevation: 6, // Adds a shadow with an elevation of 6.
              child: Padding( // Adds padding inside the card.
                padding: const EdgeInsets.all(20.0), // Sets padding to 20 on all sides.
                child: Column( // Arranges the card's content vertically.
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start (left).
                  children: [ // The list of widgets inside the column.
                    Row( // Arranges its children horizontally.
                      children:  [ // The list of widgets inside the row.
                        Icon(Icons.location_on, color: accentColor), // Displays a location icon with the accent color.
                        SizedBox(width: 8), // Adds horizontal space of 8.
                        Expanded( // Makes the child fill the available space.
                          child: Text( // Displays the location title text.
                            locData.location_title, // The localized string for the title.
                            style: TextStyle( // Styles the text.
                              fontSize: 20, // Sets the font size.
                              fontWeight: FontWeight.w600, // Sets the font weight to semi-bold.
                              color: primaryTextColor, // Sets the text color.
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4), // Adds vertical space.
                     Padding( // Adds padding to the text below.
                      padding: EdgeInsets.only(left: 32), // Adds left padding to align with the text above.
                      child: Text( // Displays a subtitle for the location.
                        locData.location_ice, // The localized string for the location name.
                        style: TextStyle( // Styles the text.
                          fontSize: 14, // Sets the font size.
                          fontStyle: FontStyle.italic, // Sets the font style to italic.
                          color: secondaryTextColor, // Sets the text color.
                        ),
                      ),
                    ),
                    const Divider( // Draws a horizontal line.
                      height: 28, // Sets the height of the divider.
                      thickness: 1, // Sets the thickness of the line.
                      color: secondaryTextColor, // Sets the color of the divider.
                    ),
                    Row( // Arranges its children horizontally.
                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the top of the row.
                      children: const [ // The list of widgets in the row.
                        Icon(Icons.place, color: accentColor), // Displays a map pin icon with the accent color.
                        SizedBox(width: 8), // Adds horizontal space.
                        Expanded( // Makes the child fill the available space.
                          child: Text( // Displays the physical address.
                            "Marii Konopnickiej 17,\n30-302 Krakow", // The hardcoded address.
                            style: TextStyle( // Styles the text.
                              fontSize: 15, // Sets the font size.
                              color: primaryTextColor, // Sets the text color.
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Adds vertical space.
                    Text( // Displays a paragraph of text.
                      normalizeText(locData.location_info_lead), // Normalizes the localized text.
                      style: TextStyle(fontSize: 14, color: secondaryTextColor), // Styles the text.
                      textAlign: TextAlign.left, // Aligns the text to the left.
                    ),
                    const SizedBox(height: 12), // Adds vertical space.
                    Text( // Displays a second paragraph of text.
                      normalizeText(locData.location_info_detail), // Normalizes the localized text.
                      style: TextStyle(fontSize: 14, color: secondaryTextColor), // Styles the text.
                      textAlign: TextAlign.left, // Aligns the text to the left.
                    ),
                    const SizedBox(height: 12), // Adds vertical space.
                    Row( // Arranges children horizontally.
                      children: [ // The list of widgets in the row.
                        Icon(Icons.directions_bus, color: accentColor), // Displays a bus icon.
                        SizedBox(width: 8), // Adds horizontal space.
                        Expanded( // Makes the child fill the available space.
                          child: Text( // Displays text about transportation.
                            normalizeText(locData.location_rec), // Normalizes the localized text.
                            style: TextStyle( // Styles the text.
                              fontSize: 14, // Sets the font size.
                              fontStyle: FontStyle.italic, // Sets the font style to italic.
                              color: secondaryTextColor, // Sets the text color.
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20), // Adds vertical space.

            // MAP BUTTON
            ElevatedButton.icon( // A button with an icon and a label.
              onPressed: openMapLocation, // The function to call when the button is pressed.
              icon: const Icon(Icons.map, color: secondAccentColor), // The icon for the button.
              label: Text( // The label (text) for the button.
                normalizeText(locData.open_in_google), // Normalizes the localized text for the button.
                style: TextStyle( // Styles the text.
                  fontWeight: FontWeight.bold, // Sets the font weight to bold.
                  color: secondAccentColor, // Sets the text color.
                ),
              ),
              style: ElevatedButton.styleFrom( // Defines the button's style.
                backgroundColor: cardColor, // Sets the background color.
                padding: const EdgeInsets.symmetric( // Sets symmetric padding.
                  vertical: 16.0, // Vertical padding.
                  horizontal: 24, // Horizontal padding.
                ),
                shape: RoundedRectangleBorder( // Defines the button's shape.
                  borderRadius: BorderRadius.circular(12), // Sets the corner radius.
                  side: const BorderSide(color: accentColor), // Adds a border with the accent color.
                ),
                elevation: 6, // Adds a shadow.
              ),
            ),

            const SizedBox(height: 24), // Adds vertical space.

            // Normal Image
            ClipRRect( // Clips its child to a rounded rectangle.
              borderRadius: BorderRadius.circular(16), // Sets the corner radius.
              child: Image.asset('assets/images/loc.jpg'), // Displays an image from the assets.
            ),

            const SizedBox(height: 24), // Adds vertical space.

            // Styled accommodation info text
            Text( // Displays a styled text widget.
              normalizeText(locData.accom), // Normalizes and displays the localized accommodation text.
              style: TextStyle( // Styles the text.
                color: accentColor, // Sets the text color.
                fontWeight: FontWeight.bold, // Sets the font weight to bold.
                letterSpacing: 1.2, // Increases the spacing between letters.
                fontSize: 14, // Sets the font size.
              ),
              textAlign: TextAlign.center, // Centers the text horizontally.
            ),

            const SizedBox(height: 16), // Adds vertical space.

            // Tappable image to open zoom screen with shadow
            GestureDetector( // A widget that detects gestures.
              onTap: () { // The function to call when the widget is tapped.
                Navigator.push( // Navigates to a new screen.
                  context, // The current context.
                  MaterialPageRoute( // A route that uses a full-screen transition.
                    builder: (_) => const ZoomableImageScreen(), // Builds the new screen, which is a zoomable image view.
                  ),
                );
              },
              child: Container( // A container to hold the image and its decoration.
                decoration: BoxDecoration( // Defines the container's decoration.
                  boxShadow: [ // Adds a list of shadows.
                    BoxShadow( // Defines a single shadow.
                      color: Colors.black.withOpacity(0.1), // Sets the shadow color and opacity.
                      blurRadius: 8, // Sets the blur radius.
                      offset: const Offset(0, 4), // Sets the shadow offset.
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16), // Sets the corner radius.
                ),
                child: ClipRRect( // Clips the image to the rounded corners.
                  borderRadius: BorderRadius.circular(16), // Sets the corner radius.
                  child: Image.asset('assets/images/accom.png'), // Displays the accommodation image.
                ),
              ),
            ),

            const SizedBox(height: 24), // Adds vertical space.

            // City Card
            Card( // A card widget for city information.
              color: cardColor, // Sets the background color.
              shape: RoundedRectangleBorder( // Defines the shape.
                borderRadius: BorderRadius.circular(12), // Sets the corner radius.
                side: const BorderSide(color: accentColor), // Adds a border.
              ),
              elevation: 3, // Sets the elevation.
              child: Padding( // Adds padding inside the card.
                padding: const EdgeInsets.all(16.0), // Sets padding.
                child: Column( // Arranges content vertically.
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns content to the start (left).
                  children: [ // The list of widgets.
                    Text( // Displays a heading for the city.
                      normalizeText("Krakow. Royal City"), // Normalizes and displays the hardcoded city name.
                      style: const TextStyle( // Styles the text.
                        fontSize: 18, // Sets the font size.
                        fontWeight: FontWeight.w600, // Sets the font weight.
                        color: secondAccentColor, // Sets the text color.
                      ),
                    ),
                    const SizedBox(height: 12), // Adds vertical space.
                    CustomExpandableText( // Displays the expandable text widget.
                      leadPart: normalizeText(locData.location_lead), // The initial, visible part of the text.
                      extendedPart: normalizeText(locData.location_body), // The part of the text that can be expanded.
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24), // Adds vertical space.
          ],
        ),
      ),
    );
  }
}