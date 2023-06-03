import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:vgram/firebase_files/firestore_methods.dart';
import 'package:vgram/provider/user_provider.dart';
import 'package:vgram/widgets/storymodel.dart';
import 'package:video_player/video_player.dart';

import '../utils/video_player_card.dart';

class Storypageview extends StatefulWidget {
  Storypageview({Key? key, required this.storySnap}) : super(key: key);
  final storySnap;

  @override
  State<Storypageview> createState() => _StorypageviewState();
}

class _StorypageviewState extends State<Storypageview> {
  StoryController storyController = StoryController();
  int i = 0;
  bool isLoad = false;

  showDialog1() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete Story?"),
            actions: [
              InkWell(
                onTap: () async {
                  setState(() {
                    isLoad = true;
                  });

                  storyController.pause();
                  print(widget.storySnap[i]['id']);
                  await FirestoreMethods()
                      .deleteStory(widget.storySnap[i]['id']);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red),
                  child: isLoad
                      ? Center(child: CircularProgressIndicator())
                      : Center(child: Text("Delete")),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 50,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green),
                  child: Center(child: Text("Cancle")),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      body: Stack(
        children: [
          StoryView(
            storyItems: [
              for (i = 0; i < widget.storySnap.length; i++)
                StoryItem.pageVideo(
                  widget.storySnap[i]['video'],
                  controller: storyController,
                  duration: Duration(seconds: 15),
                ),
            ],
            controller: storyController,
            indicatorColor: Colors.blue,
            onVerticalSwipeComplete: (p0) {
              if (p0 == Direction.up || p0 == Direction.down) {
                Navigator.pop(context);
              }
            },
            onComplete: () {
              Navigator.pop(context);
            },
          ),
          Positioned(
            top: 35,
            left: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.profile),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 5,
                    child: InkWell(
                      onTap: () {
                        // chooseVideo();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white)),
                        child: Icon(
                          Icons.add,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 35,
            right: 2,
            child: IconButton(
              onPressed: () {
                showDialog1();
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
