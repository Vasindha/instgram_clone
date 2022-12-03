
import 'package:flutter/material.dart';

import 'package:vgram/screens/search_profile.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/likecard.dart';

class Likepage extends StatefulWidget {
  Likepage({Key? key, required this.snap}) : super(key: key);
  final snap;

  @override
  State<Likepage> createState() => _LikepageState();
}

class _LikepageState extends State<Likepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobilebg,
          title: Text("Likes"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: widget.snap['likes'] == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.snap['likes'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              SearchProfile(uid: widget.snap['likes'][index]))),
                      child: Likecard(uid: widget.snap['likes'][index]));
                }));
  }
}
