import 'package:flutter/cupertino.dart';
import 'package:vgram/firebase_files/auth_methods.dart';
import 'package:vgram/models/usermodel.dart';

class UserProvider extends ChangeNotifier {
  user? _user;
  user get getUser => _user!;
  final AuthMethods _methods = AuthMethods();

  Future<void> refreshUser() async {
    user us = await _methods.getuserDetails();
    _user = us;

    notifyListeners();
  }
}
