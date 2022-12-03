import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vgram/screens/addpage.dart';
import 'package:vgram/screens/feedpage.dart';
import 'package:vgram/screens/profilepage.dart';
import 'package:vgram/screens/searchpage.dart';

const websize = 600;

List<Widget> HomeScreenItem = [
  FeedPage(),
  SearchScreen(),
  Addpage(),
  Center(
    child: Text("Flutter Developer RAHUL",style: TextStyle(color: Colors.blueAccent),),
  ),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser?.uid)
];
