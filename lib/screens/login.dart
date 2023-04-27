import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/login_modal.dart';
import 'package:nlytical/screens/forgetpass.dart';
import 'package:nlytical/screens/newTabbar.dart';
import 'package:nlytical/screens/signup.dart';
import 'package:nlytical/share_preference/preferencesKey.dart';
import 'package:location/location.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ProgressDialog pr;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;
  LocationData locationData;
  String _fcmtoken = "";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    _getToken();
    getCurrentLocation().then((_) async {
      setState(() {});
    });
  }

  _getToken() {
    firebaseMessaging.getToken().then((token) {
      setState(() {
        _fcmtoken = token;
      });
      print(_fcmtoken);
    });
  }

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
        if (prefs.containsKey('currentLat') &&
            prefs.containsKey('currentLon')) {
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
      ),
      child: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/nlytical_logo.png',
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Container(height: 30.0),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text('Email ID / USER NAME',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _emailTextfield(context),
                      Container(height: 10.0),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Text('Password',
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _passwordTextfield(context),
                      Container(height: 10.0),
                      _forgotPassword(),
                      Container(height: 50.0),
                      _loginButton(context),
                      Container(height: 40.0),
                    ],
                  ),
                ),
                _dontHaveAnAccount(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _emailController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        // hintText: 'EMAIL',
        // prefixIcon: Container(
        //   margin: EdgeInsets.all(10.0),
        //   child: Icon(
        //     Icons.person,
        //     color: Colors.white,
        //     size: 28.0,
        //   ),
        // ),
      ),
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _passwordController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
        obscureText: !_obscureText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        // hintText: 'PASSWORD',
        // prefixIcon: Container(
        //   margin: EdgeInsets.all(10.0),
        //   child: Icon(
        //     Icons.lock,
        //     color: Colors.white,
        //     size: 28.0,
        //   ),
        // ),
      ),
    );
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPass()),
            );
          },
          child: Text.rich(
            TextSpan(
              text: 'Forget Password?',
              style: TextStyle(
                letterSpacing: 1.0,
                fontSize: 15,
                color: Color(0xFF1E3C72),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 105,
      child: CustomButtom(
        title: 'SIGN IN',
        color: Colors.white,
        onPressed: () {
          _apiCall(context);
          print('Button is pressed');
        },
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "New Member? ",
        style: TextStyle(
          letterSpacing: 1.5,
          fontSize: 16,
          color: Colors.black,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  ),
            text: 'Sign Up',
            style: TextStyle(
              color: Color(0xFF1E3C72),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _apiCall(BuildContext context) async {
    closeKeyboard();

    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(message: 'Showing some progress...');
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.all(5),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
    LoginModel model;
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      pr.show();
      var uri = Uri.parse('${baseUrl()}/login');
      var request = new http.MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
      };
      request.headers.addAll(headers);
      request.fields['email'] = _emailController.text.trim();
      request.fields['password'] = _passwordController.text;
      request.fields['device_token'] = _fcmtoken;
      var response = await request.send();
      print(response.statusCode);
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      var userData = json.decode(responseData);
      model = LoginModel.fromJson(userData);

      if (model.responseCode == '1') {
        String userResponseStr = json.encode(model);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString(
            SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);

        pr.hide();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => TabbarScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        pr.hide();
        loginerrorDialog(context, model.message.toString());
      }

      print(responseData);
    } else {
      loginerrorDialog(context, "Please enter your credential to login");
    }
  }
}
