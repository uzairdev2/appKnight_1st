import 'package:black_belt/Core/Common%20SizedBoxes/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/card_btn_provieder.dart';
import 'VideosList_Screen.dart';

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
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => VideosListScreen());
                        },
                        child: const Text('Open'),
                      ),
                    );
                  } else {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          downloadProvider.downloadVideos();
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
