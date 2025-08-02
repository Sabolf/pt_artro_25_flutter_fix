import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String imagePathWay;
  final String subTitle;
  final void Function(String)? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.imagePathWay,
    required this.subTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(name);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePathWay),
            radius: 30,
          ),
          title: Text(name),
          subtitle: Text(subTitle),
          shape: Border.all(),
        ),
      ),
    );
  }
}
