import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nlytical/constant/constant.dart';
import 'package:nlytical/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  SharedPreferences.getInstance().then(
    (prefs) async {
      runApp(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Nlytical",
          theme: new ThemeData(
              accentColor: Colors.black,
              primaryColor: Colors.black,
              primaryColorDark: Colors.black),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            App_Screen: (BuildContext context) => App(prefs),
          },
        ),
      );
    },
  );
}
