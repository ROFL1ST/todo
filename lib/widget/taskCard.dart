// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';

import 'package:alert/alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/api/notification_api.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/widget/EditPop.dart';
import 'package:to_do/widget/customCheckBox.dart';
import 'package:to_do/widget/detailCard.dart';

import '../Screens/components/hero_dialogue_route.dart';
import '_AddTodoPopupCard.dart';

class TaskCard extends StatefulWidget {
  late String colorKondisi;
  final todoS;

  TaskCard({required this.colorKondisi, required this.todoS});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool isChecked;
  var duration = const Duration(seconds: 1);
  String? dateTime;
  // late String finaluser;
  @override
  void initState() {
    // TODO: implement initState

    getTime();

    NotificationApi.init(initSchedule: true);
    super.initState();
  }

 

  final notification = FlutterLocalNotificationsPlugin();
  void getTime() async {
     final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedUser = sharedPreferences.getString('name');
    print(obtainedUser);
    if (widget.todoS.deadline != null) {
      DateFormat inputFormat = DateFormat('hh:mm:ss');
      DateTime input = inputFormat.parse(widget.todoS.deadline);
      String datee = DateFormat('hh a').format(input);
      setState(() {
        dateTime = datee;

        NotificationApi.showScheduledNotification(
            scheduleDate: input,
            title: widget.todoS.title,
            body:
                "Hey $obtainedUser 😀, you have ${widget.todoS.title} on $datee. Don't be late 😍");
      });
    } else {
      return null;
    }
  }

  void deleteData() {
    ApiService().deleteTodo(widget.todoS.id).then((value) {
      if (value != true) {
        Alert(message: "Berhasil Dihapus", shortDuration: true).show();
        notification.cancel(widget.todoS.id);
        // Navigator.pop(context);
      } else {
        Alert(message: "Gagal Ditambahkan", shortDuration: true).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(datee);
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Slidable(
          startActionPane: ActionPane(
            // A motion is a widget used to control how the pane animates.
            motion: const ScrollMotion(),

            // A pane can dismiss the Slidable.
            // dismissible: DismissiblePane(onDismissed: () {}),

            // All actions are defined in the children parameter.
            children: [
              // A SlidableAction can have an icon and/or a label.
              SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.of(context)
                      .push(HeroDialogRoute(builder: (context) {
                    return EditCardToDo(
                      colorKondisi: widget.colorKondisi,
                      data: widget.todoS,
                      dateTime: dateTime,
                    );
                  }));
                },
                backgroundColor: kBackgroundColor,
                // foregroundColor: Colors.white,
                foregroundColor: kPrimaryColor,
                icon: Icons.edit,
                label: "Edit",
              ),
            ],
          ),

          // The end action pane is the one at the right or the bottom side.
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  deleteData();
                },
                backgroundColor: kBackgroundColor,
                foregroundColor: Colors.redAccent,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
            dismissible: DismissiblePane(onDismissed: () {
              deleteData();
            }),
          ),
          key: UniqueKey(),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                return DetailCard(
                  todoS: widget.todoS,
                  colorKondisi: widget.colorKondisi,
                );
              }));
            },
            child: Container(
              margin: EdgeInsets.only(top: 15),
              width: constraints.maxWidth / 1 - 0,
              // height: constraints.maxHeight / 4 - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: (widget.colorKondisi != "urgent") ? normal : urgent,
              ),
              padding: EdgeInsets.only(top: 25, bottom: 25, left: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Custom_check(
                        widget: widget,
                        complete: widget.todoS.active,
                        idTodos: widget.todoS.id,
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      ),
                      Container(
                        width: size.width * 0.2,
                        child: AutoSizeText(
                          widget.todoS.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          presetFontSizes: [16, 14],
                          // stepGranularity: 10,
                          style: widget.todoS.active != "non-active"
                              ? kTitleTask
                              : TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: size.width * 0.17,
                  // ),
                  widget.todoS.deadline != null
                      ? Text(
                          dateTime ?? "",
                          style: kTimeTask,
                        )
                      : Text(""),
                  SizedBox(
                    width: size.width * 0.17,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
