import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../Models/step_model.dart';

// This Class are use for the Downloading and Storing video
class VideoItem {
  final String name;
  final String url;
  VideoItem({required this.name, required this.url});
}

class VideoPlayerProvider extends ChangeNotifier {
  // to set the player custom
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
    notifyListeners();
  }

  visable() {
    showText = !showText;
    notifyListeners();
  }

  // Use for the videos Dawnloading from firbase and store it in loccl
  // After Local store it in SharedPrefernces and play them
  List<VideoItem> _videos = [];

  List<VideoItem> get videos => _videos;

  bool _downloading = false;
  bool _downloaded = false;
  double _downloadProgress = 0.0;

  double get downloadProgress => _downloadProgress;
  bool get downloading => _downloading;
  bool get downloaded => _downloaded;

  // When App is Launched
  void loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? videoPaths = prefs.getStringList('video_paths');
    if (videoPaths != null) {
      _videos = videoPaths
          .map((path) =>
              VideoItem(name: File(path).path.split('/').last, url: path))
          .toList();
      _downloaded = true; // set the downloaded flag to true
    }
    notifyListeners();
  }

  void saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoPaths = _videos.map((v) => v.url).toList();
    prefs.setStringList('video_paths', videoPaths);
  }

  // // When Download Button was Clicked
  Future<void> downloadVideos() async {
    _downloading = true;
    _downloadProgress = 0.0; // initialize download progress
    notifyListeners();
    final Directory directory = await getApplicationDocumentsDirectory();

    final FirebaseStorage storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref().child('videos/').listAll();

    for (final ref in result.items) {
      final file = File('${directory.path}/${ref.name}');
      if (!await file.exists()) {
        final task = ref.writeToFile(file);
        // Add a progress listener for the task
        task.snapshotEvents.listen((TaskSnapshot snapshot) {
          _downloadProgress = snapshot.bytesTransferred / (1024 * 1024);
          notifyListeners();
        });
        await task;
        Fluttertoast.showToast(
          msg: '${ref.name} downloaded',
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.blue,
        ); // show toast message
      }
      print(file);
      final videoItem = VideoItem(name: ref.name, url: file.path);
      if (!_videos.contains(videoItem)) {
        _videos.add(videoItem);
      }
    }
    saveVideos();
    _downloading = false;
    _downloaded = true;
    _downloadProgress = 0.0; // reset download progress
    notifyListeners();
  }

  // When Delete Button was Clicked
  Future<void> deleteVideos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Delete videos from storage
    for (final video in _videos) {
      final file = File(video.url);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Clear the videos list and set _downloaded to false
    _videos.clear();
    _downloaded = false;

    // Remove video_paths key from SharedPreferences
    await prefs.remove('video_paths');

    // Notify listeners to show the download button again
    notifyListeners();
  }
}
