// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace, deprecated_member_use

import 'package:alert/alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/activityApi.dart';

import '../common/themes.dart';

const String _heroAddTodo = 'add-todo-hero';

class DeleteTask extends StatefulWidget {
  // final String id;
  final data;

  const DeleteTask({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<DeleteTask> createState() => _DeleteTaskState();
}

class _DeleteTaskState extends State<DeleteTask> {
  bool loading = false;
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), deleteData);
    });
  }

  void deleteData() {
    ApiService().deleteTask(widget.data.id).then((value) {
      if (value != true) {
        Alert(message: "Berhasil Dihapus", shortDuration: true).show();

        Navigator.pop(context);
      } else {
        Alert(message: "Gagal Ditambahkan", shortDuration: true).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
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
            color:
                themeData == "DarkTheme" ? kBackgroundColorDark : Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/icon/x.png",
                      height: size.height * 0.1,
                    ),
                    SizedBox(
                      height: size.height * 0.035,
                    ),
                    SizedBox(
                      width: size.width * 0.6,
                      child: AutoSizeText(
                        "Yakin mau di hapus ${widget.data.title} nya?",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: themeData == "DarkTheme"
                            ? kTitleActDark
                            : kTitleAct,
                      ),
                    ),
                       Divider(
                      color: themeData == "DarkTheme"
                          ? kCardColorDark
                          : Colors.grey,
                      thickness: 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Jangan',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            _onLoading();
                          },
                          child: Text(
                            loading ? "Loading..." : "Hapus",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
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
