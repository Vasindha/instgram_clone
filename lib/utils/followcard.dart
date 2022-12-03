import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:vgram/utils/image.dart';

import '../firebase_files/firestore_methods.dart';
import '../widgets/follow_button.dart';

class FollowCard extends StatefulWidget {
  FollowCard({Key? key, required this.uid}) : super(key: key);
  final uid;

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  @override
  void initState() {
    super.initState();

    getData();
  }

  Map<String, dynamic>? userdata = {};
  bool isFollowing = true;
  void getData() async {
    // ignore: unused_local_variable
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();
      setState(() {
        userdata = usersnap.data();
        isFollowing = usersnap
            .data()!['followers']
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return userdata!.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      CachedNetworkImageProvider(userdata!['profile']),
                ),
                Gap(15),
                Text(userdata!['username']),
                Spacer(),
                userdata!['uid'] == FirebaseAuth.instance.currentUser!.uid
                    ? Container()
                    : isFollowing
                        ? Followbutton(
                            height: 27,
                            width: 150,
                            bgcolor: Colors.white,
                            bordercolor: Colors.blue,
                            text: "Unfollow",
                            textcolor: Colors.black,
                            function: () async {
                              await FirestoreMethods().followuser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userdata!['uid']);
                              setState(() {
                                isFollowing = false;
                              });
                            },
                          )
                        : Followbutton(
                            height: 27,
                            width: 150,
                            bgcolor: Colors.blue,
                            bordercolor: Colors.blue,
                            text: "Follow",
                            textcolor: Colors.white,
                            function: () async {
                              await FirestoreMethods().followuser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  userdata!['uid']);
                              setState(() {
                                isFollowing = true;
                              });
                            },
                          ),
              ],
            ),
          );
  }
}
