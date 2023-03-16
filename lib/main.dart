import 'package:black_belt/Core/Provider/icon_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Core/Provider/card_btn_provieder.dart';
import 'Core/Provider/drawer_provider.dart';
import 'Core/Provider/vidoeplayprovider.dart';
import 'Feature/Testing/VideoScreen.dart';
import 'Feature/Testing/downloader.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(
          create: (_) => DownloadProvider(),
        ),
      ],
      // Screen_util initialization
      child: ScreenUtilInit(
        designSize: const Size(1280, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Black Belt',
            //Calling Screen
            home: VideosScreen(),
          );
        },
      ),
    );
  }
}
