import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/card_btn_provieder.dart';

class VideosListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, videoProvider, child) => ListView.builder(
          itemCount: videoProvider.videos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(videoProvider.videos[index].name),
              onTap: () =>
                  videoProvider.playVideo(context, videoProvider.videos[index]),
            );
          },
        ),
      ),
    );
  }
}
