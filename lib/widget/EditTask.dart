// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/common/themes.dart';
import 'package:to_do/data/model/activityApi.dart';

const String _heroAddTodo = 'add-todo-hero';

class EditTask extends StatefulWidget {
  // final String id;
  final data;
  const EditTask({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  // TimeOfDay time = const TimeOfDay(hour: 14, minute: 12);
  bool loading = false;
  // late Future act;
  // final items = ["urgent", "medium", "Other"];
  TextEditingController title = TextEditingController();
  // TextEditingController deadline = TextEditingController();
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), updateTask);
    });
  }

  // int? idAct;
  void updateTask() {
    ApiService().perbaruiTask(title.text, widget.data.id).then((value) => {
          setState(() {
            loading = true;
          }),
          if (value == true)
            {
              setState(() {
                loading = false;
              }),
              Alert(message: "Berhasil Update", shortDuration: true).show(),
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
    title.text = widget.data.title;

    super.initState();
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
                    TextField(
                      controller: title,
                      style: TextStyle(
                        color: (widget.data.title == "Personal")
                            ? kPerson
                            : (widget.data.title == "Work")
                                ? kWork
                                : (widget.data.title == "Family")
                                    ? kFamily
                                    : (widget.data.title == "Healthy")
                                        ? kHealthy
                                        : kOther,
                      ),
                      decoration: InputDecoration(
                        hintText: 'New todo',
                        border: InputBorder.none,
                        hintStyle: kSubTextStyle,
                      ),
                      cursorColor: kLightSecondaryColor,
                    ),
                    Divider(
                      color: themeData == "DarkTheme"
                          ? kCardColorDark
                          : Colors.white,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () {
                        _onLoading();
                      },
                      child: Text(
                        loading ? "Loading..." : "Edit",
                        style: TextStyle(
                          color: (widget.data.title == "Personal")
                              ? kPerson
                              : (widget.data.title == "Work")
                                  ? kWork
                                  : (widget.data.title == "Family")
                                      ? kFamily
                                      : (widget.data.title == "Healthy")
                                          ? kHealthy
                                          : kOther,
                        ),
                      ),
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
