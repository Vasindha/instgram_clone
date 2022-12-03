import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/foundation.dart';
import 'package:vgram/firebase_files/storage.dart';
import 'package:vgram/models/usermodel.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.user> getuserDetails() async {
    User curentuser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('user').doc(curentuser.uid).get();

    return model.user.formSnap(snap);
  }

  // Future<void> signout() async {
  //   await _auth.signOut();
  // }

  Future<String> signUpuser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential _cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photourl =
            await StorageMethods().storeImage("Profilepics", file, false);

        model.user user = model.user(
            uid: _cred.user!.uid,
            username: username,
            followers: [],
            following: [],
            bio: bio,
            email: email,
            profile: photourl);

        await _firestore
            .collection("user")
            .doc(_cred.user!.uid)
            .set(user.toJsond());
        res = "Succes";
        print(res);
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser(String email, String password) async {
    String res = "Some error occured";
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      res = "Succes";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
