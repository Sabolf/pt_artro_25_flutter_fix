import 'package:flutter/material.dart';

//CUSTOM DRAWER WIDGET --- 
class AppDrawer extends StatelessWidget {
  //SELECTED INDEX
  final int selectedIndex;

  //ON SELECTED TAB FUNCTION
  final Function(int) onSelectTab; //callBack

  //CONSTRUCTOR
  const AppDrawer({super.key, 
    required this.selectedIndex,
    required this.onSelectTab, //callBack
  });

//Building the drawer UI
  @override
  Widget build(BuildContext context) {
    //------------------------------WHERE THE ACTUAL DRAWER UI COMPONENT COMES FROM
    return Drawer(
      //LIST VIEW MAKES IT ACTUALLY SCROLLABLE
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader( //Display pictures and words
            decoration: BoxDecoration(color: const Color.fromARGB(255, 61, 21, 30)), // decoration gives more style ability
            child: Text('PT ARTRO 2025',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile( // simple row with an icon and text
            leading: Icon(Icons.home), //icon to the left
            title: Text('Home'), //label
            selected: selectedIndex == 0,
            onTap: () => onSelectTab(0), //when clicked calls this function with this argument
          ),
          ListTile(
            leading: Icon(Icons.location_city),
            title: Text('Location'),
            selected: selectedIndex == 1, // HIGHLIGHTS ROW THAT IS SELECTED
            onTap: () => onSelectTab(1),
          ),
          ListTile(
            leading: Icon(Icons.tab), // 2 is the QR
            title: Text('Program'),
            selected: selectedIndex == 3, // HIGHLIGHTS ROW THAT IS SELECTED
            onTap: () => onSelectTab(3),
          ),
          ListTile(
            leading: Icon(Icons.person), // 2 is the QR
            title: Text('Speakers'),
            selected: selectedIndex == 4, // HIGHLIGHTS ROW THAT IS SELECTED
            onTap: () => onSelectTab(4),
          ),
          
        ],
      ),
    );
  }
}
