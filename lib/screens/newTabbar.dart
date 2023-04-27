import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/screens/favourite_list.dart';
import 'package:nlytical/screens/categoriesNew.dart';
import 'package:nlytical/screens/explore.dart';
import 'package:nlytical/screens/homeNew.dart';
import 'package:nlytical/screens/profile.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class TabbarScreen extends StatefulWidget {
  int currentIndex;

  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  int _currentIndex = 0;

  List<dynamic> _handlePages = [
    HomeNew(),
    Explore(),
    CategoriesNew(),
    FavouriteRest(),
    Profile(),
  ];

  @override
  void initState() {
    getUserDataFromPrefs();

    super.initState();
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr);
    print(userData);

    setState(() {
      userID = userData['user_id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _handlePages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          topLeft: Radius.circular(0),
        ),
        child: BottomNavigationBar(
            selectedIconTheme: IconThemeData(color: appColorWhite),
            selectedItemColor: appColorWhite,
            unselectedIconTheme: IconThemeData(color: Colors.grey),
            unselectedItemColor: Colors.grey,
            backgroundColor: appColorGreen,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: <BottomNavigationBarItem>[
              _currentIndex == 0
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.house_fill,
                      ),
                      label: "Home")
                  : BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.house_fill,
                      ),
                      label: "Home"),
              _currentIndex == 1
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.compass_fill,
                        size: 27,
                      ),
                      label: "Explore")
                  : BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.compass_fill,
                        size: 27,
                      ),
                      label: "Explore"),
              _currentIndex == 2
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        Icons.category,
                      ),
                      label: "Catrgories")
                  : BottomNavigationBarItem(
                      icon: Icon(
                        Icons.category,
                      ),
                      label: "Catrgories"),
              _currentIndex == 3
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.heart_fill,
                      ),
                      label: "Favourite")
                  : BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.heart_fill,
                      ),
                      label: "Favourite"),
              _currentIndex == 4
                  ? BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.person_fill,
                      ),
                      label: "Profile")
                  : BottomNavigationBarItem(
                      icon: Icon(
                        CupertinoIcons.person_fill,
                      ),
                      label: "Profile"),
            ]),
      ),
    );
  }
}
