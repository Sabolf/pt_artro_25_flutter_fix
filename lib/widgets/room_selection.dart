import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // 👈 add this
import '../l10n/app_localizations.dart' as loc;

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
    widget.pageController?.addListener(_onPageChanged);

    // Using a post-frame callback to ensure initial state is set
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
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    widget.onRoomSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final locData = loc.AppLocalizations.of(context)!;

    // Define consistent colors and styles
    const Color primaryColor = Color.fromARGB(255, 107, 19, 58);
    const Color selectedBackgroundColor = Color.fromARGB(255, 255, 201, 201);
    const Color unselectedBackgroundColor = Colors.white;

    // Create a list of buttons
    List<Widget> buttons = List.generate(widget.numberOfButtons + 1, (index) {
      final isSelected = _selectedIndex == index;
      final bool isAllButton = index == widget.numberOfButtons;

      // Determine the button text
      final String buttonText =
          isAllButton ? locData.all : '${locData.room} ${index + 1}';

      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: InkWell(
            onTap: () => _onTabTapped(index),
            borderRadius: BorderRadius.circular(45),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(45),
                color: isSelected
                    ? selectedBackgroundColor
                    : unselectedBackgroundColor,
              ),
              child: Center(
                child: AutoSizeText(
                  buttonText,
                  textAlign: TextAlign.center,
                  maxLines: 1, // 👈 keeps text on a single line
                  minFontSize: 8, // 👈 shrink down to at least 8px
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? primaryColor : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });

    return Row(
      children: buttons,
    );
  }
}
