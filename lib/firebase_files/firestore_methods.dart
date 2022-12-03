import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:vgram/firebase_files/storage.dart';
import 'package:vgram/models/post_model.dart';

class FirestoreMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post

  Future<String> uploadPost(String username, String des, Uint8List file,
      String uid, String profileimage) async {
    String res = 'Some error occured';

    try {
      String photoUrl = await StorageMethods().storeImage("Posts", file, true);
      String postid = Uuid().v1();
      Post post = Post(
          description: des,
          postid: postid,
          posturl: photoUrl,
          profileimage: profileimage,
          datepublished: DateTime.now(),
          uid: uid,
          username: username,
          likes: []);
      _firestore.collection("posts").doc(postid).set(post.toJsond());
      res = "Success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postid, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postid).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> PostComment(String postid, String uid, String text,
      String profile, String name) async {
    try {
      if (text.isNotEmpty) {
        String commentId = Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postid)
            .collection("comments")
            .doc(commentId)
            .set({
          'profile': profile,
          'name': name,
          'uid': uid,
          'datePublished': DateTime.now(),
          'text': text,
          'commentid': commentId
        });
      } else {
        print('text is empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> DeletePost(String postid) async {
    try {
      await _firestore.collection('posts').doc(postid).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followuser(String uid, String followid) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('user').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];


      if (following.contains(followid)) {
        await _firestore
            .collection('user')
            .doc(followid)
            .update({'followers': FieldValue.arrayRemove([uid])});

             await _firestore
            .collection('user')
            .doc(uid)
            .update({'following': FieldValue.arrayRemove([followid])});
      }

else{

   await _firestore
            .collection('user')
            .doc(followid)
            .update({'followers': FieldValue.arrayUnion([uid])});

             await _firestore
            .collection('user')
            .doc(uid)
            .update({'following': FieldValue.arrayUnion([followid])});

}
      
    } catch (e) {
      print(e.toString());
    }
  }
}
