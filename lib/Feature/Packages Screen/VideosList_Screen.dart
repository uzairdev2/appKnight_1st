import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/vidoeplayprovider.dart';
import '../VideoPlayerScreen/video_screen_new.dart';

class VideosListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Consumer<VideoPlayerProvider>(
        builder: (context, videoProvider, child) => ListView.builder(
          itemCount: videoProvider.videos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(videoProvider.videos[index].name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => VideoScreen(
                      videoUrl: videoProvider.videos[index].url,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
