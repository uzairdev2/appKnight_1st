import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoItem {
  final String name;
  final String url;
  VideoItem({required this.name, required this.url});
}

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  List<VideoItem> _videos = [];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  void _loadVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? videoPaths = prefs.getStringList('video_paths');
    if (videoPaths != null) {
      setState(() {
        _videos = videoPaths
            .map((path) =>
                VideoItem(name: File(path).path.split('/').last, url: path))
            .toList();
      });
    }
  }

  void _saveVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> videoPaths = _videos.map((v) => v.url).toList();
    prefs.setStringList('video_paths', videoPaths);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_videos[index].name),
            onTap: () => _playVideo(_videos[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_download),
        onPressed: () async {
          await _downloadVideos();
          setState(() {});
        },
      ),
    );
  }

  Future<void> _downloadVideos() async {
    final Directory directory = await getApplicationDocumentsDirectory();

    final FirebaseStorage storage = FirebaseStorage.instance;
    final ListResult result = await storage.ref().child('videos/').listAll();

    for (final ref in result.items) {
      final file = File('${directory.path}/${ref.name}');
      print(file);
      await ref.writeToFile(file);
      final videoItem = VideoItem(name: ref.name, url: file.path);
      if (!_videos.contains(videoItem)) {
        _videos.add(videoItem);
      }
    }
    _saveVideos();
  }

  Future<void> _playVideo(VideoItem videoItem) async {
    final VideoPlayerController controller =
        VideoPlayerController.file(File(videoItem.url))
          ..addListener(() => setState(() {}));
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
  }
}
