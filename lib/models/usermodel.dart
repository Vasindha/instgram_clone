import 'package:cloud_firestore/cloud_firestore.dart';

class user {
  final String email;
  final String username;
  final List followers;
  final List following;
  final String uid;
  final String profile;
  final String bio;
  user({
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.profile,
    required this.uid,
    required this.username,
  });
  Map<String, dynamic> toJsond() => {
        "email": email,
        "username": username,
        "uid": uid,
        "bio": bio,
        "profile": profile,
        "followers": followers,
        "following": following
      };
  static user formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return user(
        email: snapshot['email'],
        bio: snapshot['bio'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        profile: snapshot['profile'],
        uid: snapshot['uid'],
        username: snapshot['username']);
  }
}
