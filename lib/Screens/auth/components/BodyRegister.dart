// ignore_for_file: prefer_const_constructors

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Screens/auth/login.dart';
import 'package:to_do/Screens/components/RoundedButton.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import '../../../common/themes.dart';
import '../components/BackgroundRegister.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // String? _password;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  bool loading = false;
  String finalFail = "";
  bool hidePassword = true;
  void saveData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('username', username.text);
  }

  void createData() {
    ApiService()
        .saveUser(name.text, username.text, password.text)
        .then((value) {
      print(name);
      setState(() {
        if (value == true) {
          Alert(message: "Berhasil Register", shortDuration: true).show();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return Login();
          }));
          saveData();
        } else {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
     final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return Background(
      themeData: themeData,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Register",
                style: themeData == "DarkTheme"
                        ? kTitleTextstyleDark
                        : kTitleTextstyle,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Image.asset(
              "assets/image/register@3x Dark.png",
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            TextFieldContainer(
              themeData: themeData,
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  hintText: "Name",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
                themeData: themeData,
              child: TextField(
                controller: username,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  hintText: "Username",
                  border: InputBorder.none,
                ),
              ),
            ),
            TextFieldContainer(
                themeData: themeData,
              child: TextField(
                controller: password,
                autocorrect: false,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  suffixIcon: hidePassword
                      ? IconButton(
                          onPressed: _togglePassword,
                          icon: Icon(Icons.visibility))
                      : IconButton(
                          onPressed: _togglePassword,
                          icon: Icon(Icons.visibility_off)),
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
              text: "Register",
              press: () {
                createData();
                print(name);
              },
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have An Account ? ",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  Text(
                    "Sign In",
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _togglePassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}

class TextFieldContainer extends StatelessWidget {
  final themeData;
  final Widget child;
  const TextFieldContainer({
    Key? key,
    required this.child,required this.themeData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: themeData == "DarkTheme" ? kCardColorDark : kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
