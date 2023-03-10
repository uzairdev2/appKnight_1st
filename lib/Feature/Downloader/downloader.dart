// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'package:black_belt/Feature/VideoPlayerScreen/video_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyVideoDownloader extends StatefulWidget {
  const MyVideoDownloader({super.key});

  @override
  _MyVideoDownloaderState createState() => _MyVideoDownloaderState();
}

class _MyVideoDownloaderState extends State<MyVideoDownloader> {
  late Future<ListResult> futureFiles;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('videos/').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Video Downloader'),
        leading: IconButton(
            onPressed: () {
              Get.to(VideoScreen());
            },
            icon: Icon(Icons.play_circle)),
      ),
      body: FutureBuilder(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final files = snapshot.data!.items;
            return ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return ListTile(
                    title: Text(file.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        downloadFile(file);
                      },
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Downlaod ${ref.name}")));

    print(file);
    print(file);

    // Retrieve the video file from the application documents directory
    final file1 = await DefaultCacheManager().getSingleFile(
      '/data/user/0/com.appsknight.black_belt/app_flutter/video1.mp4',
    );
  }
}
