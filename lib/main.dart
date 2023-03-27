import 'package:black_belt/Core/Provider/icon_state.dart';
import 'package:black_belt/Feature/VideoPlayerScreen/video_screen_new.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'Core/Provider/drawer_provider.dart';
import 'Core/Provider/vidoeplayprovider.dart';
import 'Feature/Splash Screen/splash_screen.dart';
import 'Feature/Testing/VideoScreen.dart';

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
          create: (_) => VideoProvider(),
        ),
      ],
      // Screen_util initialization
      child: ScreenUtilInit(
        designSize: const Size(1280, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          final videoPlayerModel =
              Provider.of<VideoPlayerProvider>(context, listen: false);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Black Belt',
            //Calling Screen
            home: SplashScreen(),
            routes: {
              "secondvideo": (context) => VideoScreen(
                    videoUrl: videoPlayerModel.videos[1].url,
                  ),
              "thridvideo": (context) => VideoScreen(
                    videoUrl: videoPlayerModel.videos[3].url,
                  ),
              "forthvideo": (context) => VideoScreen(
                    videoUrl: videoPlayerModel.videos[2].url,
                  ),
              "firstvideo": (context) => VideoScreen(
                    videoUrl: videoPlayerModel.videos[0].url,
                  ),
            },
          );
        },
      ),
    );
  }
}
