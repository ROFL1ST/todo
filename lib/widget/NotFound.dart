// import 'package:covid_20/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do/common/constants.dart';

class NotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    "assets/icon/error.png",
                    height: size.height * 0.5,
                  ),
                  Text(
                    "No Connection",
                    style: kTitleSubStyle,
                  )
                ],
              ),
            ),
            SizedBox(height: size.height * 0.2),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: kPrimaryColor.withOpacity(.01),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kTextColor,
          ),
        ),
      ),
    );
  }
}
