import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsorsScreen extends StatelessWidget {
  const SponsorsScreen({super.key});

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Widget sectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(thickness: 2),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Manually add your sponsors here, grouped by level
    final goldSponsors = [
      {
        "name": "Gold Sponsor 1",
        "logo": "assets/sponsors/gold1.png",
        "url": "https://gold1.com",
      },
      {
        "name": "Gold Sponsor 2",
        "logo": "assets/sponsors/gold2.png",
        "url": "https://gold2.com",
      },
    ];

    final silverSponsors = [
      {
        "name": "Silver Sponsor 1",
        "logo": "assets/sponsors/silver1.png",
        "url": "https://silver1.com",
      },
      {
        "name": "Silver Sponsor 2",
        "logo": "assets/sponsors/silver2.png",
        "url": "https://silver2.com",
      },
      {
        "name": "Silver Sponsor 3",
        "logo": "assets/sponsors/silver3.png",
        "url": "https://silver3.com",
      },
    ];

    final bronzeSponsors = [
      {
        "name": "Bronze Sponsor 1",
        "logo": "assets/sponsors/bronze1.png",
        "url": "https://bronze1.com",
      },
      {
        "name": "Bronze Sponsor 2",
        "logo": "assets/sponsors/bronze2.png",
        "url": "https://bronze2.com",
      },
    ];

    Widget buildSponsorGrid(List<Map<String, String>> sponsors) {
      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: sponsors.map((sponsor) {
          return GestureDetector(
            onTap: () => _launchUrl(sponsor['url']!),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  sponsor['logo']!,
                  fit: BoxFit.contain,
                  semanticLabel: sponsor['name'],
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionHeader("Gold Sponsors"),
              buildSponsorGrid(goldSponsors),

              const SizedBox(height: 24),

              sectionHeader("Silver Sponsors"),
              buildSponsorGrid(silverSponsors),

              const SizedBox(height: 24),

              sectionHeader("Bronze Sponsors"),
              buildSponsorGrid(bronzeSponsors),
            ],
          ),
        ),
      ),
    );
  }
}
