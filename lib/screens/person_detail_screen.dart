import 'package:flutter/material.dart';
import 'package:pt_25_artro_test/widgets/image_finder.dart';

class PersonDetailScreen extends StatefulWidget {
  final dynamic speaker;
  const PersonDetailScreen({super.key, required this.speaker});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  String avatarUrl = "";

  @override
  void initState() {
    super.initState();
    _findImage();
  }

  Future<void> _findImage() async {
    final ImgPathWay = await findImagePathById(widget.speaker['id']);
    if (ImgPathWay != null) {
      setState(() {
        avatarUrl = ImgPathWay;
        print("Found image path: $avatarUrl");
      });
    }
  }

  // Color palette for light mode
  static const backgroundColor = Color(0xFFF0F2F5);
  static const cardColor = Colors.white;
  static const accentColor = Color(0xFFE4287C);
  static const primaryTextColor = Color(0xFF1F1F1F);
  static const secondaryTextColor = Color(0xFF6B6B7C);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 1,
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
              // Avatar with glowing border and loading indicator
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
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipOval(
                      child: avatarUrl.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Image.asset(
                              avatarUrl,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              frameBuilder: (BuildContext context, Widget child,
                                  int? frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                if (frame == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return child;
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.person,
                                        size: 60, color: Colors.grey));
                              },
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Name and title
              Text(
                "${widget.speaker['name'] ?? ''} ".trim(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: primaryTextColor,
                ),
              ),
              if (widget.speaker['titleEn'] != null &&
                  widget.speaker['titleEn'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    widget.speaker['titleEn'],
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
                    infoRow(Icons.work_outline, "Workplace", widget.speaker['workplace']),
                    infoRow(
                      Icons.location_on_outlined,
                      "Location",
                      "${widget.speaker['city'] ?? ''}${(widget.speaker['city'] != null && widget.speaker['countryEn'] != null) ? ', ' : ''}${widget.speaker['countryEn'] ?? ''}",
                    ),
                    infoRow(Icons.group_outlined, "Memberships", widget.speaker['member']),
                    infoRow(Icons.map_outlined, "Zones", widget.speaker['zones']),
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
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      (widget.speaker['bioEn'] ?? '').replaceAll('[n]', '\n'),
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
