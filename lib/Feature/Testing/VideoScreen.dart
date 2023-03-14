import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_player/video_player.dart';

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
      print(file);
      print(file);
      await ref.writeToFile(file);
      _videos.add(VideoItem(name: ref.name, url: file.path));
    }
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
