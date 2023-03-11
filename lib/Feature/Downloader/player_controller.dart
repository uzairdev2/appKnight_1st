import 'package:flutter/material.dart';

import 'feed_item.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({Key? key}) : super(key: key);
  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  //properties

  //to check which index is currently played
  int currentIndex = 0;

  //static content
  final List<String> urls = const [
    'https://firebasestorage.googleapis.com/v0/b/downloader-17559.appspot.com/o/videos%2Fvideo1.mp4?alt=media&token=41be164e-9faa-48cb-80e2-a3cf37bc28dc',
    'https://firebasestorage.googleapis.com/v0/b/downloader-17559.appspot.com/o/videos%2Fvideo2.mp4?alt=media&token=2a20b69c-34de-4f11-95a7-8abc6bc66613',
    'https://firebasestorage.googleapis.com/v0/b/downloader-17559.appspot.com/o/videos%2Fvideo3.mp4?alt=media&token=49dd60dc-729a-4a60-b906-f8b93af7c143',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: urls.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (ctx, index) {
          return FeedItem(url: urls[index]);
        },
      ),
    );
  }
}
