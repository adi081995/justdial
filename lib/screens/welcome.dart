import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/fb_sign_in.dart';
import 'package:nlytical/screens/login.dart';
import 'package:nlytical/screens/model/login_modal.dart';
import 'package:nlytical/screens/newTabbar.dart';
import 'package:nlytical/screens/signup.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Container(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/transparent_n_80.png',
                            width: SizeConfig.blockSizeHorizontal * 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text('Welcome to Nlytical',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                            'There\'s so much to explore.\nlet\'s get started.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            )),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 10,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Image.asset(
                          'assets/images/bg.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 10,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.blockSizeVertical * 6,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.grey,
                                onSurface: Colors.transparent,
                                shape: new RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 1),
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/brands-and-logotypes.png',
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                  Text(
                                    "Continue with Google",
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('',
                                      style: TextStyle(
                                        color: Colors.transparent,
                                      )),
                                ],
                              ),
                              onPressed: () {
                                _signInWithGoogle();
                              },
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.blockSizeVertical * 6,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF3b5998),
                                onPrimary: Colors.grey,
                                onSurface: Colors.transparent,
                                shape: new RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.black, width: 0),
                                    borderRadius:
                                        new BorderRadius.circular(5.0)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/facebook.png',
                                    height: 20.0,
                                    width: 20.0,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 0.0),
                                      child: new Text(
                                        "Continue with facebook",
                                        style: TextStyle(
                                            fontSize: 15.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  new Text('',
                                      style: TextStyle(
                                        color: Colors.transparent,
                                      )),
                                ],
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                loginWithFacebook(context).whenComplete(() {
                                  setState(() {
                                    isLoading = false;
                                  });
                                });
                              },
                            )),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                      Container(
                        width: SizeConfig.screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                    height: SizeConfig.blockSizeVertical * 5,
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.grey,
                                        onSurface: Colors.transparent,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: borderRadius,
                                        // ),
                                      ),
                                      child: Text(
                                        'Log in',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login()),
                                        );
                                      },
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                    height: SizeConfig.blockSizeVertical * 5,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xFF0096EC),
                                        onPrimary: Colors.grey,
                                        onSurface: Colors.transparent,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: borderRadius,
                                        // ),
                                      ),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()),
                                        );
                                      },
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        isLoading == true ? load() : Container()
      ],
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential;

      if (kIsWeb) {
        var googleProvider = GoogleAuthProvider();
        userCredential = await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final googleAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        userCredential = await _auth.signInWithCredential(googleAuthCredential);
      }

      final user = userCredential.user;
      if (user.uid != null) {
        _userDataPost(
            context, user.uid, user.email, user.displayName, user.photoURL);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      Toast.show("Failed to sign in with Google: $e", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  _userDataPost(BuildContext context, userId, email, name, imageUrl) async {
    FirebaseMessaging.instance.getToken().then((token) async {
      LoginModel socialModel;

      var uri = Uri.parse('${baseUrl()}/social_login');
      var request = new http.MultipartRequest("Post", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields.addAll({
        'username': name.toString(),
        'email': email.toString(),
        'login_type': 'google',
        'facebook_id': userId.toString(),
        'image_url': imageUrl.toString(),
        "device_token": token
      });
      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      socialModel = LoginModel.fromJson(userData);

      if (socialModel.responseCode == "1") {
        String userResponseStr = json.encode(userData);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => TabbarScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        Flushbar(
          title: "Failure",
          message: "Google login fail!",
          duration: Duration(seconds: 3),
          icon: Icon(
            Icons.error,
            color: Colors.red,
          ),
        )..show(context);
      }
      print(responseData);
    });
  }
}
