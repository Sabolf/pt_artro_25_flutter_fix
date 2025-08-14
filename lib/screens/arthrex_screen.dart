import 'package:flutter/material.dart';

class ArthrexScreen extends StatelessWidget {
  const ArthrexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold provides a basic visual structure for a material design app.
    // It includes an AppBar, body, and other elements.
    return Scaffold(
      // AppBar for the screen, showing a title.
      appBar: AppBar(
        title: const Text('Arthrex'),
        backgroundColor: Theme.of(context).colorScheme.primary, // Use theme primary color
        foregroundColor: Colors.white, // Text color on AppBar
      ),
      // The body of the screen, centered.
      body: Center(
        // Column to arrange children vertically.
        child: Column(
          // Center content vertically within the Column.
          mainAxisAlignment: MainAxisAlignment.center,
          // Center content horizontally within the Column.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display "HELLO" with explicit styling.
            // This styling should override any debug or default colors.
            Text(
              "HELLO",
              style: TextStyle(
                color: Colors.blue, // Explicitly set text color to blue
                fontSize: 60, // Increase font size for better visibility
                fontWeight: FontWeight.bold, // Make it bold
                // Ensure no default debug underline.
                // If an overflow still occurs, Flutter's debug paint might still appear.
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 20), // Add some vertical spacing
            const Text(
              "Welcome to the Arthrex section!",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Example button to close the screen and go back to the previous one
            // (e.g., QrScreen, which is still on the stack beneath this one).
            // You might want to navigate to a different main screen instead.
        
          ],
        ),
      ),
    );
  }
}
