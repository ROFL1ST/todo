// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors, sized_box_for_whitespace

import 'dart:async';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:to_do/Screens/components/hero_dialogue_route.dart';
import 'package:to_do/Screens/newTask.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/common/themes.dart';
import 'package:to_do/widget/_AddTodoPopupCard%20copy.dart';
import 'package:to_do/widget/taskCard.dart';

class Task extends StatefulWidget {
  final data;
  Task({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  late String kondisi = "urgent";
  late String complete;
  late Stream todoDataComplete;
  late Stream todoDataInComplete;
  late Stream todoCount;

  int todoLength = 0;
  int todoHasntLength = 0;
  int todoDonelength = 0;

  bool error = false;

  late double percentage = 0;

  void errorState() {
    setState(() {
      if (error == true) {
        Navigator.pop(context);
      } else {
        return;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    todoDataComplete = Stream.periodic(Duration(seconds: 5))
        .asyncMap((event) => ApiService().todoDataCompleted(widget.data.id));
    todoDataInComplete = Stream.periodic(Duration(seconds: 5))
        .asyncMap((event) => ApiService().todoDataInComplete(widget.data.id));

    todoCount = Stream.periodic(Duration(seconds: 1))
        .asyncMap((event) => ApiService().todoCount(widget.data.id));
    errorState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(todoCount);
    print(todoDonelength);
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    // log(todoLength.toString());
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              title: innerBoxIsScrolled == true
                  ? AutoSizeText(
                      "${widget.data.title}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.025,
                        color: themeData == "DarkTheme"
                            ? Colors.white
                            : Colors.black,
                      ),
                    )
                  : Text(""),
              backgroundColor: themeData == "DarkTheme"
                  ? kBackgroundColorDark
                  : kBackgroundColor,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
                ),
              ),
            )
          ],
          body: StreamBuilder(
            stream: todoCount,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                error = true;
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                );
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data.data.length != 0) {
                    double num2 = double.parse((percentage).toStringAsFixed(0));

                    percentage = (todoDonelength / todoLength * 100);
                    ApiService().updateTask(num2.toString(), widget.data.id);
                    // print(100 / todoLength * todoDonelength);
                    // print(snapshot.data.data.length);
                    todoLength = snapshot.data.data.length;
                    ApiService().updateTask(num2.toString(), widget.data.id);
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (widget.data.title == "Personal")
                                      ? SvgPicture.asset(
                                          "assets/icon/bi_person-fill.svg",
                                          height: size.height * 0.05,
                                        )
                                      : (widget.data.title == "Work")
                                          ? SvgPicture.asset(
                                              "assets/icon/ic_round-work.svg",
                                              height: size.height * 0.05,
                                            )
                                          : (widget.data.title == "Family")
                                              ? SvgPicture.asset(
                                                  "assets/icon/bi_people-fill.svg",
                                                  height: size.height * 0.05,
                                                )
                                              : (widget.data.title == "Healthy")
                                                  ? SvgPicture.asset(
                                                      "assets/icon/material-symbols_gfit-health.svg",
                                                      height:
                                                          size.height * 0.05,
                                                    )
                                                  : SvgPicture.asset(
                                                      "assets/icon/another.svg",
                                                      height:
                                                          size.height * 0.05,
                                                    ),
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        "${widget.data.title}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.025,
                                          color: themeData == "DarkTheme"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text("${todoLength.toString()} To Do",
                                          overflow: TextOverflow.ellipsis,
                                          style: kSubTextStyle)
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LinearPercentIndicator(
                                          width: size.width * 0.42,
                                          lineHeight: 9,
                                          // lineHeight: 10,
                                          percent: todoDonelength / todoLength,
                                          animation: true,
                                          animationDuration: 1500,
                                          backgroundColor:
                                              themeData == "DarkTheme"
                                                  ? kShadowColorDark
                                                  : kShadowColor,
                                          progressColor: (widget.data.title ==
                                                  "Personal")
                                              ? kPerson
                                              : (widget.data.title == "Work")
                                                  ? kWork
                                                  : (widget.data.title ==
                                                          "Family")
                                                      ? kFamily
                                                      : (widget.data.title ==
                                                              "Healthy")
                                                          ? kHealthy
                                                          : kOther,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "${double.parse((todoDonelength / todoLength * 100).toStringAsFixed(0)).ceil()}%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (widget.data.title ==
                                                      "Personal")
                                                  ? kPerson
                                                  : (widget.data.title ==
                                                          "Work")
                                                      ? kWork
                                                      : (widget.data.title ==
                                                              "Family")
                                                          ? kFamily
                                                          : (widget.data
                                                                      .title ==
                                                                  "Healthy")
                                                              ? kHealthy
                                                              : kOther,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 18, left: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return NewTask(
                                                    id_task: widget.data.id,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 60),
                              child: Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    // Incomplete
                                    Text(
                                      "Incomplete",
                                      style: kTitleSubStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: (todoHasntLength != 0)
                                            ? size.height *
                                                todoHasntLength /
                                                7.5
                                            : size.height * 0.26,
                                        // decoration: BoxDecoration(color: Colors.amber),
                                        child: StreamBuilder(
                                          stream: todoDataInComplete,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.active) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasError) {
                                              print(snapshot.error);
                                              return Text("terjadi kesalahn");
                                            } else {
                                              if (snapshot.hasData) {
                                                todoHasntLength =
                                                    snapshot.data.data.length;
                                                // print(snapshot.data.data.length);
                                                if (snapshot.data.data.length !=
                                                    0) {
                                                  return ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    // shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var todoS = snapshot
                                                          .data?.data[index];
                                                      // print(todoS.active);

                                                      return _builderHasnt(
                                                          todoS);
                                                    },
                                                    itemCount: snapshot
                                                        .data?.data.length,
                                                  );
                                                } else {
                                                  return Center(
                                                      child: Text(
                                                          "Yeay, you have done all of your task"));
                                                }
                                              } else {
                                                return Text("");
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                    ),
                                    // Complete
                                    Text(
                                      "Complete",
                                      style: kTitleSubStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: (todoDonelength != 0)
                                            ? size.height * todoDonelength / 7.5
                                            : size.height * 0.26,
                                        // decoration: BoxDecoration(color: Colors.amber),
                                        child: StreamBuilder(
                                          stream: todoDataComplete,
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.active) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasError) {
                                              print(snapshot.hasError);
                                              return Text("terjadi kesalahn");
                                            } else {
                                              if (snapshot.hasData) {
                                                todoDonelength =
                                                    snapshot.data.data.length;
                                                print(todoDonelength);
                                                if (snapshot.data.data.length !=
                                                    0) {
                                                  return ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var todoS = snapshot
                                                          .data?.data[index];

                                                      return _builderDone(
                                                          todoS);
                                                    },
                                                    itemCount: snapshot
                                                        .data?.data.length,
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                        "You haven't done anything"),
                                                  );
                                                }
                                              } else {
                                                return Text("kosong");
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: size.height * 0.055,
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) {
                            //           return NewTask();
                            //         },
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.only(
                            //       top: 20,
                            //       bottom: 20,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(8),
                            //       color: kPrimaryColor,
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         "Add Task",
                            //         style: kTitleTask,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  } else {
                    ApiService().updateTask("0", widget.data.id);
                    todoLength = snapshot.data.data.length;
                    return SingleChildScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (widget.data.title == "Personal")
                                      ? SvgPicture.asset(
                                          "assets/icon/bi_person-fill.svg",
                                          height: size.height * 0.05,
                                        )
                                      : (widget.data.title == "Work")
                                          ? SvgPicture.asset(
                                              "assets/icon/ic_round-work.svg",
                                              height: size.height * 0.05,
                                            )
                                          : (widget.data.title == "Family")
                                              ? SvgPicture.asset(
                                                  "assets/icon/bi_people-fill.svg",
                                                  height: size.height * 0.05,
                                                )
                                              : (widget.data.title == "Healthy")
                                                  ? SvgPicture.asset(
                                                      "assets/icon/material-symbols_gfit-health.svg",
                                                      height:
                                                          size.height * 0.05,
                                                    )
                                                  : SvgPicture.asset(
                                                      "assets/icon/another.svg",
                                                      height:
                                                          size.height * 0.05,
                                                    ),
                                  SizedBox(
                                    width: size.width * 0.02,
                                  ),
                                  Flexible(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        "${widget.data.title}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.025,
                                          color: themeData == "DarkTheme"
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      Text("${todoLength.toString()} To Do",
                                          overflow: TextOverflow.ellipsis,
                                          style: kSubTextStyle)
                                    ],
                                  )),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LinearPercentIndicator(
                                          width: size.width * 0.40,
                                          lineHeight: 9,
                                          // lineHeight: 10,
                                          percent: 0,
                                          animation: true,
                                          animationDuration: 1500,
                                          backgroundColor: kShadowColor,
                                          progressColor: (widget.data.title ==
                                                  "Personal")
                                              ? kPerson
                                              : (widget.data.title == "Work")
                                                  ? kWork
                                                  : (widget.data.title ==
                                                          "Family")
                                                      ? kFamily
                                                      : (widget.data.title ==
                                                              "Healthy")
                                                          ? kHealthy
                                                          : kOther,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "0%",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: (widget.data.title ==
                                                      "Personal")
                                                  ? kPerson
                                                  : (widget.data.title ==
                                                          "Work")
                                                      ? kWork
                                                      : (widget.data.title ==
                                                              "Family")
                                                          ? kFamily
                                                          : (widget.data
                                                                      .title ==
                                                                  "Healthy")
                                                              ? kHealthy
                                                              : kOther,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 18, left: 0),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return NewTask(
                                                    id_task: widget.data.id,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/icon/blank.png",
                                      height: size.height * 0.35,
                                    ),
                                    Text(
                                      "No Activity",
                                      style: kTitleSubStyle,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: size.height * 0.055,
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) {
                            //           return NewTask();
                            //         },
                            //       ),
                            //     );
                            //   },
                            //   child: Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.only(
                            //       top: 20,
                            //       bottom: 20,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(8),
                            //       color: kPrimaryColor,
                            //     ),
                            //     child: Center(
                            //       child: Text(
                            //         "Add Task",
                            //         style: kTitleTask,
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Text("data");
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _builderHasnt(todoS) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: TaskCard(
        colorKondisi: todoS!.priority,
        todoS: todoS,
      ),
    );
  }

  Widget _builderDone(todoS) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: TaskCard(
        colorKondisi: todoS!.priority,
        todoS: todoS,
      ),
    );
  }

  AppBar buildTaskAppBar(BuildContext context, themeData) {
    return AppBar(
      backgroundColor:
          themeData == "DarkTheme" ? kBackgroundColorDark : kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
        ),
      ),
    );
  }
}
