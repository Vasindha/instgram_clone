import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/followcard.dart';
import 'package:vgram/utils/likecard.dart';

class Follow_user extends StatefulWidget {
  Follow_user({Key? key, required this.type, required this.uid})
      : super(key: key);
  final uid;
  final type;

  @override
  State<Follow_user> createState() => _Follow_userState();
}

class _Follow_userState extends State<Follow_user> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobilebg,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            widget.type == "followers" ? Text("Followers") : Text("Following"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs[0][widget.type].length,
              itemBuilder: (context, index) {
                return Likecard(
                    uid: snapshot.data!.docs[0][widget.type][index]);
              });
        },
      ),
    );
  }
}
