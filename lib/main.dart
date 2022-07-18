import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:to_do/Screens/homeScreen.dart';
import 'package:to_do/Screens/splash_screen.dart';
// import 'package:to_do/Screens/welcome.dart';
import 'package:to_do/common/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do/common/themes.dart';
// import 'Screens/taskScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider()..initialize(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyTask',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            home: SplashScreenView(),
          );
        },
      );
}
