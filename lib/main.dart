import 'package:black_belt/Core/Provider/icon_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'Core/Provider/drawer_provider.dart';
import 'Core/Provider/vidoeplayprovider.dart';
import 'Feature/VideoPlayerScreen/video_screen_new.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Hide Status Bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    // Set landscape orientation forcefully
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // initialization of Provider
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CurrentScreen(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoPlayerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IconState(),
        ),
      ],
      // Screen_util initialization
      child: ScreenUtilInit(
        designSize: const Size(1280, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Black Belt',
            //Calling Screen
            home: VideoScreen(),
          );
        },
      ),
    );
  }
}
