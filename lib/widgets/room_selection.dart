import 'package:flutter/material.dart';

class RoomSelection extends StatefulWidget {
  final int numberOfButtons;

  // Simple callback function type: nullable, takes int, returns void
  final void Function(int)? onRoomSelected;

  const RoomSelection({
    super.key,
    required this.numberOfButtons,
    this.onRoomSelected,
  });

  @override
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    widget.onRoomSelected?.call(_selectedIndex);
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Call the callback if provided
    widget.onRoomSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = List.generate(widget.numberOfButtons, (index) {
      final isSelected = _selectedIndex == index;

      return Expanded(
        child: InkWell(
          onTap: () => _onTabTapped(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(45),
              color: isSelected
                  ? const Color.fromARGB(255, 255, 201, 201)
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text('Room ${index + 1}', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      );
    });

    final isAllSelected = _selectedIndex == widget.numberOfButtons;
    var tmpAll = buttons.length > 4 ? "All\n" : "All";

    buttons.add(
      Expanded(
        child: InkWell(
          onTap: () => _onTabTapped(widget.numberOfButtons),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(45),
              color: isAllSelected
                  ? const Color.fromARGB(255, 255, 201, 201)
                  : Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text(tmpAll, textAlign: TextAlign.center)),
            ),
          ),
        ),
      ),
    );

    return Row(children: buttons);
  }
}
