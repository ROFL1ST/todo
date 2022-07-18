// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/activityApi.dart';

const String _heroAddTodo = 'add-todo-hero';

class AddCard extends StatefulWidget {
  final themeData;
  final String id;
  const AddCard({Key? key, required this.id, required this.themeData})
      : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  bool loading = false;
  final act = ["Personal", "Work", "Family", "Healthy", "Other"];
  // final items = ["urgent", "medium", "Other"];
  TextEditingController title = TextEditingController();
  TextEditingController deadline = TextEditingController();
  String? priority;
  String? value;
  String valueOther = "";
  int? idAct;
  String valueTask = "Personal";
  String valueEnd = "Personal";
  String finalFail = "";
  TextEditingController other = TextEditingController();
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 3), createTask);
    });
  }

  /// {@macro add_todo_popup_card}
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void Error() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedError = sharedPreferences.getString('failTask');
    if (obtainedError != null) {
      finalFail = obtainedError.toString();
    }
  }

  void createTask() {
    if (valueTask != "Other") {
      ApiService()
          .addTask(
        int.parse(widget.id),
        valueEnd,
      )
          .then((value) {
        setState(() {
          if (value == true) {
            setState(() {
              loading = false;
            });
            Alert(message: "Berhasil Ditambahkan", shortDuration: true).show();

            Navigator.pop(context);
          } else {
            Error();
            Alert(
                    message: "Task Sudah Ada di Database kami",
                    shortDuration: true)
                .show();
            setState(() {
              loading = false;
            });
          }
        });
      });
    } else {
      if (other.text == "") {
        Alert(message: "Masukkan Nama nya dongggg", shortDuration: true).show();
      } else {
        ApiService()
            .addTask(
          int.parse(widget.id),
          other.text,
        )
            .then((value) {
          setState(() {
            if (value == true) {
              setState(() {
                loading = false;
              });
              Alert(message: "Berhasil Ditambahkan", shortDuration: true)
                  .show();

              Navigator.pop(context);
            } else {
              Alert(
                      message: "Task Sudah Ada di Database kami",
                      shortDuration: true)
                  .show();
              setState(() {
                loading = false;
              });
            }
          });
        });
      }
    }
    // print(other);
  }

  @override
  Widget build(BuildContext context) {
    print(valueTask);
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
            color: widget.themeData == "DarkTheme"
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Activity",
                            style: widget.themeData == "DarkTheme"
                                ? kTextAppBarDark
                                : kTextAppBar,
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: widget.themeData == "DarkTheme"
                          ? kCardColorDark
                          : Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(20),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            width: constraints.maxWidth / 1 - 0,
                            height: size.height * 0.07,
                            decoration: BoxDecoration(

                                // color: Colors.white,
                                ),
                            child: DropdownButtonHideUnderline(
                                child: _builderAdd(act)),
                          );
                        },
                      ),
                    ),
                    Divider(
                      color: widget.themeData == "DarkTheme"
                          ? kCardColorDark
                          : Colors.white,
                      thickness: 0.2,
                    ),
                    (valueTask != "Other")
                        ? SizedBox()
                        : Container(
                            // height: size.height * 0.06,
                            child: TextField(
                              controller: other,
                              cursorColor: kTextColor,
                              decoration: InputDecoration(
                                hintText: "New Activity",
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: widget.themeData == "DarkTheme"
                                          ? kCardColorDark
                                          : kInactiveChartColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: widget.themeData == "DarkTheme"
                                        ? kCardColorDark
                                        : kInactiveChartColor,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: kTextLightColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: size.height * 0.015,
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Gk Jadi deh",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: size.height * 0.018),
                          ),
                        ),
                        FlatButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            onPressed: () {
                              _onLoading();
                            },
                            child: Text(loading ? "Loading..." : "Submit")),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _builderAdd(act) {
    Size size = MediaQuery.of(context).size;
    print(valueTask);
    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(15),
      dropdownColor:
          widget.themeData == "DarkTheme" ? kBackgroundColorDark : Colors.white,
      // elevation: 4,
      hint: (valueTask == "Personal")
          ? Row(
              children: [
                SvgPicture.asset(
                  "assets/icon/bi_person-fill.svg",
                  height: size.height * 0.02,
                ),
                SizedBox(
                  width: size.width * 0.02,
                ),
                Text(
                  "Personal",
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          : (valueTask == "Work")
              ? Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icon/ic_round-work.svg",
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      "Work",
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : (valueTask == "Family")
                  ? Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icon/bi_people-fill.svg",
                          height: size.height * 0.02,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Text(
                          "Family",
                          style: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : (valueTask == "Healthy")
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icon/material-symbols_gfit-health.svg",
                              height: size.height * 0.02,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              "Healthy",
                              style: TextStyle(
                                color: Theme.of(context).iconTheme.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : (valueTask == "Other")
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icon/another.svg",
                                  height: size.height * 0.02,
                                ),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                Text(
                                  "Other",
                                  style: TextStyle(
                                    color: Theme.of(context).iconTheme.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Text(""),
      value: value,
      iconSize: size.width * 0.06,
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).iconTheme.color,
      ),
      isExpanded: true,
      items: act.map<DropdownMenuItem<String>>(buildMenuItem).toList(),

      onChanged: (String? values) => setState(
        () {
          if (values != "Other") {
            valueTask = values!;
            valueEnd = values;
          } else {
            valueTask = values!;
            valueEnd = other.text;
          }
          // priority = value;
        },
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            Text(
              item,
              style: TextStyle(
                color: Theme.of(context).iconTheme.color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}
