import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class UserCard extends StatefulWidget {
  final dynamic wholeObject;
  final void Function(dynamic)? onTap;

  const UserCard({
    super.key,
    this.wholeObject,
    this.onTap,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String imagePathWayString = "";

  Future<void> _findImage() async {
    final String imagePathWayList = await rootBundle.loadString(
      'assets/image_paths.json',
    );
    final Map<String, dynamic> data = await jsonDecode(imagePathWayList);

    // Access the list of paths using the key "images"
    final List<dynamic> imagePaths = data['images'];
    
    // Find the path and store it in a local variable
    String? foundPath;
    for (String path in imagePaths) {
      if (path.contains(widget.wholeObject['id'])) {
        print("$path ==== ${widget.wholeObject['id']}");
        foundPath = path;
        break; // Exit the loop once a match is found
      }
    }
    
    // Update the state with the found path
    if (foundPath != null) {
      setState(() {
        imagePathWayString = foundPath!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _findImage();
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
            // Use a placeholder if the image path is still empty
            backgroundImage: imagePathWayString.isEmpty
                ? null // A null backgroundImage will show the CircleAvatar's default background
                : AssetImage(imagePathWayString),
            radius: 30,
            child: imagePathWayString.isEmpty
                ? const CircularProgressIndicator() // Show a loader while waiting
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