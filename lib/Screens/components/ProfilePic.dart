// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/common/constants.dart';

import '../../common/themes.dart';

class ProfilePic extends StatelessWidget {
  final imageUrl;
  const ProfilePic({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.24,
      width: size.width * 0.3,
      child: Stack(
        clipBehavior: Clip.none, fit: StackFit.expand,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          imageUrl != null
              ? CircleAvatar(
                  radius: 42,
                  backgroundImage: NetworkImage(
                    imageUrl,
                  ),
                )
              : CircleAvatar(
                  // backgroundColor: Theme.of(context).iconTheme.color,
                  radius: 42,
                  backgroundImage: AssetImage(
                    "assets/icon/man.png",
                  ),
                ),
        ],
      ),
    );
  }
}
