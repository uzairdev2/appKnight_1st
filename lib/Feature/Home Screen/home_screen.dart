import 'package:black_belt/Feature/About%20Screen/about_screen.dart';
import 'package:black_belt/Feature/Packages%20Screen/packages_screen.dart';
import 'package:black_belt/Feature/Patterns%20Screen/pattern_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/drawer_provider.dart';
import 'my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      // Using App Bar in home to show the title
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Packages",
          style: TextStyle(
            fontFamily: 'MuseoSans-700',
          ),
        ),
        elevation: 0,
        toolbarHeight: 40,
        backgroundColor: Colors.grey[700],
      ),

      // Using Drawer for the changing mod
      drawer: MyDrawer(),
      body: Consumer<CurrentScreen>(
        builder: (context, currentScreen, child) {
          switch (currentScreen.currentIndex) {
            case 0:
              return const PackagesScreen();
            case 1:
              return const PatternsScreen();
            case 2:
              return const AboutScreen();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
