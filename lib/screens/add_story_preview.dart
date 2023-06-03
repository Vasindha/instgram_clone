import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/firebase_files/storage.dart';
import 'package:vgram/provider/user_provider.dart';

import 'package:vgram/widgets/follow_button.dart';
import 'package:video_player/video_player.dart';

import '../firebase_files/firestore_methods.dart';

class StoryPreview extends StatefulWidget {
  static const routeName = 'preview';
  StoryPreview({super.key, required this.video});
  File? video;

  @override
  State<StoryPreview> createState() => _StoryPreviewState();
}

class _StoryPreviewState extends State<StoryPreview> {
  late VideoPlayerController videoPlayerController;
  bool isLoad = false;
  shareStory() async {
    setState(() {
      isLoad = true;
    });
    String url = await StorageMethods()
        .storeVideo(childName: "Story", video: widget.video!);
    await FirestoreMethods().shareStory(
        url: url,
        uid: Provider.of<UserProvider>(context, listen: false).getUser.uid);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.file(widget.video!)
      ..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            child: VideoPlayer(videoPlayerController),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                InkWell(
                  onTap: shareStory,
                  child: isLoad
                      ? CircularProgressIndicator()
                      : Followbutton(
                          height: 50,
                          width: size.width * 0.50,
                          bgcolor: Colors.blue,
                          bordercolor: Colors.white,
                          text: "Share",
                          textcolor: Colors.white),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
