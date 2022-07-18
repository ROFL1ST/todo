// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:developer';

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/Screens/Dashboard.dart';
import 'package:to_do/Screens/auth/register.dart';
import 'package:to_do/Screens/components/RoundedButton.dart';
// import 'package:to_do/Screens/homeScreen.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/widget/loading.dart';
import '../../../api/api_service.dart';
import '../../../common/themes.dart';
import '../components/Background.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? _password;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  bool hidePassword = true;
  late String finalId;
  late String finaluser;
  String finalFail = "";
  void saveData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('username', username.text);
    var obtainedUser = sharedPreferences.getString('name');
    var obtainedIdUser = sharedPreferences.getInt('id');

    setState(() {
      finalId = obtainedIdUser.toString();
      finaluser = obtainedUser.toString();
    });
  }

  void loginData() async {
    ApiService().logUser(username.text, password.text).then((value) {
      if (mounted) {
        setState(() {
          if (value == true) {
            setState(() {
              loading = false;
            });
            Alert(message: "Berhasil Login", shortDuration: true).show();

            saveData();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return DashBoard(
                id: finalId,
                name: finaluser,
              );
            }));
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      }
    });
  }

  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 3), loginData);
    });
  }

  @override
  Widget build(BuildContext context) {
    // log(finalFail);
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : Background(
            themeData: themeData,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: themeData == "DarkTheme"
                        ? kTitleTextstyleDark
                        : kTitleTextstyle,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Image.asset(
                    "assets/image/loginpng@3x Dark.png",
                    height: size.height * 0.35,
                  ),
                  SizedBox(
                    height: size.height * 0.03,
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
                                icon: Icon(Icons.visibility_off))
                            : IconButton(
                                onPressed: _togglePassword,
                                icon: Icon(Icons.visibility)),
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
                    text: "Login",
                    press: () {
                      _onLoading();
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
                            return Register();
                          },
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account ? ",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
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
    print(hidePassword);
    setState(() {
      hidePassword = !hidePassword;
    });
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final themeData;
  const TextFieldContainer({
    Key? key,
    required this.child,
    required this.themeData,
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
