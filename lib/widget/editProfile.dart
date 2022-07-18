// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace

import 'dart:developer';
import 'dart:io';

import 'package:alert/alert.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/activityApi.dart';
import 'package:to_do/widget/ProfilePicedit.dart';
import 'package:to_do/widget/loading.dart';

const String _heroAddTodo = 'add-todo-hero';

class EditProfile extends StatefulWidget {
  final themeData;
  final data;

  const EditProfile({
    Key? key,
    required this.data, required this.themeData,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TimeOfDay time = const TimeOfDay(hour: 14, minute: 12);
  bool loading = false;
  bool loading2 = false;
  late Future act;
  // final items = ["urgent", "medium", "Other"];
  TextEditingController username = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController identity = TextEditingController();

  int? idAct;
  FirebaseStorage storage = FirebaseStorage.instance;
  String gambar = "";
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), UploadFile);
    });
  }

  void _onLoading2() {
    setState(() {
      loading2 = true;
      new Future.delayed(new Duration(seconds: 3), updateUser);
    });
  }

  void UploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      String nama = result.files.first.name;

      try {
        await storage.ref('profile/$nama').putFile(file);
        log("Berhasil upload");
        Alert(message: "Yey, Kepilih PP nya", shortDuration: true).show();
        // ignore: nullable_type_in_catch_clause
        var downloadURL = await storage.ref('profile/$nama').getDownloadURL();
        print(downloadURL);
        if (mounted) {
          setState(() {
            loading = false;
            gambar = "";
            gambar = downloadURL;
          });
        }
      } on FirebaseException catch (e) {
        // e.g, e.code == 'canceled'
        Alert(message: "Ada kesalahan", shortDuration: true).show();
        log(e.toString());
        if (mounted) {
          setState(() {
            loading = false;
          });
        }
      }
    } else {
      // User canceled the picker
      log("Tidak memilih file");
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      Alert(message: "Gak Jadi Milih FIle nih??", shortDuration: true).show();
    }
  }

  void updateUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    ApiService()
        .updateUser(
            username.text, name.text, identity.text, gambar, widget.data.id)
        .then((value) => {
              if (mounted)
                {
                  setState(() {
                    loading = true;
                  }),
                },
              if (value == true)
                {
                  setState(() {
                    loading = false;
                  }),
                  Alert(message: "Berhasil Update", shortDuration: true).show(),
                  sharedPreferences.setString("name", name.text),
                  sharedPreferences.setString("identity", identity.text),
                  Navigator.pop(context)
                }
              else
                {
                  setState(() {
                    loading = false;
                  }),
                  Alert(message: "gagal update", shortDuration: true).show()
                }
            });
  }

  /// {@macro add_todo_popup_card}
  void initState() {
    username.text = widget.data.username;
    name.text = widget.data.name;
    identity.text = widget.data.identity;
    gambar = widget.data.imageUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.id);
    // print(valueTask);
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: _heroAddTodo,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
            color:  widget.themeData == "DarkTheme"
                ? kBackgroundColorDark
                : Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    loading
                        ? Container(
                            height: size.height * 0.3,
                            width: size.width * 0.3,
                            child: Center(child: CircularProgressIndicator()))
                        : ProfilePicEdit(
                            imageUrl: gambar,
                          ),
                    GestureDetector(
                      onTap: () {
                        _onLoading();
                      },
                      child: Text(
                        "Change Photo Profile",
                        style: TextStyle(
                          // decoration: TextDecoration.underline,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    TextField(
                      controller: username,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: InputBorder.none,
                        hintStyle: kTitleSubStyle,
                      ),
                      cursorColor: Colors.grey,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    ),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        border: InputBorder.none,
                        hintStyle: kTitleSubStyle,
                      ),
                      cursorColor: Colors.grey,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    ),
                    TextField(
                      controller: identity,
                      decoration: InputDecoration(
                        hintText: 'Your Identity',
                        border: InputBorder.none,
                        hintStyle: kTitleSubStyle,
                      ),
                      cursorColor: Colors.grey,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () {
                        // updateTodo();
                        _onLoading2();
                      },
                      child: Text(loading2 ? "Loading..." : "Edit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
