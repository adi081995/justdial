import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertLogin extends StatefulWidget {
  @override
  _AlertLoginState createState() => _AlertLoginState();
}

class _AlertLoginState extends State<AlertLogin> {
  initState() {
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

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 130,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      const Color(0xFFB677B4),
                      const Color(0xFF8A63BF),
                    ]),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 10.0, right: 0.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.line_weight,
                          size: 24,
                          color: Colors.black,
                        ),
                        onPressed: () => scaffoldKey.currentState.openDrawer(),
                      ),
                    ),
                  ),
                  Text(
                    "Services",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Icon(
                    Icons.navigate_before,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Text('Hello'),
    );
  }
}
