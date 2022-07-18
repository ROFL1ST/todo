import 'dart:developer';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:to_do/Screens/auth/login.dart';
// import 'package:to_do/Screens/Dashboard.dart';
import 'package:to_do/Screens/components/hero_dialogue_route.dart';
// import 'package:to_do/Screens/homeScreen.dart';
import 'package:to_do/Screens/profileScreen.dart';
// import 'package:to_do/Screens/splash_screen.dart';
import 'package:to_do/Screens/taskScreen.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/common/themes.dart';
import 'package:to_do/widget/DeleteTask.dart';
import 'package:to_do/widget/EditTask.dart';
import 'package:to_do/widget/add.dart';
import 'package:to_do/widget/_AddTodoPopupCard.dart';
import 'package:to_do/widget/loading.dart';

import '../data/model/taskApi.dart';

enum _Menuvalues { edit, delete }

class DashBoard extends StatefulWidget {
  final String id;
  final String name;
  const DashBoard({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late Stream taskData;
  int taskLength = 0;
  late SharedPreferences data;
  DateTime pre_backpress = DateTime.now();
  // String? value;
  // List<DataUser> user = [];
  List<Data> task = [];
  String? priority;
  String identity = "";

  void ambilData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedIdentity = sharedPreferences.getString('identity');
    if (obtainedIdentity != null) {
      identity = obtainedIdentity.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    // taskData = Stream.periodic(Duration(seconds: 3))
    //     .asyncMap((event) => ApiService().taskData(widget.id));
    taskData = Stream.periodic(Duration(seconds: 2))
        .asyncMap((event) => ApiService().taskData(widget.id));

    // ambilData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(taskLength);
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(
          context, widget.name, widget.id, taskLength, identity, themeData),
      body: WillPopScope(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Activity",
                    style: themeData == "DarkTheme"
                        ? kTitleTextstyleDark
                        : kTitleTextstyle),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 20, top: 20, right: 20, bottom: 40),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: themeData == "DarkTheme"
                            ? kBackgroundColorDark
                            : null),
                    child: StreamBuilder(
                      stream: taskData,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState !=
                            ConnectionState.active) {
                          return SizedBox(
                            height: size.height * 0.7,
                            width: size.width * 0.7,
                            child: Center(
                              child: Loading(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
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
                          );
                        } else {
                          if (snapshot.hasData) {
                            // print(snapshot.data.datas.length);

                            if (snapshot.data.datas.length != 0) {
                              taskLength = snapshot.data?.datas.length;
                              return _builder(snapshot.data, size, themeData);
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return AddCard(
                                      themeData: themeData,
                                      id: widget.id,
                                    );
                                  }));
                                },
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/icon/blank Dark.png",
                                        height: size.height * 0.35,
                                      ),
                                      Text(
                                        "No Activity",
                                        style: kTitleSubStyle,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            return Text("kosong");
                          }
                        }
                      },
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            //show snackbar
            final snack = SnackBar(
              content: Text('Press Back button again to Exit'),
              duration: Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snack);
            return false;
          } else {
            return true;
          }
        },
      ),
    );
  }

  Widget _card(data, themeData) {
    // RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                // Create the SelectionScreen in the next step.
                MaterialPageRoute(
                    builder: (context) => Task(
                          data: data,
                        )));
          },
          child: Card(
            shadowColor:
                themeData == "DarkTheme" ? kCardColorDark : Colors.white,
            color: themeData == "DarkTheme" ? kCardColorDark : Colors.white,
            child: Container(
              width: constraints.maxWidth / 2 - 1,
              height: size.height * 0.33,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: (data.title == "Personal")
                                        ? SvgPicture.asset(
                                            "assets/icon/bi_person-fill.svg",
                                            height: size.height * 0.04,
                                          )
                                        : (data.title == "Work")
                                            ? SvgPicture.asset(
                                                "assets/icon/ic_round-work.svg",
                                                height: size.height * 0.04,
                                              )
                                            : (data.title == "Family")
                                                ? SvgPicture.asset(
                                                    "assets/icon/bi_people-fill.svg",
                                                    height: size.height * 0.04,
                                                  )
                                                : (data.title == "Healthy")
                                                    ? SvgPicture.asset(
                                                        "assets/icon/material-symbols_gfit-health.svg",
                                                        height:
                                                            size.height * 0.04,
                                                      )
                                                    : SvgPicture.asset(
                                                        "assets/icon/another.svg",
                                                        height:
                                                            size.height * 0.04,
                                                      ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  Container(
                                    width: size.width * 0.2,
                                    child: AutoSizeText(
                                      data.title.toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: themeData == "DarkTheme"
                                              ? kTextColorDark
                                              : kTextColor,
                                          fontSize: size.width * 0.047,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        // Container(
                        //   width: size.width * 0.075,
                        // ),
                        PopupMenuButton<_Menuvalues>(
                          color: themeData == "DarkTheme"
                              ? kBackgroundColorDark
                              : Colors.white,
                          icon: const Icon(Icons.more_vert_rounded,
                              color: kPrimaryColorDark),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Edit"),
                                  Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                  )
                                ],
                              ),
                              value: _Menuvalues.edit,
                            ),
                            PopupMenuItem(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("delete"),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  )
                                ],
                              ),
                              value: _Menuvalues.delete,
                            )
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case _Menuvalues.edit:
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return EditTask(
                                    data: data,
                                  );
                                }));
                                break;
                              case _Menuvalues.delete:
                                Navigator.of(context)
                                    .push(HeroDialogRoute(builder: (context) {
                                  return DeleteTask(
                                    data: data,
                                  );
                                }));
                                break;
                              default:
                            }
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.037,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, left: 10),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      StepProgressIndicator(
                                        totalSteps: 100,
                                        currentStep: (data.percentage == null)
                                            ? 0
                                            : data.percentage.ceil(),
                                        size: size.height * 0.01,
                                        padding: 0,
                                        selectedColor: (data.title ==
                                                "Personal")
                                            ? kPerson
                                            : (data.title == "Work")
                                                ? kWork
                                                : (data.title == "Family")
                                                    ? kFamily
                                                    : (data.title == "Healthy")
                                                        ? kHealthy
                                                        : kOther,
                                        unselectedColor: kTextLightColor,
                                        roundedEdges: Radius.circular(10),
                                        direction: Axis.vertical,
                                        progressDirection: ui.TextDirection.rtl,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Text(
                                            "Progress",
                                            style: TextStyle(
                                                color: themeData == "DarkTheme"
                                                    ? kTextColorDark
                                                    : kTextColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.height * 0.025),
                                          ),
                                          data.percentage != null
                                              ? Text(
                                                  "${data.percentage.ceil()}%",
                                                  style: TextStyle(
                                                      color: (data.title ==
                                                              "Personal")
                                                          ? kPerson
                                                          : (data.title ==
                                                                  "Work")
                                                              ? kWork
                                                              : (data.title ==
                                                                      "Family")
                                                                  ? kFamily
                                                                  : (data.title ==
                                                                          "Healthy")
                                                                      ? kHealthy
                                                                      : kOther,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          size.height * 0.025),
                                                )
                                              : Text(
                                                  "0%",
                                                  style: TextStyle(
                                                    color: (data.title ==
                                                            "Personal")
                                                        ? kPerson
                                                        : (data.title == "Work")
                                                            ? kWork
                                                            : (data.title ==
                                                                    "Family")
                                                                ? kFamily
                                                                : (data.title ==
                                                                        "Healthy")
                                                                    ? kHealthy
                                                                    : kOther,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        size.height * 0.025,
                                                  ),
                                                )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: LineReportChart(),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _builder(TaskApi taskApi, Size size, themeData) {
    // print(taskApi);
    // taskApi.datas.map((e) => print(e.title)).toList();
    // return Container();
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: size.height * 0.02,
      crossAxisSpacing: size.width * 0.03,
      children: [
        AddAct(
          id: widget.id,
        ),
        ...taskApi.datas.map(
          (data) {
            return _card(data, themeData);
          },
        ).toList(),
      ],
    );
    // return SizedBox();
  }
}

AppBar buildAppBar(BuildContext context, String name, String id, int length,
    String identity, themeData) {
  var now = new DateTime.now();
  var formatter = new DateFormat.yMMMMd('en_US');
  String formattedDate = formatter.format(now);
  return AppBar(
    backgroundColor: themeData == "DarkTheme"
        ? kBackgroundColorDark
        : kPrimaryColor.withOpacity(.01),
    elevation: 0,
    title: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        text: TextSpan(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            TextSpan(
              text: "Hello, $name!\n",
              style: TextStyle(
                fontSize: 24,
                color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: formattedDate,
              style: TextStyle(color: kTextLightColor),
            ),
          ],
        ),
      ),
    ),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Profile(
                    id: id,
                    length: length,
                  );
                },
              ),
            );
          },
          icon: Icon(
            Icons.person,
            color: kTextMediumColor,
          ))
    ],
  );
}

  // void addDialogue(BuildContext context) =>
  //     showDialog(context: context, builder: (context) {
  //       return Dial
  //     });

