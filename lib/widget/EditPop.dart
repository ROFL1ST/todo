// ignore_for_file: prefer_const_constructors, annotate_overrides, sized_box_for_whitespace

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/data/model/activityApi.dart';

const String _heroAddTodo = 'add-todo-hero';

class EditCardToDo extends StatefulWidget {
  // final String id;
  final colorKondisi;
  final data;
  final dateTime;
  const EditCardToDo({
    Key? key,
    required this.colorKondisi,
    required this.data,
    required this.dateTime,
  }) : super(key: key);

  @override
  State<EditCardToDo> createState() => _EditCardToDoState();
}

class _EditCardToDoState extends State<EditCardToDo> {
  TimeOfDay time = const TimeOfDay(hour: 14, minute: 12);
  bool loading = false;
  late Future act;
  // final items = ["urgent", "medium", "Other"];
  TextEditingController title = TextEditingController();
  TextEditingController deadline = TextEditingController();

  int? idAct;

   void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), updateTodo);
    });
  }
  void updateTodo() {
    ApiService()
        .perbaruiToDo(title.text, time.format(context), widget.data.id)
        .then((value) => {
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
    DateFormat inputFormat = DateFormat('hh a');
    DateTime input = inputFormat.parse(widget.dateTime);
    DateFormat("HH:mm").format(input);
    time = TimeOfDay.fromDateTime(input);
    // TODO: implement initState
    // act = ApiService().activityData();4
    print(input);
    title.text = widget.data.title;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.data.id);
    // print(valueTask);
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
            color: (widget.colorKondisi != "urgent") ? normal : urgent,
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
                      decoration: InputDecoration(
                        hintText: 'New todo',
                        border: InputBorder.none,
                        hintStyle: kTitleTask,
                      ),
                      cursorColor: Colors.white,
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    LayoutBuilder(
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
                            width: constraints.maxWidth / 2 - 60,
                            height: size.height * 0.06,
                            child: Center(
                              child: Text(
                                '${time.hour.toString()}:${time.minute.toString()}',
                                style: TextStyle(
                                    color: kTextColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    FlatButton(
                      onPressed: () {
                        _onLoading();
                      },
                      child: Text(loading ? "Loading..." : "Edit"),
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
