import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vgram/utils/colors.dart';
import 'package:vgram/utils/globale_variable.dart';

class MobileScreen extends StatefulWidget {
  const MobileScreen({Key? key}) : super(key: key);

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  int _page = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  void navigatepage(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void onchange(page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: onchange,
          children: HomeScreenItem),
      bottomNavigationBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primary : secondory,
            ),
            label: "",
            backgroundColor: primary),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primary : secondory,
            ),
            label: "",
            backgroundColor: primary),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primary : secondory,
            ),
            label: "",
            backgroundColor: primary),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primary : secondory,
            ),
            label: "",
            backgroundColor: primary),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primary : secondory,
            ),
            label: "",
            backgroundColor: primary),
      ], onTap: navigatepage),
    );
  }
}
