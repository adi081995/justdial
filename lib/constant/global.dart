import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/screens/forgetpass.dart';
import 'package:nlytical/screens/newTabbar.dart';

import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

const Color appColorGreen = Color(0xFF1E3C72);
const Color appColorWhite = Colors.white;
const Color appColorBlack = Colors.black;
SharedPreferences preferences;
String userID = '';
String userName = '';
String userImg = '';
String user = '';
var likeStore = [];

String serverKey =
    'AAAAg4ubCQ0:APA91bEcmbLF2OCSqLf_gsnQV99LHi0FWhlAFClggKVRLvUKagqxVAR1qRDtHsb4hIUCSS1clbVkintJKSICvVFKg9aZUn_2KyYiwINT6JY8ZfOLfW-X4uthSWwI9o4OjJPVhpmhP4lA';

Client client = Client();

Future closeKeyboard() {
  return SystemChannels.textInput.invokeMethod('TextInput.hide');
}

String baseUrl() {
  return 'https://business.arorasons.com/api/';
}

void forgoterrorDialog(BuildContext context, String message, {bool button}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 10.0),
            Text(message, textAlign: TextAlign.center),
            Container(height: 30.0),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 100,
               // ignore: deprecated_member_use
              child: OutlineButton(
                onPressed: button == null
                    ? () => Navigator.pop(context)
                    : () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => ForgetPass(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

// ignore: must_be_immutable
class CustomtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  CustomtextField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _CustomtextFieldState createState() => _CustomtextFieldState();
}

class _CustomtextFieldState extends State<CustomtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.black),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(40),
        ),
        hintText: widget.hintText,
        focusColor: Colors.black,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: appColorGreen, width: 1.8),
          borderRadius: BorderRadius.circular(40),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.5),
          borderRadius: BorderRadius.circular(40),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchField extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  SearchField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        labelStyle:
            TextStyle(color: Color(0XFF106C6F), fontWeight: FontWeight.bold),
        hintStyle:
            TextStyle(color: Color(0XFF106C6F), fontWeight: FontWeight.bold),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF106C6F), width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF106C6F), width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchFieldnormal extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  SearchFieldnormal({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _SearchFieldnormalState createState() => _SearchFieldnormalState();
}

class _SearchFieldnormalState extends State<SearchFieldnormal> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        border: new OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(14.0),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20,
        ),
        errorStyle: TextStyle(color: Colors.white),
        errorText: widget.errorText,
        hintText: widget.hintText,
        labelStyle:
            TextStyle(color: Color(0XFF106C6F), fontWeight: FontWeight.bold),
        hintStyle:
            TextStyle(color: Color(0XFF003F4F), fontWeight: FontWeight.bold),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF106C6F), width: 1.8),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0XFF106C6F), width: 1.8),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class CustomButtom extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;
  CustomButtom({
    this.color,
    this.title,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
       // ignore: deprecated_member_use
      child: RaisedButton(
        onPressed: onPressed,
        color: Color(0xFF1E3C72),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [Color(0xFF1E3C72), Color(0xFF2a5298)],
          //       begin: Alignment.centerLeft,
          //       end: Alignment.centerRight,
          //     ),
          //     borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

void errorDialog(BuildContext context, String message, {bool button}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 10.0),
            Text(message, textAlign: TextAlign.center),
            Container(height: 30.0),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 100,
               // ignore: deprecated_member_use
              child: OutlineButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TabbarScreen()),
                  );
                  // Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

void loginerrorDialog(BuildContext context, String message, {bool button}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(height: 10.0),
            Text(message, textAlign: TextAlign.center),
            Container(height: 30.0),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width - 100,
               // ignore: deprecated_member_use
              child: OutlineButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TabbarScreen()),
                  // );
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

class Loader {
  void showIndicator(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
            child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.white.withOpacity(0.7),
              ),
              Center(child: CupertinoActivityIndicator())
            ],
          ),
        ));
      },
    );
  }

  void hideIndicator(BuildContext context) {
    Navigator.pop(context);
  }
}

dynamic safeQueries(BuildContext context) {
  return (MediaQuery.of(context).size.height >= 812.0 ||
      MediaQuery.of(context).size.height == 812.0 ||
      (MediaQuery.of(context).size.height >= 812.0 &&
          MediaQuery.of(context).size.height <= 896.0 &&
          Platform.isIOS));
}

// ignore: must_be_immutable
class ReviewtextField extends StatefulWidget {
  final TextInputType keyboardType;
  final Function onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function onEditingComplate;
  final Function onSubmitted;
  final dynamic controller;
  final int maxLines;
  final dynamic onChange;
  final String errorText;
  final String hintText;
  final String labelText;
  bool obscureText = false;
  bool readOnly = false;
  bool autoFocus = false;
  final Widget suffixIcon;

  final Widget prefixIcon;
  ReviewtextField({
    this.keyboardType,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplate,
    this.onSubmitted,
    this.controller,
    this.maxLines,
    this.onChange,
    this.errorText,
    this.hintText,
    this.labelText,
    this.obscureText = false,
    this.readOnly = false,
    this.autoFocus = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _ReviewtextFieldState createState() => _ReviewtextFieldState();
}

class _ReviewtextFieldState extends State<ReviewtextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onTap: widget.onTap,
      autofocus: widget.autoFocus,
      maxLines: widget.maxLines,
      onEditingComplete: widget.onEditingComplate,
      onSubmitted: widget.onSubmitted,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.controller,
      onChanged: widget.onChange,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
        errorStyle: TextStyle(color: Colors.black),
        errorText: widget.errorText,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: widget.hintText,
        labelStyle: TextStyle(color: Color(0xFF106C6F)),
        hintStyle: TextStyle(color: Color(0xFF106C6F)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.8),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

LocationData locationData;

Future<LocationData> getCurrentLocation() async {
  print("getCurrentLocation");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('currentLat') && prefs.containsKey('currentLon')) {
    locationData = LocationData.fromMap({
      "latitude": prefs.getDouble('currentLat'),
      "longitude": prefs.getDouble('currentLon')
    });
  } else {
    setCurrentLocation().then((value) {
      if (prefs.containsKey('currentLat') && prefs.containsKey('currentLon')) {
        locationData = LocationData.fromMap({
          "latitude": prefs.getDouble('currentLat'),
          "longitude": prefs.getDouble('currentLon')
        });
      }
    });
  }
  return locationData;
}

Future<LocationData> setCurrentLocation() async {
  var location = new Location();
  location.requestService().then((value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      locationData = await location.getLocation();
      await prefs.setDouble('currentLat', locationData.latitude);
      await prefs.setDouble('currentLon', locationData.longitude);
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  });
  return locationData;
}

Widget load() {
  return Center(
    child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(appColorGreen)),
              )),
        )),
  );
}

void signOutGoogle() async {
  await auth.FirebaseAuth.instance.signOut();
}


