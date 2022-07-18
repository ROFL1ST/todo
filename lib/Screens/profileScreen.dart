// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unnecessary_new

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pretty_gauge/pretty_gauge.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:to_do/Screens/Calculator/Cal.dart';
import 'package:to_do/Screens/components/ProfilePic.dart';
import 'package:to_do/common/themes.dart';
import 'package:to_do/widget/LogOut.dart';
// import 'package:to_do/Screens/kerjaan%20aurek/payment.dart';
import 'package:to_do/widget/editProfile.dart';
import 'package:to_do/Screens/taskScreen.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/userApi.dart';
import 'package:to_do/widget/loading.dart';
import 'package:to_do/widget/NotFound.dart';
import 'dart:ui' as ui;
import "dart:math";
import '../api/api_service.dart';
import '../common/Dark/change_theme_button.dart';
import '../widget/_AddTodoPopupCard.dart';
import 'auth/login.dart';
import 'components/hero_dialogue_route.dart';

class Profile extends StatefulWidget {
  final id;
  final length;
  const Profile({Key? key, required this.id, required this.length})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // late Future data;
  List<UserApi> user = [];
  String name = "";
  String identity = "";
  late Future taskData;
  late Future taskDone;
  late Stream userData;

  void saveData() async {
    userData = Stream.periodic(Duration(seconds: 2))
        .asyncMap((event) => ApiService().userData(widget.id));
  }

