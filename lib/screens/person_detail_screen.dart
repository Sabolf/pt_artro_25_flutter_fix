import 'package:flutter/material.dart';

class PersonDetailScreen extends StatelessWidget {
  final dynamic speaker;

  const PersonDetailScreen({super.key, required this.speaker});

  @override
  Widget build(BuildContext context) {
    // Define a new, brighter color palette for light mode
    const backgroundColor = Color(0xFFF0F2F5); // A very light gray
    const cardColor = Colors.white; 
    const accentColor = Color(0xFFE4287C); // The original vibrant pink
    const primaryTextColor = Color(0xFF1F1F1F); // A dark gray for main text
    const secondaryTextColor = Color(0xFF6B6B7C); // A medium gray for secondary text

    // Widget to display an info row with an icon, label, and value
    Widget infoRow(IconData icon, String label, String? value) {
      if (value == null || value.trim().isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      color: primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final String? avatarUrl = speaker['avatarUrl'];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor, // AppBar is now white
        elevation: 1, // Add a slight elevation for a subtle shadow
        title: const Text(
          "Speaker Details",
          style: TextStyle(color: primaryTextColor),
        ),
        iconTheme: const IconThemeData(color: primaryTextColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar with a glowing border (still looks good in light mode)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3), // A softer glow
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: backgroundColor,
                    backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null || avatarUrl.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: secondaryTextColor,
                          )
                        : null,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Name and title section
              Text(
                "${speaker['name'] ?? ''} ${speaker['lname'] ?? ''}".trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              if (speaker['titleEn'] != null && speaker['titleEn'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    speaker['titleEn'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: accentColor, 
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),

              const SizedBox(height: 32),

              // Info container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRow(Icons.work_outline, "Workplace", speaker['workplace']),
                    infoRow(Icons.location_on_outlined, "Location",
                        "${speaker['city'] ?? ''}${(speaker['city'] != null && speaker['countryEn'] != null) ? ', ' : ''}${speaker['countryEn'] ?? ''}"),
                    infoRow(Icons.group_outlined, "Memberships", speaker['member']),
                    infoRow(Icons.map_outlined, "Zones", speaker['zones']),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Biography container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Biography",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      (speaker['bioEn'] ?? '').replaceAll('[n]', '\n'),
                      style: const TextStyle(
                        color: secondaryTextColor,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}