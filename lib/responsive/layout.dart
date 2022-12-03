import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vgram/provider/user_provider.dart';
import 'package:vgram/responsive/mobile.dart';
import 'package:vgram/responsive/web.dart';
import 'package:vgram/utils/globale_variable.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({Key? key}) : super(key: key);

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  void initState() {
    super.initState();
   addData();
  }

   addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
     _userProvider.refreshUser();
   }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth > websize) {
          return const WebScreen();
        }
        return const MobileScreen();
      },
    );
  }
}
