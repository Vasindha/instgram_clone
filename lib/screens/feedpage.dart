import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/widgets/story_pageview.dart';

import '../models/usermodel.dart';
import '../provider/user_provider.dart';
import '../utils/postcard.dart';
import '../widgets/storymodel.dart';

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
            "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.video,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.image,
        url:
            "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
    Story(
        duration: Duration(seconds: 10),
        media: MediaType.video,
        url:
            "https://firebasestorage.googleapis.com/v0/b/vgram-6772a.appspot.com/o/video%2F272283107_631119008217014_3812681377246544827_n.mp4?alt=media&token=a2b1967e-61b8-4bd4-acb8-fdb980993320")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobilebg,
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.message))],
          title: Text(
            "Instagram",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 90,
              child: story(),
            ),
            Expanded(child: post(context))
          ],
        ));
  }

  Widget story() {
    return ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Storypageview(stories: stories))),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
              ),
            ),
          );
        });
  }

  Widget post(context) {
    final user _user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
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
            : ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return PostCard(snap: snapshot.data?.docs[index]);
                });
      },
    );
  }
}
