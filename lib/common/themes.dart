import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/common/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  String themeDatas = "light";

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    themeDatas = isOn ? "dark" : "light";
    await sharedPreferences.setString("themeDatas", themeDatas);
    // var themeDatas2 = sharedPreferences.getString("themeDatas");

    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  initialize() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var themeCurrent = sharedPreferences.getString("themeDatas");
    themeDatas = sharedPreferences.getString("themeDatas")!;
    print(themeDatas);
    themeMode = themeCurrent == "dark" ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: kBackgroundColorDark,
    fontFamily: "Poppins",
    colorScheme: const ColorScheme.dark(),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: kBackgroundColor,
    fontFamily: "Poppins",
    colorScheme: const ColorScheme.light(),
  );
}
