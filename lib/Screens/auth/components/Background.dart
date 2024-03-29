import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final themeData;
  const Background({
    Key? key,
    required this.child,
    required this.themeData,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/image/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          themeData == "DarkTheme"
              ? SizedBox()
              : Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/image/login_bottom.png",
                    width: size.width * 0.4,
                  ),
                ),
          child,
        ],
      ),
    );
  }
}
