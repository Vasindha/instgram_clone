import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/firebase_files/firestore_methods.dart';
import 'package:vgram/models/usermodel.dart';
import 'package:vgram/responsive/layout.dart';
import 'package:vgram/screens/Authpage.dart';
import 'package:vgram/screens/follow.dart';
import 'package:vgram/screens/login_screen.dart';
import 'package:vgram/screens/post.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/image.dart';
import 'package:vgram/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key, required this.uid}) : super(key: key);
  final uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userdata = {};
  var snapuser;
  int postlength = 0;
  int followers = 0;
  int following = 0;
  bool isfollowing = false;

  @override
  void initState() {
    // TODO: implement initState
    FirebaseFirestore.instance
        .collection("user")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen(
          (event) => getData(),
        );
    getData();
    super.initState();
  }

  getData() async {
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var postsnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                                                          uid: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)));
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
                                                          uid: FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid)));
                                        },
                                        child: buildcolumn(
                                            following, "following")),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Followbutton(
                                      height: 27,
                                      width: 209,
                                      bgcolor: mobilebg,
                                      bordercolor: Colors.grey,
                                      text: "Sign out",
                                      textcolor: primary,
                                      function: () {
                                        FirebaseAuth.instance.signOut();

                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Authpage()));
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
                        child: Text(userdata['bio']),
                      )
                    ],
                  ),
                ),
                Divider(),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .where('uid',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
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
                                            uid: FirebaseAuth
                                                .instance.currentUser!.uid,
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
