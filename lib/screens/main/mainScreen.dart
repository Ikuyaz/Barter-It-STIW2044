import 'package:barterit/screens/User/addScreen.dart';
import 'package:barterit/screens/User/profileScreen.dart';
import 'package:barterit/screens/trade/tradeScreen.dart';
import 'package:barterit/screens/trade/tradetabScreen.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> tabChildren;
  int _currentIndex = 0;
  String mainTitle = "Home";

  @override
  void initState() {
    super.initState();
    print(widget.user.name);
    print("MainScreen");
    bool isGuest = 0 == widget.user.id;
    tabChildren = [
      tradeTabScreen(user: widget.user),
      tradeScreen(user: widget.user),
      addScreen(
        user: widget.user,
        isGuest: isGuest,
      ),
      profilePage(user: widget.user),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    // print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabChildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_calls),
            label: 'Trade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        mainTitle = 'Home';
      } else if (_currentIndex == 1) {
        mainTitle = 'Trade';
      } else if (_currentIndex == 2) {
        mainTitle = 'Add';
      } else if (_currentIndex == 3) {
        mainTitle = 'Profile';
      }
    });
  }
}
