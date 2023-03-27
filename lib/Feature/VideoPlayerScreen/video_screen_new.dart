import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../Core/Common SizedBoxes/custom_sizedbox.dart';
import '../../Core/Constants/constants.dart';
import '../../Core/Provider/icon_state.dart';
import '../../Core/Provider/vidoeplayprovider.dart';
import '../../Core/Read Files/read_csv.dart';
import '../../Core/Models/step_model.dart';
import 'Custom_ListTile.dart';
import 'Custom_RadioBTN.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;

  VideoScreen({
    required this.videoUrl,
    super.key,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  void initState() {
    super.initState();

    final controller = Provider.of<VideoPlayerProvider>(context, listen: false);

    controller.controller = VideoPlayerController.file(File(widget.videoUrl))
      ..initialize().then((_) {
        controller.controller.addListener(() => setState(() {}));
        setState(() {});
      });
    @override
    void dispose() {
      super.dispose();
      controller.controller.pause();
      controller.controller.dispose();
    }

    CsvService().processCsv().then((value) {
      for (int i = 1; i < value.length; i++) {
        List temp = value[i][0].split(";");
        controller.steps.add(
          StepModel(
            id: int.parse(temp[0]),
            english: temp[1],
            korean: temp[2],
            first: double.parse(temp[3]),
          ),
        );
      }
    });
  }

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _value = 1;

  @override
  Widget build(BuildContext context) {
    final videoPlayerModel =
        Provider.of<VideoPlayerProvider>(context, listen: false);

    backWard() {
      if (videoPlayerModel.currentStep != null) {
        if (videoPlayerModel.currentStep!.id == 1) {
          return;
        }
      } else {
        return;
      }
      // find previous step
      StepModel preious = videoPlayerModel.steps.firstWhere(
          (element) => element.id! == videoPlayerModel.currentStep!.id! - 1);
      int milli = int.parse(
          videoPlayerModel.currentStep!.first.toString().split(".")[1]);
      log(milli.toString());
      videoPlayerModel.controller.seekTo(
        Duration(
            seconds: videoPlayerModel.currentStep!.first!.toInt(),
            milliseconds: milli),
      );
      videoPlayerModel.currentStep = preious;
      videoPlayerModel.seconds = preious.first!;
      videoPlayerModel.setShow();
      videoPlayerModel.shouldPauseAfterStepSwitch = true;

      videoPlayerModel.stop = false;
    }

    Size size = MediaQuery.of(context).size;
    final videoProvider =
        Provider.of<VideoPlayerProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: 200,
        backgroundColor: Colors.grey[900],
        child: ListView(
          children: [
            Consumer<IconState>(
              builder: (context, iconState, _) => CustomListTile(
                onTap: () {
                  iconState.toggleSelection();
                },
                text: "Step by step",
                leadingIcon: Icons.directions_walk,
                trealingIcon: iconState.isSelected
                    ? Icons.toggle_off_outlined
                    : Icons.toggle_on,
              ),
            ),
            CustomListTile(
              onTap: () {},
              text: "Next Move",
              leadingIcon: Icons.skip_next,
            ),
            CustomListTile(
              onTap: () {},
              text: "Repeat Move",
              leadingIcon: Icons.replay_rounded,
            ),
            CustomListTile(
              onTap: () {},
              text: "Diagram",
              leadingIcon: Icons.timeline_outlined,
            ),
            ExpansionTile(
              trailing: null,
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
              title: const Text(
                "Cameras",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "MuseoSans-100",
                ),
              ),
              children: [
                CustomListTile(
                  text: "Front",
                  onTap: () {
                    // videoPlayerModel.dispose();
                    videoPlayerModel.controller.pause();
                    videoPlayerModel.controller.dispose();
                    Navigator.pushReplacementNamed(context, "firstvideo");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => VideoScreen(
                    //       videoUrl: videoPlayerModel.videos[0].url,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                CustomListTile(
                  text: "Back",
                  onTap: () {
                    // videoPlayerModel.dispose();
                    videoPlayerModel.controller.pause();
                    videoPlayerModel.controller.dispose();
                    Navigator.pushNamed(context, "secondvideo");
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => VideoScreen(
                    //       videoUrl: videoPlayerModel.videos[1].url,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                CustomListTile(
                  text: "Left",
                  onTap: () {
                    // videoPlayerModel.dispose();
                    videoPlayerModel.controller.pause();
                    videoPlayerModel.controller.dispose();

                    Navigator.pushNamed(context, "thridvideo");
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => VideoScreen(
                    //       videoUrl: videoPlayerModel.videos[3].url,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                CustomListTile(
                  text: "Right",
                  onTap: () {
                    Navigator.pushNamed(context, "forthvideo");
                    // videoPlayerModel.dispose();
                    videoPlayerModel.controller.pause();
                    videoPlayerModel.controller.dispose();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) => VideoScreen(
                    //       videoUrl: videoPlayerModel.videos[2].url,
                    //     ),
                    //   ),
                    // );
                  },
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioBTnRow(
                  value: 1,
                  groupValue: _value,
                  text: "English name",
                  onChange: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                RadioBTnRow(
                  value: 2,
                  groupValue: _value,
                  text: "Korean name",
                  onChange: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                RadioBTnRow(
                  value: 3,
                  groupValue: _value,
                  text: "Korean & English",
                  onChange: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                fixheight2,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: const Text(
                    "Saju-Jirugu",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "MuseoSans-700",
                        fontSize: 23),
                  ),
                ),
                fixheight2,
                Padding(
                  padding: EdgeInsets.only(left: 10.w, bottom: 50.h),
                  child: const Text(
                    "Four Direction Punch",
                    style: TextStyle(
                        color: Colors.grey, fontFamily: "MuseoSans-100"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: videoPlayerModel.controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                videoPlayerModel.controller.value.aspectRatio,
                            child: VideoPlayer(videoPlayerModel.controller),
                          )
                        : Container(),
                  ),
                  Positioned(
                    bottom: 45,
                    child: SizedBox(
                      width: size.width,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Text(
                              "${videoPlayerModel.controller.value.position.inSeconds}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                if (videoPlayerModel.currentStep != null) {
                                  if (videoPlayerModel.currentStep!.id == 1) {
                                    return;
                                  }
                                } else {
                                  return;
                                }
                                // find previous step
                                StepModel preious = videoPlayerModel.steps
                                    .firstWhere((element) =>
                                        element.id! ==
                                        videoPlayerModel.currentStep!.id! - 1);
                                int milli = int.parse(videoPlayerModel
                                    .currentStep!.first
                                    .toString()
                                    .split(".")[1]);
                                log(milli.toString());
                                videoPlayerModel.controller.seekTo(
                                  Duration(
                                      seconds: videoPlayerModel
                                          .currentStep!.first!
                                          .toInt(),
                                      milliseconds: milli),
                                );
                                videoPlayerModel.currentStep = preious;
                                videoPlayerModel.seconds = preious.first!;
                                videoPlayerModel.setShow();
                                videoPlayerModel.shouldPauseAfterStepSwitch =
                                    true;

                                videoPlayerModel.stop = false;
                              },
                              child: Image.asset(
                                AppString.instance.refreshBTN,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                videoPlayerModel.controller.seekTo(
                                    const Duration(seconds: 0, minutes: 0));
                                videoPlayerModel.controller.pause();
                                videoPlayerModel.seconds = 0;
                                videoPlayerModel.currentStep = null;
                                setState(() {});
                              },
                              child: Image.asset(
                                AppString.instance.stopBTN,
                                height: 40,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                if (videoPlayerModel
                                    .controller.value.isPlaying) {
                                  videoPlayerModel.controller
                                      .pause()
                                      .then((value) {
                                    videoPlayerModel.timer = null;
                                    videoPlayerModel.stop = true;

                                    videoPlayerModel.stopTimer();
                                  });
                                } else {
                                  videoPlayerModel.controller
                                      .play()
                                      .then((value) {
                                    if (videoPlayerModel
                                            .controller.value.position ==
                                        const Duration(
                                            seconds: 0, minutes: 0)) {
                                      videoPlayerModel.startTimer();
                                    } else {
                                      videoPlayerModel.playTimer();
                                    }
                                    log("played pressed");
                                  });
                                }
                                setState(() {});
                              },
                              child: Image.asset(
                                videoPlayerModel.controller.value.isPlaying
                                    ? AppString.instance.pauseBTN
                                    : AppString.instance.playBTN,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            InkWell(
                              onTap: () {
                                if (videoPlayerModel.currentStep != null) {
                                  if (videoPlayerModel.currentStep!.id! + 1 ==
                                      15) {
                                    return;
                                  }
                                } else {
                                  return;
                                }
                                // find previous step
                                StepModel next = videoPlayerModel.steps
                                    .firstWhere((element) =>
                                        element.id! ==
                                        videoPlayerModel.currentStep!.id! + 1);
                                int milli = int.parse(videoPlayerModel
                                    .currentStep!.first
                                    .toString()
                                    .split(".")[1]);
                                log(milli.toString());
                                videoPlayerModel.controller.seekTo(Duration(
                                    seconds: videoPlayerModel
                                        .currentStep!.first!
                                        .toInt(),
                                    milliseconds: milli));
                                videoPlayerModel.currentStep = next;
                                videoPlayerModel.seconds = next.first!;
                                videoPlayerModel.setShow();
                                videoPlayerModel.shouldPauseAfterStepSwitch =
                                    true;
                                videoPlayerModel.stop = false;
                              },
                              child: Image.asset(
                                AppString.instance.nextBTN,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                            Text(
                              "${videoPlayerModel.controller.value.duration.inSeconds - videoPlayerModel.controller.value.position.inSeconds}",
                              style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.01,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (size.height / 2) - 20,
                    left: (size.width / 2) + 360,
                    child: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState?.openEndDrawer();
                      },
                      child: Image.asset(
                        AppString.instance.minimizeBTN_Right,
                        width: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: (size.width / 2) - 20,
                    child: InkWell(
                      onTap: () {
                        // toglle
                        videoPlayerModel.visable();
                      },
                      child: Image.asset(
                        AppString.instance.minimizeBTN,
                        width: 50,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.08,
                      color: Colors.white.withOpacity(.3),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.red,
                              ),
                            ),
                            // SizedBox(
                            //   width: size.width * 0.01,
                            // ),
                            const Text(
                              "Patterns",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "Saju-Jirugu",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(
                              width: 50,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // listview to get the milliseconds
            Visibility(
              visible: videoPlayerModel.showText,
              child: Container(
                width: size.width,
                height: size.height * 0.15,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Row(
                    children: [
                      Text(
                        videoPlayerModel.currentStep != null
                            ? videoPlayerModel.currentStep!.id.toString()
                            : "",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.02,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            videoPlayerModel.currentStep != null
                                ? videoPlayerModel.currentStep!.english
                                    .toString()
                                : "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: "MuseoSans-500"),
                          ),
                          Text(
                            videoPlayerModel.currentStep != null
                                ? videoPlayerModel.currentStep!.korean
                                    .toString()
                                : "",
                            style: TextStyle(
                                color: Colors.white.withOpacity(.7),
                                fontSize: 18,
                                fontFamily: "MuseoSans-500"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
