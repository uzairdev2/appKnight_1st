import 'dart:async';
import 'dart:developer';

import 'package:black_belt/Feature/VideoPlayerScreen/video_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../Models/step_model.dart';

class VideoPlayerProvider extends ChangeNotifier {
  bool showText = true;
  late VideoPlayerController controller;
  bool stop = false;
  bool shouldPauseAfterStepSwitch = false;
  Timer? timer;

  List<double> breaks = [
    1.2,
    4.5,
    6.7,
  ];
  String toShow = "";

  List<StepModel> steps = [];

  List<String> listMilli = [];

  double seconds = 0;
  StepModel? currentStep;

  startTimer() {
    seconds = 0;
    stop = false;
    timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (controller.value.position >= controller.value.duration) {
        log("Stopped timer");
        timer.cancel();
        resetTimer();
      }

      if (!stop) {
        seconds += .1;

        double toMatch = double.parse(seconds.toStringAsFixed(1));
        List<StepModel> docs =
            steps.where((element) => element.first == toMatch).toList();

        if (docs.isNotEmpty) {
          log("${docs[0].first} // ${docs[0].english.toString()}");
          if (currentStep != docs[0] && shouldPauseAfterStepSwitch) {
            log(" print is no");
            controller.pause().then((value) {
              this.timer = null;
              stop = true;

              stopTimer();
            });
          }
          currentStep = docs[0];

          setShow();
        }
        notifyListeners();
      }
    });
  }

  setShow() {
    toShow = currentStep!.english.toString();
  }

  stopTimer() {
    stop = true;
    notifyListeners();
  }

  playTimer() {
    shouldPauseAfterStepSwitch = false;
    stop = false;
    notifyListeners();
  }

  resetTimer() {
    timer?.cancel();
    timer = null;
  }

  visable() {
    showText = !showText;
    notifyListeners();
  }

  String _currentVideoAssetPath = 'assets/videos/video2.mp4';

  String get currentVideoAssetPath => _currentVideoAssetPath;

  void changeVideo(String newVideoAssetPath) {
    _currentVideoAssetPath = newVideoAssetPath;
    log("here is new video $newVideoAssetPath");
    log("here is new video 222 $_currentVideoAssetPath");
    // currentVideoAssetPath == "assets/videos/video1.mp4"
    //     ? Get.to(() => VideoScreen(
    //           videopath: _currentVideoAssetPath,
    //         ))
    //     : currentVideoAssetPath == "assets/videos/video2.mp4"
    //         ? Get.off(VideoScreen(
    //             videopath: _currentVideoAssetPath,
    //           ))
    //         : Get.offAll(VideoScreen(
    //             videopath: _currentVideoAssetPath,
    //           ));
    // notifyListeners();
    if (currentVideoAssetPath == "assets/videos/video1.mp4") {
      // Get.to(() => VideoScreen(videopath: currentVideoAssetPath));
    } else if (currentVideoAssetPath == "assets/videos/video2.mp4") {
      // Get.offAll(() => VideoScreen(videopath: currentVideoAssetPath));
    } else if (currentVideoAssetPath == "assets/videos/video3.mp4") {
      // Get.offAll(() => VideoScreen(videopath: currentVideoAssetPath));
    } else if (currentVideoAssetPath == "assets/videos/video4.mp4") {
      // Get.offAll(() => VideoScreen(videopath: currentVideoAssetPath));
    } else {
      // Handle the case where the value of currentVideoAssetPath is not one of the four videos
      // Get.to(() => VideoScreen(
      //     // videopath: "assets/videos/video0.mp4",
      //     ));
    }
  }
}
