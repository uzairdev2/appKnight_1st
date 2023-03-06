import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/drawer_provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[800],
      child: ListView(
        children: [
          ListTile(
            title: const Text(
              'Patterns',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "MuseoSans-500",
              ),
            ),
            selectedTileColor: Colors.grey,
            onTap: () {
              context.read<CurrentScreen>().updateCurrentIndex(1);
              Navigator.pop(context);
            },
            selected: context.watch<CurrentScreen>().currentIndex == 1,
          ),
          ListTile(
            title: const Text(
              'Packages',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "MuseoSans-500",
              ),
            ),
            selectedTileColor: Colors.grey,
            onTap: () {
              context.read<CurrentScreen>().updateCurrentIndex(0);
              Navigator.pop(context);
            },
            selected: context.watch<CurrentScreen>().currentIndex == 0,
          ),
          ListTile(
            title: const Text(
              'About',
              style: TextStyle(
                color: Colors.white,
                fontFamily: "MuseoSans-500",
              ),
            ),
            selectedTileColor: Colors.grey,
            onTap: () {
              context.read<CurrentScreen>().updateCurrentIndex(2);
              Navigator.pop(context);
            },
            selected: context.watch<CurrentScreen>().currentIndex == 2,
          ),
        ],
      ),
    );
  }
}
