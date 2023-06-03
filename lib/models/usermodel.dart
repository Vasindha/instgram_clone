// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class user {
  final String email;
  final String username;
  final List followers;
  final List following;
  final String uid;
  final String profile;
  final String bio;
  final List<dynamic> story;
  user({
    required this.email,
    required this.username,
    required this.followers,
    required this.following,
    required this.uid,
    required this.profile,
    required this.bio,
    required this.story,
  });
  Map<String, dynamic> toJsond() => {
        "email": email,
        "username": username,
        "uid": uid,
        "bio": bio,
        "profile": profile,
        "followers": followers,
        "following": following,
        "story": story
      };
  static user formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return user(
        email: snapshot['email'],
        story: snapshot['story'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        profile: snapshot['profile'],
        uid: snapshot['uid'],
        username: snapshot['username']);
  }
}
