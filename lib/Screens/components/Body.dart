// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/Screens/auth/login.dart';

import 'package:to_do/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/themes.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late SharedPreferences data;
  void getData() async {
    data = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
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
            SizedBox(height: size.height * 0.25),
            InkWell(
              onTap: () {},
              child: Container(
                // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                // width: size.width * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(59),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                    color: kPrimaryColor,
                    onPressed: () {
                      data.setString("Hai", "okeh");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Login();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
