// ignore_for_file: file_names, prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:to_do/api/firebase_services.dart';
import 'package:to_do/common/constants.dart';

import '../common/themes.dart';

class ProfilePicEdit extends StatefulWidget {
  final imageUrl;
  const ProfilePicEdit({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<ProfilePicEdit> createState() => _ProfilePicEditState();
}

class _ProfilePicEditState extends State<ProfilePicEdit> {
  @override
  void initState() {
    // TODO: implement initState

    // taskData = Stream.periodic(Duration(seconds: 3))
    //     .asyncMap((event) => ApiService().taskData(widget.id));

    // ambilData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.3,
      width: size.width * 0.3,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          widget.imageUrl != null || widget.imageUrl != ""
              ? CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(
                  widget.imageUrl,
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
