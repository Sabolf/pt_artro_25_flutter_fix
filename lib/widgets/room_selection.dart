import 'package:flutter/material.dart';

class RoomSelection extends StatefulWidget {
  final int numberOfButtons;
  final void Function(int)? onRoomSelected;
  final PageController? pageController;

  const RoomSelection({
    super.key,
    required this.numberOfButtons,
    this.onRoomSelected,
    this.pageController,
  });

  @override
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Listen to the PageController's page changes
    widget.pageController?.addListener(_onPageChanged);
    
    // Call the initial room selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTabTapped(_selectedIndex);
    });
  }

  @override
  void dispose() {
    widget.pageController?.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    // This is important to ensure the PageController's position is a valid integer.
    // Sometimes it can be a double during the swipe animation.
    if (widget.pageController != null && widget.pageController!.page != null) {
      final newIndex = widget.pageController!.page!.round();
      if (_selectedIndex != newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    // Only setState if the index has actually changed
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    // Call the callback if provided. This will be used by DayDetailScreen
    // to navigate the PageView.
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