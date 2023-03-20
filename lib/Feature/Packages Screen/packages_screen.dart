import 'package:black_belt/Core/Common%20SizedBoxes/custom_sizedbox.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../Core/Provider/vidoeplayprovider.dart';
import 'VideosList_Screen.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key}) : super(key: key);

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late final VideoPlayerProvider downloadProvider;

  @override
  void initState() {
    super.initState();
    downloadProvider = Provider.of<VideoPlayerProvider>(context, listen: false);
    downloadProvider.loadVideos();
  }

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
              Consumer<VideoPlayerProvider>(
                builder: (context, downloadProvider, child) {
                  if (downloadProvider.downloading) {
                    return Column(
                      children: const [
                        LinearProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Downloading Videos...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  } else if (downloadProvider.downloaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => VideosListScreen());
                          },
                          child: const Text('Open'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await downloadProvider.deleteVideos();
                            Fluttertoast.showToast(
                              msg: 'Videos deleted successfully!',
                              backgroundColor: Colors.grey[800],
                              textColor: Colors.white,
                            );
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
                        onPressed: () async {
                          await downloadProvider.downloadVideos();
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
