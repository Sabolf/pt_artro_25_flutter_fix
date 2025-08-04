import 'package:flutter/material.dart';

class RoomSelection extends StatefulWidget {
  final int numberOfButtons;
  
  const RoomSelection({super.key, required this.numberOfButtons});

  @override
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  //keeps track current room selected
  int _selectedIndex = 0;

  //When a button is tapped
  void _onTabTapped(int index) {
    //set state redraws screen
    setState(() {
      //argument is now the selected index
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //List of widgets called buttons
    //Generate inside (numberOfButtons is the Amount),
    List<Widget> buttons = List.generate(widget.numberOfButtons, (index) {
      //selected variable that will compare each index to the current chose tab
      final isSelected = _selectedIndex == index;

      return Expanded(
        //ink well is a tappable widget
        child: InkWell(
          //when tapped, call this function with current widgets index
          onTap: () => _onTabTapped(index),
          //inside of the widget
          child: Container(
            //style decorator
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(45),
              //depends on which is selected
              color: isSelected
                  ? const Color.fromARGB(255, 255, 201, 201)
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: Center(child: Text('Room ${index + 1}', textAlign: TextAlign.center,)),
            ),
          ),
        ),
      );
    });

    // Add one more "All" button at the end with its own selected state
    final isAllSelected = _selectedIndex == widget.numberOfButtons;
    buttons.add(
      Expanded(
        child: InkWell(
          //number of buttons would equal the last which would be all
          onTap: () => _onTabTapped(widget.numberOfButtons),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(45),
              color: isAllSelected
                  ? const Color.fromARGB(255, 255, 201, 201)
                  : Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("All", textAlign: TextAlign.center,)),
            ),
          ),
        ),
      ),
    );

    return Row(children: buttons);
  }
}
