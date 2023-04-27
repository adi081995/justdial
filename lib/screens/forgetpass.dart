import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/constant/global.dart';
import 'package:nlytical/constant/sizeconfig.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'login.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  ProgressDialog pr;
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
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
        left: 20.0,
        right: 20.0,
      ),
      child: Center(
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
                      // width: SizeConfig.blockSizeHorizontal * 50,
                    ),
                  ],
                ),
                Container(height: 50.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 150),
                  child: Container(
                    // color: Colors.red,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Text('Email ID',
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

                        Container(height: 20.0),
                        _loginButton(context),
                        Container(height: 40.0),
                        _dontHaveAnAccount(context),
                        // _facebookButton(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _appIcon() {
    return Image.asset(
      'assets/images/greenlogo.png',
      height: 110,
      width: 200,
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
        title: 'SUBMIT',
        color: Colors.white,
        onPressed: () async {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // Loader().showIndicator(context);
          Pattern pattern =
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
          RegExp regex = new RegExp(pattern);
          if (regex.hasMatch(_emailController.text)) {
            try {
              final response = await client
                  .post(Uri.parse('${baseUrl()}forgot_pass'), body: {
                "email": _emailController.text,
              });

              if (response.statusCode == 200) {
                Map<String, dynamic> dic = json.decode(response.body);
                if (dic['status'] == 1) {
                  errorDialog(
                      context, "Please check your e-mail to login again");
                  Navigator.of(context).pop(Login);
                } else {
                  forgoterrorDialog(context, "Enter valid E-mail");
                }
              } else {
                forgoterrorDialog(context, "Some error occurs");
              }
            } on Exception {
              forgoterrorDialog(
                  context, "Email incorrect or No Internet connection");

              throw Exception('Email incorrect or No Internet connection');
            }
          } else {
            forgoterrorDialog(context, "Enter valid E-mail");
          }
        },
      ),
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "BACK TO ",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
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
            text: '  SIGN IN PAGE',
            style: TextStyle(
              color: Color(0xFF1E3C72),
            ),
          ),
        ],
      ),
    );
  }
}
