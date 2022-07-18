// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/activityApi.dart';

const String _heroAddTodo = 'add-todo-hero';

class AddCardTodo extends StatefulWidget {
  final String id;
  const AddCardTodo({Key? key, required this.id}) : super(key: key);

  @override
  State<AddCardTodo> createState() => _AddCardTodoState();
}

class _AddCardTodoState extends State<AddCardTodo> {
  late Future act;
  // final items = ["urgent", "medium", "Other"];
  TextEditingController title = TextEditingController();
  TextEditingController deadline = TextEditingController();
  String? priority;
  String? value;
  int? idAct;
  String valueTask = "Personal";

  /// {@macro add_todo_popup_card}
  void initState() {
    // TODO: implement initState
    act = ApiService().activityData();
    super.initState();
  }

  void createTask() {
    ApiService().addTask(
      int.parse(widget.id),
      valueTask,
    );
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
            color: Colors.white,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Activity",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Material(
                              elevation: 4,
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    width: constraints.maxWidth / 1 - 0,
                                    height: size.height * 0.05,
                                    decoration: BoxDecoration(
                                        // color: Colors.white,
                                        ),
                                    child: DropdownButtonHideUnderline(
                                      child: FutureBuilder(
                                        future: act,
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState !=
                                              ConnectionState.done) {
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text("terjadi kesalahn");
                                          } else {
                                            if (snapshot.hasData) {
                                              return _builderAdd(snapshot.data);
                                            } else {
                                              return Text("kosong");
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: size.width * 0.2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 20),
                                      color: kPrimaryColor,
                                      onPressed: () {
                                        createTask();
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
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

  Widget _builderAdd(ActivityApi activityApi) {
    Size size = MediaQuery.of(context).size;

    return DropdownButton<String>(
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
                    color: kTextColor,
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
                        color: kTextColor,
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
                            color: kTextColor,
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
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : Row(
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
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
      value: value,
      iconSize: size.width * 0.06,
      icon: Icon(
        Icons.arrow_drop_down,
        color: kTextColor,
      ),
      isExpanded: true,
      items: activityApi.data
          .map(
            (map) => DropdownMenuItem<String>(
              child: Text(map.name),
              value: map.name.toString(),
            ),
          )
          .toList(),
      onChanged: (String? values) => setState(
        () {
          valueTask = values!;
          // priority = value;
        },
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icon/bi_person-fill.svg",
              height: 2,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              item,
              style: TextStyle(
                color: kTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
}
