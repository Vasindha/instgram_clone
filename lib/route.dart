import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vgram/screens/login_screen.dart';
import 'package:vgram/screens/signup_page.dart';
import 'package:vgram/screens/add_story_preview.dart';

Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(builder: (_) => LoginPage());
    case Signuppage.routeName:
      return MaterialPageRoute(builder: (_) => Signuppage());

    case StoryPreview.routeName:
      File video = settings.arguments as File;
      return MaterialPageRoute(builder: (_) => StoryPreview(video: video,));
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                  child: Text("Page not found"),
                ),
              ));
  }
}
