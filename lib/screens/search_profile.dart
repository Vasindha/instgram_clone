import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vgram/screens/Authpage.dart';
import 'package:vgram/screens/follow.dart';
import 'package:vgram/screens/login_screen.dart';
import 'package:vgram/screens/post.dart';
import 'package:vgram/utils/colors.dart';

import '../firebase_files/auth_methods.dart';
import '../firebase_files/firestore_methods.dart';
import '../utils/image.dart';
import '../widgets/follow_button.dart';

class SearchProfile extends StatefulWidget {
  SearchProfile({Key? key, required this.uid}) : super(key: key);
  final uid;
  @override
  State<SearchProfile> createState() => _SearchProfileState();
}

class _SearchProfileState extends State<SearchProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.uid)
        .snapshots()
        .listen(
          (event) => getdata(),
        );
    getdata();
  }

  int postlength = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;
  Map<String, dynamic> userdata = {};
  var snapuser;

  void getdata() async {
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.uid)
          .get();

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postlength = postsnap.docs.length;
      followers = usersnap.data()!['followers'].length;
      following = usersnap.data()!['following'].length;
      isfollowing = usersnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        userdata = usersnap.data()!;
        snapuser = postsnap;
      });
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return userdata == null ||
            snapuser == null ||
            followers == null ||
            following == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobilebg,
              title: Text(
                userdata['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                  userdata['profile'])),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildcolumn(postlength, "Post"),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Follow_user(
                                                          type: "followers",
                                                          uid: widget.uid)));
                                        },
                                        child: buildcolumn(
                                            followers, "followers")),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Follow_user(
                                                          type: 'following',
                                                          uid: widget.uid)));
                                        },
                                        child: buildcolumn(
                                            following, "following")),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    userdata['uid'] ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? Followbutton(
                                            height: 27,
                                            width: 209,
                                            bgcolor: mobilebg,
                                            bordercolor: Colors.grey,
                                            text: "Sign out",
                                            textcolor: primary,
                                            function: () {
                                              FirebaseAuth.instance.signOut();

                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Authpage()));
                                            },
                                          )
                                        : isfollowing
                                            ? Followbutton(
                                                height: 27,
                                                width: 209,
                                                bgcolor: Colors.white,
                                                bordercolor: Colors.grey,
                                                text: "Unfollow",
                                                textcolor:
                                                    Color.fromRGBO(0, 0, 0, 1),
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followuser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userdata['uid']);
                                                  setState(() {
                                                    isfollowing = false;
                                                  });
                                                },
                                              )
                                            : Followbutton(
                                                height: 27,
                                                width: 209,
                                                bgcolor: Colors.blue,
                                                bordercolor: Colors.blue,
                                                text: "Follow",
                                                textcolor: Colors.white,
                                                function: () async {
                                                  await FirestoreMethods()
                                                      .followuser(
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid,
                                                          userdata['uid']);
                                                  setState(() {
                                                    isfollowing = true;
                                                  });
                                                },
                                              )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 15),
                        child: Text(
                          userdata['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 1),
                        child: Text(
                          userdata['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where('uid', isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 1.5,
                                  childAspectRatio: 1),
                          itemBuilder: (context, index) {
                            var user = snapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PostPage(
                                            uid: widget.uid,
                                            initIndex: index,
                                          ))),
                              child: Container(
                                  child: CachedNetworkImage(
                                imageUrl: user['posturl'],
                                fit: BoxFit.cover,
                              )),
                            );
                          });
                    })
              ],
            ),
          );
  }

  Column buildcolumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
