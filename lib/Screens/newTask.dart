// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';

import '../common/themes.dart';

class NewTask extends StatefulWidget {
  final id_task;

  const NewTask({Key? key, required this.id_task}) : super(key: key);
  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  TimeOfDay time = const TimeOfDay(hour: 14, minute: 12);
  final items = ["urgent", "medium"];
  TextEditingController title = TextEditingController();
  TextEditingController deadline = TextEditingController();
  String priority = "medium";
  bool loading = false;
  String? value;
  String timeValue = "";
  String? dateTime;
  // String valueTodo = "medium";
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration.zero, () {
      // getTime();
    });

    // NotificationApi.init(initSchedule: true);
    super.initState();
  }

  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), addTodo);
    });
  }

  void addTodo() {
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    if (title.text == "") {
      Alert(
        message: "Nama ToDo belum dimasukkan",
        shortDuration: true,
      ).show();
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      ApiService()
          .addTodo(widget.id_task, title.text, "active", priority.toString(),
              time.format(context))
          .then((value) {
        if (value == true) {
          if (mounted) {
            setState(() {
              loading = false;
            });
          }
          Alert(message: "Berhasil Ditambahkan", shortDuration: true).show();

          Navigator.pop(context);
        } else {
          if (mounted) {
            setState(() {
              loading = false;
            });
          }
          Alert(message: "Gagal Ditambahkan", shortDuration: true).show();
        }
      });
    }
  }

  // void getTime() {

  // }

  @override
  Widget build(BuildContext context) {
    // final localizations = MaterialLocalizations.of(context);
    // final formattedTimeOfDay = localizations.formatTimeOfDay(time);
    // print(formattedTimeOfDay);
    // DateTime date = DateFormat.jm().parse(time.format(context).toString());
    // String output = DateFormat("HH:mm").format(date);
    // setState(() {
    //   dateTime = output;
    // });
    final themeData =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
            ? "DarkTheme"
            : "LightTheme";
    print(title);
    Size size = MediaQuery.of(context).size;
    // MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child,);
    return Scaffold(
      appBar: buildNewAppBar(context, _onLoading, loading, themeData),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "New Task",
                style: themeData == "DarkTheme" ? kTextAppBarDark : kTextAppBar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: themeData == "DarkTheme"
                        ? kCardColorDark
                        : kInactiveChartColor,
                    elevation: 4,
                    child: TextField(
                      controller: title,
                      cursorColor: kTextColor,
                      decoration: InputDecoration(
                        hintText: "New Task",
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeData == "DarkTheme"
                                  ? kCardColorDark
                                  : kInactiveChartColor,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: themeData == "DarkTheme"
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
                    height: size.height * 0.04,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    
                    spacing: size.width * 0.1,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deadline',
                            style: TextStyle(
                                color: themeData == "DarkTheme"
                                    ? kTextColorDark
                                    : kTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          SizedBox(height: size.height * 0.03,),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: themeData == "DarkTheme"
                                ? kCardColorDark
                                : kInactiveChartColor,
                            elevation: 4,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return GestureDetector(
                                  onTap: () async {
                                    TimeOfDay? newTime = await showTimePicker(
                                      context: context,
                                      initialTime: time,
                                    );
                                    if (newTime != null) {
                                      setState(() {
                                        time = newTime;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: constraints.maxWidth / 2 - 20,
                                    height: size.height * 0.06,
                                    child: Center(
                                      child: Text(
                                        '${time.hour.toString()}:${time.minute.toString()}',
                                        style: TextStyle(
                                            color: themeData == "DarkTheme"
                                                ? kTextColorDark
                                                : kTextColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Priority',
                            style: TextStyle(
                                color: themeData == "DarkTheme"
                                    ? kTextColorDark
                                    : kTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                            SizedBox(height: size.height * 0.03,),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            color: themeData == "DarkTheme"
                                ? kCardColorDark
                                : kInactiveChartColor,
                            elevation: 4,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  width: constraints.maxWidth / 2 - 20,
                                  height: size.height * 0.06,
                                  decoration: BoxDecoration(
                                      // color: Colors.white,
                                      ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: themeData == "DarkTheme"
                                          ? kBackgroundColorDark
                                          : Colors.white,
                                      // elevation: 4,
                                      hint: Text(
                                        "Priority",
                                        style: TextStyle(
                                            color: themeData == "DarkTheme"
                                                ? kTextColorDark
                                                : kTextColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      value: value,
                                      iconSize: size.width * 0.06,
                                      icon: Icon(
                                        Icons.arrow_drop_down,
                                        color: themeData == "DarkTheme"
                                            ? kTextColorDark
                                            : kTextColor,
                                      ),
                                      isExpanded: true,
                                      items: items.map(buildMenuItem).toList(),
                                      onChanged: (value) => setState(() {
                                        this.value = value;
                                        priority = value!;
                                      }),
                                    ),
                                  ));
                            }),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
            color: Theme.of(context).iconTheme.color,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

AppBar buildNewAppBar(
    BuildContext context, VoidCallback press, bool loading, themeData) {
  Size size = MediaQuery.of(context).size;
  return AppBar(
    backgroundColor:
        themeData == "DarkTheme" ? kBackgroundColorDark : kBackgroundColor,
    elevation: 0,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(
        Icons.close_rounded,
        color: themeData == "DarkTheme" ? kTextColorDark : kTextColor,
        size: size.width * 0.076,
      ),
    ),
    actions: [
      GestureDetector(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              loading ? "Loading..." : "Done",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
        ),
        onTap: press,
      )
    ],
  );
}
