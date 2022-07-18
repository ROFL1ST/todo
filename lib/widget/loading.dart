// import 'package:covid_20/common/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:to_do/common/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots(
        color: kPrimaryColor,
        size: 50.0,
      ),
    );
  }
}
