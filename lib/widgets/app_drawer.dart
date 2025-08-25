import 'package:flutter/material.dart';
// Generated localization (use alias)
import '../l10n/app_localizations.dart' as loc;

//Widget For The Custom App Drawer
class AppDrawer extends StatelessWidget {
  //Represents the current index screen
  final int selectedIndex;
  //call back function that was given by parent widget
  final Function(int) onSelectTab;


  const AppDrawer({
    super.key,
    //Constructor Taking in the REQUIRED VALUES
    required this.selectedIndex,
    required this.onSelectTab,
  });

  @override
  //Build is how the widget should be DISPLAYED
  Widget build(BuildContext context) {
    //Color of tab currently used
    const activeColor = Color(0xFFA8415B);
    //Color of tab that is not being used currently
    const inactiveColor = Colors.black54;
    //Language settings 
    final locData = loc.AppLocalizations.of(context)!;

    //List icon and corresponding titles for drawer 
    final drawerItems = [
      {'icon': Icons.home, 'title': locData.meeting_pt},
      {'icon': Icons.tab, 'title': locData.program},
      {'icon': Icons.navigation_rounded, 'title': locData.building_plan},
      {'icon': Icons.person, 'title': locData.speakers},
      {'icon': Icons.wallet, 'title': locData.sponsor_title},
      {'icon': Icons.location_city, 'title': locData.location},
      {'icon': Icons.celebration, 'title': locData.menu_sn}, 
      {'icon': Icons.message, 'title': locData.messages}, 
      {'icon': Icons.celebration, 'title': "----beacon"},
    ];

    //DRAWER COMPONENT
    return Drawer(

      child: ListView( // Scrollable List of widgets
        padding: EdgeInsets.zero,
        children: [ //Widgets that will be scrollable
          DrawerHeader(//---------------HEADER OF THE DRAWER COMPONENT
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
          
          //For the length of the List with icons+names
          for (var i = 0; i < drawerItems.length; i++)
            ListTile(// Tile Component
              leading: Icon( // ------ Leading left side is an Icon
                drawerItems[i]['icon'] as IconData, //Pulls ICON from list with current index
                //Checks to see if current Selected Screen is also I
                color: selectedIndex == i ? activeColor : inactiveColor,
              ),
              title: Text( // Title of the List Tile
              //Pulls TITLE from list with current index
                drawerItems[i]['title'] as String,
                style: TextStyle(
                  color: selectedIndex == i ? activeColor : inactiveColor,
                  fontWeight: selectedIndex == i
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
              //Selected tab  will be determined by
              // if the selectedIndex attribute is equal to the current iteration
              selected: selectedIndex == i,
              selectedTileColor: activeColor.withOpacity(0.1),
              //On Tap run the callback function and return 
              //What ever the current i is in the specific tab
              //Example 0 1 2 3 4 5 .. ... ..
              onTap: () => onSelectTab(i),
            ),
        ],
      ),
    );
  }
}
