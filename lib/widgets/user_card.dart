import 'package:flutter/material.dart';
import 'image_finder.dart'; // Make sure this points to your utility file

class UserCard extends StatefulWidget {
  final dynamic wholeObject;
  final void Function(dynamic)? onTap;
  bool fromProgram;

   UserCard({super.key, this.wholeObject, this.onTap, this.fromProgram = false});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String imagePathWayString = "";

  @override
  void initState() {
    super.initState();
    _findImage();
  }

  Future<void> _findImage() async {
    // Call the reusable function instead of duplicating logic here
    final foundPath =  await findImagePathById(widget.wholeObject['id']);
    if (foundPath != null) {
      setState(() {
        imagePathWayString = foundPath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!(widget.wholeObject);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: imagePathWayString.isEmpty
                ? null
                : AssetImage(imagePathWayString),
            radius: 30,
            child: imagePathWayString.isEmpty
                ? const CircularProgressIndicator()
                : null,
          ),
          title: Text(widget.wholeObject['name'] ?? "N/A"),
          subtitle: Text(widget.wholeObject['prefixPl'] ?? "N/A"),
          shape: Border.all(),
        ),
      ),
    );
  }
}
