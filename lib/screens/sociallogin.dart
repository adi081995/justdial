import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'login.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ProgressDialog pr;

  @override
  Widget build(BuildContext context) {
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/back3.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/images/greenlogo.png')),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                       // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(10.0))),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/fblogo.png',
                              height: 40.0,
                              width: 40.0,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: new Text(
                                "CONTINUE WITH FACEBOOK",
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Color(0xFF2550AC),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                       // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          //      pr.show();
                          //   signInWithGoogle().whenComplete(() async {
                          //         Navigator.of(context).pushAndRemoveUntil(
                          //           MaterialPageRoute(
                          //             builder: (context) => HomeNew(),
                          //           ),
                          //           (Route<dynamic> route) => false,
                          //         );
                          //  pr.hide();
                          // });
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/googlelogo.png',
                              height: 30.0,
                              width: 30.0,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: new Text(
                                "CONTINUE WITH GOOGLE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Color(0xFFBF2B2B),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                       // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/phone.png',
                              height: 25.0,
                              width: 25.0,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: new Text(
                                "CONTINUE WITH EMAIL",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                                textAlign: TextAlign.start,
                              ),
                            )
                          ],
                        ),
                        textColor: Colors.white,
                        splashColor: Colors.red,
                        color: Color(0xFFBF2B2B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Show a simple "___ Button Pressed" indicator

/// Normally the signin buttons should be contained in the SignInPage
