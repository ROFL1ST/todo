// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/Screens/components/Background.dart';
import 'package:to_do/Screens/components/Body.dart';
import 'package:to_do/common/constants.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Scaffold(body: Body(),);
  }
}
