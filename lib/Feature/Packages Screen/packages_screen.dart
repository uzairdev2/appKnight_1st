import 'package:black_belt/Core/Common%20SizedBoxes/custom_sizedbox.dart';
import 'package:black_belt/Feature/VideoPlayerScreen/video_screen_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/card_btn_provieder.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fixheight1,
              Consumer<DownloadProvider>(
                builder: (context, downloadProvider, child) {
                  if (downloadProvider.downloading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (downloadProvider.downloaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return VideoScreen();
                            //     },
                            //   ),
                            // );
                          },
                          child: const Text('Open'),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            downloadProvider.reset();
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          downloadProvider.startDownload();
                        },
                        child: const Text('Download'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
