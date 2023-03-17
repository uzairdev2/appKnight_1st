import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class VideoItem {
  final String name;
  final String url;
  VideoItem({required this.name, required this.url});
}

class DownloadProvider extends ChangeNotifier {
  List<VideoItem> _videos = [];

  List<VideoItem> get videos => _videos;

  bool _downloading = false;
  bool _downloaded = false;

  bool get downloading => _downloading;
  bool get downloaded => _downloaded;

  // Storing in Shared-Preferences
  void loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? videoPaths = prefs.getStringList('video_paths');
    if (videoPaths != null) {
      _videos = videoPaths
          .map((path) =>
              VideoItem(name: File(path).path.split('/').last, url: path))
          .toList();
    }
    notifyListeners();
  }

  void saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoPaths = _videos.map((v) => v.url).toList();
    prefs.setStringList('video_paths', videoPaths);
  }

  // When Download Button was Clicked
  Future<void> downloadVideos() async {
    _downloading = true;
    final Directory directory = await getApplicationDocumentsDirectory();

    final FirebaseStorage storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref().child('videos/').listAll();

    for (final ref in result.items) {
      final file = File('${directory.path}/${ref.name}');
      if (!await file.exists()) {
        await ref.writeToFile(file);
      }
      print(file);
      final videoItem = VideoItem(name: ref.name, url: file.path);
      if (!_videos.contains(videoItem)) {
        _videos.add(videoItem);
      }
    }
    saveVideos();
    notifyListeners();
    //  Simulate a 5-second download
    Timer(Duration(seconds: 2), () {
      _downloading = false;
      _downloaded = true;
      notifyListeners();
    });
  }

  Future<void> playVideo(BuildContext context, VideoItem videoItem) async {
    final VideoPlayerController controller =
        VideoPlayerController.file(File(videoItem.url))
          ..addListener(() => notifyListeners());
    await controller.initialize().then((_) => controller.play());
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      ),
    ));
    await controller.dispose();
    notifyListeners();
  }
}
