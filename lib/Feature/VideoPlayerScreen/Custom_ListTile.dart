import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    this.leadingIcon,
    this.trealingIcon,
    this.toggle,
    required this.onTap,
    required this.text,
    super.key,
  });

  final bool? toggle;
  String text;
  IconData? leadingIcon;
  IconData? trealingIcon;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        leadingIcon,
        // Icons.directions_walk,
        color: Colors.white,
        size: 20,
      ),
      title: Text(
        text,
        // "Steo by step",
        style: const TextStyle(
          color: Colors.white,
          fontFamily: "MuseoSans-100",
        ),
      ),
      trailing: Icon(
        trealingIcon,
        // toggle ? Icons.toggle_off : Icons.toggle_on,
        color: Colors.white,
      ),
    );
  }
}
