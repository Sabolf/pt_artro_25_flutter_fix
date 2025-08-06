import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String imagePathWay;
  final String subTitle;
  final String symbol;
  final void Function(String)? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.imagePathWay,
    required this.subTitle,
    required this.symbol,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!(symbol);
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
