import 'package:barterit/screens/User/addScreen.dart';
import 'package:barterit/screens/User/profileScreen.dart';
import 'package:barterit/screens/trade/tradeScreen.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';

class homeScreen extends StatefulWidget {
  final User user;

  const homeScreen({super.key, required this.user});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Main";

  @override
  void initState() {
    super.initState();
    //print(widget.user.name);
    print("Mainscreen");
    bool isGuest = 0 == widget.user.id;
    tabchildren = [
      homeScreen(
        user: widget.user,
      ),
      tradeScreen(user: widget.user),
      profilePage(user: widget.user),
      addScreen(
        user: widget.user,
        isGuest: false,
      )
    ];
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
      if (_currentIndex == 0) {
        maintitle = "Main";
      }
      if (_currentIndex == 1) {
        maintitle = "Add";
      }
      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}
