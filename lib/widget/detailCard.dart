// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';

import 'package:alert/alert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/api/notification_api.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/widget/EditPop.dart';
import 'package:to_do/widget/customCheckBox.dart';

import '../Screens/components/hero_dialogue_route.dart';
import '_AddTodoPopupCard.dart';

const String _heroAddTodo = 'add-todo-hero';

class DetailCard extends StatefulWidget {
  late String colorKondisi;
  final todoS;

  DetailCard({required this.colorKondisi, required this.todoS});

  @override
  State<DetailCard> createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  late bool isChecked;
  var duration = const Duration(seconds: 1);
  String? dateTime;

  @override
  void initState() {
    // TODO: implement initState

    getTime();

    super.initState();
  }

  void getTime() {
    if (widget.todoS.deadline != null) {
      DateFormat inputFormat = DateFormat('hh:mm:ss');
      DateTime input = inputFormat.parse(widget.todoS.deadline);
      String datee = DateFormat('hh a').format(input);
      setState(() {
        dateTime = datee;
      });
    } else {
      return null;
    }
  }

  void deleteData() {
    ApiService().deleteTodo(widget.todoS.id).then((value) {
      if (value != true) {
        Alert(message: "Berhasil Dihapus", shortDuration: true).show();

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
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Hero(
              tag: _heroAddTodo,
              // createRectTween: (begin, end) {
              //   return CustomRectTween(begin: begin, end: end);
              // },
              child: Material(
                color: (widget.colorKondisi != "urgent") ? normal : urgent,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              Container(
                                width: size.width * 0.5,
                                child: AutoSizeText(
                                  widget.todoS.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  presetFontSizes: [17, 14],
                                  // stepGranularity: 10,
                                  style: widget.todoS.active != "non-active"
                                      ? kTitleTask
                                      : TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
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
                          //     SizedBox(
                          //   width: size.width * 0.17,
                          // ),
                        ],
                      )),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
