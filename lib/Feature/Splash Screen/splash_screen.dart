import 'dart:async';

import 'package:flutter/material.dart';

import '../Home Screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 4),
        () => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            })));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/splash.jpg");
  }
}
