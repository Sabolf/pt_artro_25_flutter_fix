import 'package:flutter/material.dart';
// Generated localization (use alias)
import '../l10n/app_localizations.dart' as loc;

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelectTab;

  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFA8415B);
    const inactiveColor = Colors.black54;

    final locData = loc.AppLocalizations.of(context)!;

    // List of drawer items with icons and localized titles
    final drawerItems = [
      {'icon': Icons.home, 'title': locData.meeting_pt},
      {'icon': Icons.tab, 'title': locData.program},
      {'icon': Icons.navigation_rounded, 'title': locData.building_plan},
      {'icon': Icons.person, 'title': locData.speakers},
      {'icon': Icons.wallet, 'title': locData.sponsor_title},
      {'icon': Icons.location_city, 'title': locData.location},
      {'icon': Icons.celebration, 'title': locData.menu_sn}, // Assuming arthrex
      {'icon': Icons.message, 'title': locData.messages}, // Assuming arthrex
      {'icon': Icons.celebration, 'title': "----beacon"},
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: activeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'PT ARTRO 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Annual Conference',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
          // Build drawer tiles dynamically
          for (var i = 0; i < drawerItems.length; i++)
            ListTile(
              leading: Icon(
                drawerItems[i]['icon'] as IconData,
                color: selectedIndex == i ? activeColor : inactiveColor,
              ),
              title: Text(
                drawerItems[i]['title'] as String,
                style: TextStyle(
                  color: selectedIndex == i ? activeColor : inactiveColor,
                  fontWeight: selectedIndex == i
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              selected: selectedIndex == i,
              selectedTileColor: activeColor.withOpacity(0.1),
              onTap: () => onSelectTab(i),
            ),
        ],
      ),
    );
  }
}
