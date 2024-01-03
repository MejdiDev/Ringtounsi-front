import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:ringtounsi_mobile/view/profile.dart';
import 'package:ringtounsi_mobile/view/welcomeScreen.dart';
import 'package:ringtounsi_mobile/view/LevelScreen.dart';
import 'package:ringtounsi_mobile/view/SearchCoachScreen.dart';
import '../model/user.dart'; // Import other pages

class FirstScreen extends StatefulWidget {
  final User user;

  FirstScreen({required this.user});

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final items = const [
    Icon(
      Icons.person,
      size: 30,
      color: Color(0xff5ca9e9), // Set icon color here
    ),
    Icon(
      Icons.sports,
      size: 30,
      color: Color(0xff5ca9e9), // Set icon color here
    ),
    Icon(
      Icons.grade,
      size: 30,
      color: Color(0xff5ca9e9), // Set icon color here
    ),
    Icon(
      Icons.search_outlined,
      size: 30,
      color: Color(0xff5ca9e9), // Set icon color here
    )
  ];

  int index = 1;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // Ensure bottom navigation bar doesn't overlay body content
      backgroundColor:
          Colors.transparent, // Set the overall background to be transparent
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        index: index,
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
          });
        },
        height: 70,
        backgroundColor: Colors
            .transparent, // Set the background of the navigation bar to be transparent
        animationDuration: const Duration(milliseconds: 300),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffe4f3e3), Color(0xff5ca9e9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: getSelectedWidget(index: index, user: currentUser),
      ),
    );
  }

  Widget getSelectedWidget({required int index, required User user}) {
    late Widget widget;
    switch (index) {
      case 1:
        widget = ProfileScreen(user: user);
        break;
      case 0:
        widget = LevelScreen();
        break;
      case 2:
        widget = SearchCoachScreen();
        break;
      default:
        widget = Container();
        break;
    }
    return widget;
  }
}
