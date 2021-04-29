import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:drink_me/screens/config_screen.dart';
import 'package:drink_me/utils/colors.dart';
import 'package:drink_me/screens/historic_screen.dart';
import 'package:drink_me/screens/home_screen.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset("assets/images/logo.png", width: 130),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              children: <Widget>[
                HomeScreen(),
                HistoricScreen(),
                ConfigScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Início'),
            textAlign: TextAlign.center,
            icon: Icon(Icons.home),
            activeColor: kPrimaryColor,
            inactiveColor: kQuaternaryColor,
          ),
          BottomNavyBarItem(
            title: Text('Histórico'),
            textAlign: TextAlign.center,
            icon: Icon(Icons.history),
            activeColor: kPrimaryColor,
            inactiveColor: kQuaternaryColor,
          ),
          BottomNavyBarItem(
            title: Text('Config.'),
            textAlign: TextAlign.center,
            icon: Icon(Icons.settings),
            activeColor: kPrimaryColor,
            inactiveColor: kQuaternaryColor,
          ),
        ],
      ),
    );
  }
}
