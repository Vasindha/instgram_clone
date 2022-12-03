import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String profileimage;
  final String posturl ;
  final String uid;
  final String postid;
  final  datepublished;
  final likes;
  Post({
    required this.description,
    required this.postid,
    required this.posturl,
    required this.profileimage,
    required this.datepublished,
    required this.uid,
    required this.username,
    required this.likes
  });
  Map<String, dynamic> toJsond() => {
        "description": description,
        "username": username,
        "uid": uid,
        "postid": postid,
        "datepublished": datepublished,
        "profileimage": profileimage,
        "likes": likes,
        "posturl":posturl

      };
  static Post formSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        description: snapshot['description'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        postid: snapshot['postid'],
        datepublished: snapshot['datepublished'],
        profileimage: snapshot['profileimage'],
        likes: snapshot['likes'],
        posturl: snapshot['posturl']
        );
  }
}
