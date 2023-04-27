import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:nlytical/screens/model/signup_model.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class Item {
  const Item(
    this.name,
  );
  final String name;
}

class _SignUpState extends State<SignUp> {
  ProgressDialog pr;

  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String dropDownname;
  bool _obscureText = false;
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
            _signupForm(context),
          ],
        ),
      ),
    );
  }

  Widget _signupForm(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  children: <Widget>[
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text('User Name',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _userTextfield(context),
                    Container(height: 10.0),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text('Email ID',
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
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
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _passwordTextfield(context),
                    Container(height: 50.0),
                    _loginButton(context),
                    Container(height: 40.0),
                  ],
                ),
              ),
              _dontHaveAnAccount(context),
              Container(height: 50.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _unameController,
        maxLines: 1,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _passwordController,
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
        maxLines: 1,
        textInputAction: TextInputAction.next,
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
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return SizedBox(
      height: 55,
      width: MediaQuery.of(context).size.width - 105,
      child: CustomButtom(
        title: 'SIGNUP',
        color: Colors.white,
        onPressed: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => SignUp()),
          // );
          _signup(context);
          print('Button is pressed');
        },
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Login(),
                    ),
                  ),
            text: ' Sign in',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Color(0xFF1E3C72),
            ),
          ),
        ],
      ),
    );
  }

  // void _signup(BuildContext context) {
  //   closeKeyboard();

  //   pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
  //   pr.style(message: 'Showing some progress...');
  //   pr.style(
  //     message: 'Please wait...',
  //     borderRadius: 10.0,
  //     backgroundColor: Colors.white,
  //     progressWidget: Container(
  //       height: 10,
  //       width: 10,
  //       margin: EdgeInsets.all(5),
  //       child: CircularProgressIndicator(
  //         strokeWidth: 2.0,
  //         valueColor: AlwaysStoppedAnimation(Colors.blue),
  //       ),
  //     ),
  //     elevation: 10.0,
  //     insetAnimCurve: Curves.easeInOut,
  //     progressTextStyle: TextStyle(
  //         color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
  //     messageTextStyle: TextStyle(
  //         color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
  //   );

  //   if (_unameController.text.isNotEmpty &&
  //       _passwordController.text.isNotEmpty &&
  //       _emailController.text.isNotEmpty) {
  //     Pattern pattern =
  //         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //     RegExp regex = new RegExp(pattern);
  //     if (regex.hasMatch(_emailController.text.trim()) &&
  //         _passwordController.text.length > 4) {
  //       pr.show();
  //       // Loader().showIndicator(context);

  //       signupBloc
  //           .signupSink(
  //         _emailController.text,
  //         _passwordController.text,
  //         _unameController.text,
  //       )
  //           .then(
  //         (userResponse) {
  //           if (userResponse.responseCode == Strings.responseSuccess) {
  //             pr.hide();
  //             Toast.show("USER REGISTER SUCCESSFULLY", context,
  //                 backgroundColor: Colors.white,
  //                 textColor: Colors.black,
  //                 duration: Toast.LENGTH_LONG,
  //                 gravity: Toast.BOTTOM);
  //             signupBloc.dispose();
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => Login()),
  //             );
  //           } else if (userResponse.responseCode == '0') {
  //             pr.hide();
  //             loginerrorDialog(context, "Email id already registered");
  //           } else {
  //             pr.hide();
  //             loginerrorDialog(
  //                 context, "Make sure you have entered right credential");
  //           }
  //         },
  //       );
  //     } else {
  //       loginerrorDialog(
  //           context, "Make sure you have entered right credential");
  //     }
  //   } else {
  //     loginerrorDialog(context, "Please enter valid credential to sign up");
  //   }
  // }

  Future<void> _signup(BuildContext context) async {
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
    SignupModel model;
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _unameController.text.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (regex.hasMatch(_emailController.text.trim()) &&
          _passwordController.text.length > 4) {
        pr.show();
        var uri = Uri.parse('${baseUrl()}/register');
        var request = new http.MultipartRequest("POST", uri);
        Map<String, String> headers = {
          "Accept": "application/json",
        };
        request.headers.addAll(headers);
        request.fields['email'] = _emailController.text.trim();
        request.fields['password'] = _passwordController.text;
        request.fields['username'] = _unameController.text;
        var response = await request.send();
        print(response.statusCode);
        String responseData =
            await response.stream.transform(utf8.decoder).join();
        var userData = json.decode(responseData);
        model = SignupModel.fromJson(userData);

        if (model.responseCode == '1') {
          pr.hide();
          loginerrorDialog(context, model.message.toString());
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Login(),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          pr.hide();
          loginerrorDialog(context, model.message.toString());
        }

        print(responseData);
      } else {
        loginerrorDialog(
            context, "Make sure you have entered right credential");
      }
    } else {
      loginerrorDialog(context, "Please enter your credential to login");
    }
  }
}