  @override
  void initState() {
    saveData();
    taskData = ApiService().taskData(widget.id);
    taskDone = ApiService().taskDone(widget.id);
    // ambilData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    // print(user);
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: userData,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Loading(),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return NotFound();
        } else {
          if (snapshot.hasData) {
            var data = snapshot.data.data[0];
            print(data.imageUrl);
            return Scaffold(
              appBar: buildAppBar(context, data, themeData),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(1.0),
                    child: Center(
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfilePic(
                            imageUrl: data.imageUrl,
                          ),
                          Column(
                            children: [
                              Text(
                                data.name,
                                style: TextStyle(
                                  fontSize: size.height * 0.028,
                                  color: themeData == "DarkTheme"
                                      ? kTextColorDark
                                      : kTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.003,
                              ),
                              Text(
                                data.identity ?? "",
                                style: TextStyle(
                                  color: themeData == "DarkTheme"
                                      ? kTextLightColorDark
                                      : kTextLightColor,
                                  fontSize: size.height * 0.0134,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.045,
                              ),
                              FutureBuilder(
                                  future: taskDone,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState !=
                                        ConnectionState.done) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Loading(),
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text("terjadi kesalahn");
                                    } else {
                                      if (snapshot.hasData) {
                                        // print(snapshot.data.datas.length);
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Text(
                                                  "Complete",
                                                  style: TextStyle(
                                                      color: themeData ==
                                                              "DarkTheme"
                                                          ? kTitleSubDark
                                                          : kTitleSub,
                                                      fontSize:
                                                          size.height * 0.02,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "${snapshot.data.datas.length}",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color:
                                                        themeData == "DarkTheme"
                                                            ? kTextColorDark
                                                            : kTextColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 25,
                                                vertical: 8,
                                              ),
                                              child: Container(
                                                height: 50,
                                                width: 3,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  color:
                                                      themeData == "DarkTheme"
                                                          ? kTitleSubDark
                                                          : kTitleSub,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                Text("Activity",
                                                    style: TextStyle(
                                                        color: kTitleSub,
                                                        fontSize:
                                                            size.height * 0.02,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  "${widget.length}",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    color:
                                                        themeData == "DarkTheme"
                                                            ? kTextColorDark
                                                            : kTitleSub,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Text("kosong");
                                      }
                                    }
                                  }),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Activity",
                                          style: TextStyle(
                                            color: themeData == "DarkTheme"
                                                ? kTextColorDark
                                                : kTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: size.height * 0.03,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.4,
                                    child: FutureBuilder(
                                      future: taskData,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Loading();
                                        } else if (snapshot.hasError) {
                                          return Text("terjadi kesalahn");
                                        } else {
                                          if (snapshot.hasData) {
                                            if (snapshot.data.datas.length !=
                                                0) {
                                              final _random = new Random();

                                              return GridView.builder(
                                                // scrollDirection: Axis.horizontal,
                                                itemCount: 2,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        mainAxisExtent:
                                                            size.height * 0.35,
                                                        mainAxisSpacing: 10),
                                                itemBuilder: (context, index) {
                                                  // var data = snapshot.data?.datas[index];
                                                  var element = snapshot
                                                          .data?.datas[
                                                      _random.nextInt(snapshot
                                                          .data?.datas.length)];
                                                  return _card(
                                                      element, themeData);
                                                },
                                              );
                                            } else {
                                              return SizedBox();
                                            }
                                          } else {
                                            return Text("");
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Text("kosong");
          }
        }
      },
    );
  }

  Widget _card(element, themeData) {
    // RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    print(element.title);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              // Create the SelectionScreen in the next step.
              MaterialPageRoute(
                  builder: (context) => Task(
                        data: element,
                      )));
        },
        child: Card(
          shadowColor: themeData == "DarkTheme" ? kCardColorDark : Colors.white,
          color: themeData == "DarkTheme" ? kCardColorDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    (element.title == "Personal")
                        ? SvgPicture.asset(
                            "assets/icon/bi_person-fill.svg",
                            height: size.height * 0.04,
                          )
                        : (element.title == "Work")
                            ? SvgPicture.asset(
                                "assets/icon/ic_round-work.svg",
                                height: size.height * 0.04,
                              )
                            : (element.title == "Family")
                                ? SvgPicture.asset(
                                    "assets/icon/bi_people-fill.svg",
                                    height: size.height * 0.04,
                                  )
                                : (element.title == "Healthy")
                                    ? SvgPicture.asset(
                                        "assets/icon/material-symbols_gfit-health.svg",
                                        height: size.height * 0.04,
                                      )
                                    : SvgPicture.asset(
                                        "assets/icon/another.svg",
                                        height: size.height * 0.04,
                                      ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.more_vert),
                    // )
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    element.title.toString(),
                    // maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: themeData == "DarkTheme"
                            ? kTextColorDark
                            : kTextColor,
                        fontSize: size.width * 0.047,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        StepProgressIndicator(
                          totalSteps: 100,
                          currentStep: (element.percentage == null)
                              ? 0
                              : element.percentage.ceil(),
                          size: size.height * 0.01,
                          padding: 0,
                          selectedColor: (element.title == "Personal")
                              ? kPerson
                              : (element.title == "Work")
                                  ? kWork
                                  : (element.title == "Family")
                                      ? kFamily
                                      : (element.title == "Healthy")
                                          ? kHealthy
                                          : kOther,
                          unselectedColor: kTextLightColor,
                          roundedEdges: Radius.circular(10),
                          direction: Axis.vertical,
                          progressDirection: ui.TextDirection.rtl,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                              element.percentage != null
                                  ? Text(
                                      "${element.percentage.ceil()}%",
                                      style: TextStyle(
                                          color: (element.title == "Personal")
                                              ? kPerson
                                              : (element.title == "Work")
                                                  ? kWork
                                                  : (element.title == "Family")
                                                      ? kFamily
                                                      : (element.title ==
                                                              "Healthy")
                                                          ? kHealthy
                                                          : kOther,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.025),
                                    )
                                  : Text(
                                      "0%",
                                      style: TextStyle(
                                        color: (element.title == "Personal")
                                            ? kPerson
                                            : (element.title == "Work")
                                                ? kWork
                                                : (element.title == "Family")
                                                    ? kFamily
                                                    : (element.title ==
                                                            "Healthy")
                                                        ? kHealthy
                                                        : kOther,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.025,
                                      ),
                                    )
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, data, themeData) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: kPrimaryColor.withOpacity(.01),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: RichText(
          text: TextSpan(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              TextSpan(
                text: "Profile",
                style: TextStyle(
                  fontSize: 24,
                  color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 10.0),
          child: IconButton(
              onPressed: () => _onButtonPressed(data, themeData, data.name),
              // {
              //   // Navigator.push(
              //   //   context,
              //   //   MaterialPageRoute(
              //   //     builder: (context) {
              //   //       return EditProfile();
              //   //     },
              //   //   ),
              //   // );
              //   // Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              //   //   return EditProfile(
              //   //     data: data,
              //   //   );
              //   // }));

              // },

              icon: Icon(
                Icons.menu,
                color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
              )),
        )
      ],
    );
  }

  void _onButtonPressed(data, themeData, name) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: themeData == "DarkTheme" ? kBackgroundColorDark : null,
        context: context,
        builder: (context) {
          return Container(
            // color: themeData == "DarkTheme" ? kBackgroundColorDark : null,
            height: 230,
            child: Container(
              child: _buildBottomNavigationMenu(data, themeData, name),
              decoration: BoxDecoration(
                color: themeData == "DarkTheme"
                    ? kBackgroundColorDark
                    : Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
              ),
            ),
          );
        });
  }

  Column _buildBottomNavigationMenu(data, themeData, name) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 15,
          ),
          child: Container(
            height: 6,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey,
            ),
          ),
        ),
        ListTile(
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return EditProfile(
                data: data,
                themeData: themeData,
              );
            }));
          },
          leading: Icon(
            Icons.edit,
            color: Colors.grey,
            size: 30,
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
            ),
          ),
        ),
        ListTile(
          onTap: () {},
          leading: Icon(
            themeData == "DarkTheme"
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            color: Colors.grey,
            size: 30,
          ),
          title: Text(
            'Dark Mode',
            style: TextStyle(
              color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
            ),
          ),
          trailing: ChangeThemeButtonWidget(),
        ),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            Navigator.of(context).push(HeroDialogRoute(builder: (context) {
              return LogOut(name: name);
            }));
          },
          leading: Icon(
            Icons.logout_rounded,
            color: Colors.grey,
            size: 30,
          ),
          title: Text(
            'Log Out',
            style: TextStyle(
              color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
