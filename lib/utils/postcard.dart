import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vgram/firebase_files/firestore_methods.dart';
import 'package:vgram/models/usermodel.dart';
import 'package:vgram/provider/user_provider.dart';
import 'package:vgram/screens/comment_page.dart';
import 'package:vgram/screens/likes_page.dart';
import 'package:vgram/screens/search_profile.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/widgets/like_animation.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlength = 0;
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postid'])
        .collection('comments')
        .snapshots()
        .listen((event) {
      setState(() {
        getComments();
      });
    });
    super.initState();
    getComments();
  }

  void getComments() async {
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.snap['postid'])
        .collection('comments')
        .get();

    setState(() {
      commentlength = snap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user _user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            SearchProfile(uid: widget.snap['uid'])));
                  },
                  child: CircleAvatar(
                      radius: 16,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.snap['profileimage'])),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    SearchProfile(uid: widget.snap['uid'])));
                          },
                          child: Text(
                            widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.currentUser!.uid ==
                              widget.snap['uid']
                          ? showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                  child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                children: [Text("Delete")]
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            await FirestoreMethods().DeletePost(
                                                widget.snap['postid']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 16),
                                            child: e,
                                          ),
                                        ))
                                    .toList(),
                              )),
                            )
                          : showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                      child: ListView(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(
                                              bottom: 16, top: 16, left: 10),
                                          children: [
                                        Text("It's not your story")
                                      ])));
                    },
                    icon: Icon(Icons.more_vert))
              ],
            ),
          ),
          //Image section

          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postid'], _user.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.snap['posturl'],
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: ((context, url, error) => Icon(
                          Icons.error,
                          color: Colors.red,
                        )),
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLikeAnimating ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: LikeAnimation(
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 80,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          //like comment
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(_user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                        widget.snap['postid'], _user.uid, widget.snap['likes']);
                  },
                  icon: widget.snap['likes'].contains(_user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentPage(
                          snap: widget.snap,
                        ))),
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark),
                ),
              ))
            ],
          ),
          //description and comments

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Likepage(snap: widget.snap)));
                    },
                    child: Text(
                      '${widget.snap['likes'].length} Likes',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(style: TextStyle(color: primary), children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' ${widget.snap['description']}',
                      ),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentPage(
                            snap: widget.snap,
                          ))),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "View all ${commentlength} Comments...",
                      style: TextStyle(fontSize: 16, color: secondory),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datepublished'].toDate()),
                    style: TextStyle(fontSize: 16, color: secondory),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
