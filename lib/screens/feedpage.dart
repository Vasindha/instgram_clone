import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vgram/firebase_files/firestore_methods.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/widgets/story_pageview.dart';

import '../models/usermodel.dart';
import '../provider/user_provider.dart';
import '../utils/image.dart';
import '../utils/postcard.dart';
import '../widgets/storymodel.dart';
import 'add_story_preview.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Story> stories = [
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.image,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.video,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.image,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.video,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320")
  ];
  chooseVideo() async {
    XFile? video = await pickVideo();
    Navigator.pushNamed(context, StoryPreview.routeName,
        arguments: File(video!.path));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobilebg,
        actions: [
          IconButton(
              onPressed: () {},
              icon: InkWell(
                  onTap: () {
                    chooseVideo();
                  },
                  child: Icon(Icons.message)))
        ],
        title: Text(
          "Instagram",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('datepublished', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                index == 0
                                    ? SizedBox(
                                        height: 90,
                                        child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('user')
                                                .where('story', isNull: false)
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<
                                                        QuerySnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot1) {
                                             
                                              if (!snapshot.hasData ||
                                                  snapshot.connectionState ==
                                                      ConnectionState.waiting)
                                                return const CircularProgressIndicator();
                                              return Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          Navigator.of(context)
                                                              .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Storypageview(
                                                                  storySnap: user
                                                                      .story),
                                                        ),
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          CircleAvatar(
                                                            radius: 40,
                                                            backgroundImage:
                                                                NetworkImage(user
                                                                    .profile),
                                                          ),
                                                          Positioned(
                                                            bottom: 4,
                                                            right: 5,
                                                            child: InkWell(
                                                              onTap: () {
                                                                chooseVideo();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white)),
                                                                child: Icon(
                                                                  Icons.add,
                                                                  size: 20,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: ListView.builder(
                                                        itemCount: snapshot1
                                                            .data!.docs.length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index1) {
                                                          return snapshot1.data!
                                                                              .docs[
                                                                          index1]
                                                                      ['uid'] ==
                                                                  user.uid
                                                              ? Container()
                                                              : Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      GestureDetector(
                                                                          onTap: () =>
                                                                              Navigator.of(context)
                                                                                  .push(
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => Storypageview(
                                                                                    storySnap: snapshot1.data!.docs[index1]['story'],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                          child: CircleAvatar(
                                                                              radius: 40,
                                                                              backgroundImage: NetworkImage(snapshot1.data!.docs[index1]['profile']))),
                                                                );
                                                        }),
                                                  ),
                                                ],
                                              );
                                            }),
                                      )
                                    : Container(),
                                PostCard(snap: snapshot.data?.docs[index])
                              ],
                            );
                          }),
                    );
            },
          )
        ],
      ),
    );
  }

  // Widget story() {
  //   return
  // }

  // Widget post(context) {
  //   final user _user = Provider.of<UserProvider>(context).getUser;

  //   return
  // }
}
