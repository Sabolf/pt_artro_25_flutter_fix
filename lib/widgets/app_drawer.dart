import 'package:flutter/material.dart';

// CUSTOM DRAWER WIDGET
class AppDrawer extends StatelessWidget {
  // SELECTED INDEX
  final int selectedIndex;

  // ON SELECTED TAB FUNCTION
  final Function(int) onSelectTab; // callBack

  // CONSTRUCTOR
  const AppDrawer({
    super.key,
    required this.selectedIndex,
    required this.onSelectTab,
  });

  // Building the drawer UI
  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFA8415B);
    const inactiveColor = Colors.black54;

    return Drawer(
      // LIST VIEW MAKES IT SCROLLABLE
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: activeColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'PT ARTRO 2025',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Annual Conference',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: selectedIndex == 0 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Home',
              style: TextStyle(
                color: selectedIndex == 0 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 0,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(0),
          ),
          ListTile(
            leading: Icon(
              Icons.location_city,
              color: selectedIndex == 1 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Location',
              style: TextStyle(
                color: selectedIndex == 1 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 1,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(1),
          ),
          ListTile(
            leading: Icon(
              Icons.tab,
              color: selectedIndex == 3 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Program',
              style: TextStyle(
                color: selectedIndex == 3 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 3,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(3),
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: selectedIndex == 4 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Speakers',
              style: TextStyle(
                color: selectedIndex == 4 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 4 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 4,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(4),
          ),
          ListTile(
            leading: Icon(
              Icons.wallet,
              color: selectedIndex == 5 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Sponsors',
              style: TextStyle(
                color: selectedIndex == 5 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 5 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 5,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(5),
          ),
          ListTile(
            leading: Icon(
              Icons.navigation_rounded,
              color: selectedIndex == 6 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Plan',
              style: TextStyle(
                color: selectedIndex == 6 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 6 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 6,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(6),
          ),
          ListTile(
            leading: Icon(
              Icons.celebration,
              color: selectedIndex == 7 ? activeColor : inactiveColor,
            ),
            title: Text(
              'Sponsor',
              style: TextStyle(
                color: selectedIndex == 7 ? activeColor : inactiveColor,
                fontWeight: selectedIndex == 7 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            selected: selectedIndex == 7,
            selectedTileColor: activeColor.withOpacity(0.1),
            onTap: () => onSelectTab(7),
          ),
      
        ],
      ),
    );
  }
}