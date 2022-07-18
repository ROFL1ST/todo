import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Screens/Dashboard.dart';
// import 'package:to_do/Screens/homeScreen.dart';
import 'package:to_do/Screens/welcome.dart';

import 'package:to_do/common/constants.dart';

import '../common/themes.dart';
import 'auth/login.dart';

class SplashScreenView extends StatefulWidget {
  @override
  _SplashScreenView createState() => _SplashScreenView();
}

class _SplashScreenView extends State<SplashScreenView> {
  late bool finalusername;
  late bool masuk;
  late String finalId;
  late String finaluser;
  // late String finalHave;
  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return getValidationData().whenComplete(() async {
      Timer(duration, () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          if (masuk) {
            return !finalusername
                ? Login()
                : DashBoard(
                    id: finalId,
                    name: finaluser,
                  );
          } else {
            return Welcome();
          }
          // ignore: unnecessary_null_comparison
        }));
      });
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedusername = sharedPreferences.containsKey('username');
    var obtainedData = sharedPreferences.containsKey("Hai");
    var obtainedIdUser = sharedPreferences.getInt('id');
    var obtainedUser = sharedPreferences.getString('name');
    setState(() {
      finalusername = obtainedusername;
      masuk = obtainedData;
      finalId = obtainedIdUser.toString();
      finaluser = obtainedUser.toString();
    });
    print(finalusername);
  }

  void initState() {
    super.initState();
    startSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    return Scaffold(
      backgroundColor:
          themeData == "DarkTheme" ? kBackgroundColorDark : kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/image/MyTask.png",
                height: size.height * 0.37,
              ),
            ),
            SizedBox(height: size.height * 0.2),
          ],
        ),
      ),
    );
  }
}
