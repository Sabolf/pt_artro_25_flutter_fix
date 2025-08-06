import 'package:flutter/material.dart';

class RoomSelection extends StatefulWidget {
  // numberOfButtons: A final variable to specify the number of 'Room' buttons to be generated. 
  // This value is passed in from the parent widget and cannot be changed after the widget is created.
  final int numberOfButtons;
  // onRoomSelected: A final optional callback function that takes an integer as an argument.
  // The parent widget can provide a function here to be notified when a room button is tapped.
  final void Function(int)? onRoomSelected;
  // pageController: A final optional PageController. 
  // It's passed in from the parent to enable this widget to listen to a PageView's page changes.
  final PageController? pageController;

  // The constructor initializes the final properties. 'super.key' is used to pass the key up the widget tree.
  const RoomSelection({
    super.key,
    required this.numberOfButtons,
    this.onRoomSelected,
    this.pageController,
  });

  @override
  // This method creates the mutable state for this StatefulWidget.
  State<RoomSelection> createState() => _RoomSelectionState();
}

class _RoomSelectionState extends State<RoomSelection> {
  // _selectedIndex: A private instance variable to hold the index of the currently selected button.
  // It's initialized to 0, meaning the first button is selected by default.
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Check if a pageController was provided before adding a listener.
    widget.pageController?.addListener(_onPageChanged);

    // WidgetsBinding.instance.addPostFrameCallback is used to schedule a one-time callback
    // after the initial build of the widget. This ensures the UI and state are correctly
    // initialized and synchronized from the start.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onTabTapped(_selectedIndex);
    });
  }

  @override
  void dispose() {
    // Before the widget is permanently removed, this method is called.
    // It's crucial to remove the listener from the PageController to prevent a memory leak,
    // as the listener holds a reference to this State object.
    widget.pageController?.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    // This method is triggered whenever the page in the associated PageView changes.
    // The null checks are important for safety.
    if (widget.pageController != null && widget.pageController!.page != null) {
      // The PageController's 'page' property can be a double during animation.
      // We round it to the nearest integer to get the stable page index.
      final newIndex = widget.pageController!.page!.round();
      // We only update the state and trigger a rebuild if the page index has actually changed,
      // which is an optimization to avoid unnecessary work.
      if (_selectedIndex != newIndex) {
        setState(() {
          _selectedIndex = newIndex;
        });
      }
    }
  }

  void _onTabTapped(int index) {
    // This method is called when a user taps one of the room buttons.
    // The check for '_selectedIndex != index' is another performance optimization.
    if (_selectedIndex != index) {
      // setState is called to inform the Flutter framework that the internal state has changed,
      // which triggers a rebuild of the widget.
      setState(() {
        _selectedIndex = index;
      });
    }

    // The '?' is a null-aware operator. It checks if onRoomSelected is not null,
    // and if so, it calls the function with the selected index.
    widget.onRoomSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    // This method builds the UI for the widget.
    // A list of widgets is created to hold all the room buttons.
    List<Widget> buttons = List.generate(widget.numberOfButtons, (index) {
      // This boolean determines if the current button is the one selected.
      final isSelected = _selectedIndex == index;

      return Expanded(
        // Expanded widgets ensure that all buttons in the Row take up equal space.
        child: InkWell(
          // InkWell makes the Container tappable and provides a visual ripple effect.
          onTap: () => _onTabTapped(index),
          child: Container(
            // Container is used to style the button.
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFFE82166)),
              borderRadius: BorderRadius.circular(45), // Creates a pill shape.
              // The background color is a light red if selected, otherwise it's white.
              color: isSelected
                  ? const Color.fromARGB(255, 255, 201, 201)
                  : Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                // The Text widget displays the room number.
                child: Text('Room ${index + 1}', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      );
    });

    // Check if the 'All' button, which has the index 'numberOfButtons', is selected.
    final isAllSelected = _selectedIndex == widget.numberOfButtons;
    // A simple conditional to add a line break to "All" if there are many buttons,
    // preventing the text from getting too squeezed.
    var tmpAll = buttons.length > 4 ? "All\n" : "All";

    // Add the final 'All' button to the list.
    buttons.add(
      Expanded(
        child: InkWell(
          // Tapping this button calls _onTabTapped with an index one greater than the last room.
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

    // The Row widget lays out all the buttons horizontally.
    return Row(children: buttons);
  }
}