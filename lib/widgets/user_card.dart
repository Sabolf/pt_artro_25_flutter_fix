import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String imagePathWay;
  final dynamic wholeObject;
  final void Function(dynamic)? onTap;

  const UserCard({
    super.key,
    required this.imagePathWay,
    this.wholeObject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(wholeObject);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePathWay),
            radius: 30,
          ),
          title: Text(wholeObject['name']??"N/A"),
          subtitle: Text(wholeObject['prefixPl']?? ""),
          shape: Border.all(),
        ),
      ),
    );
  }
}
