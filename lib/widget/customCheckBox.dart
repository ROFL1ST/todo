// ignore_for_file: prefer_const_constructors

import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:to_do/api/api_service.dart';
import 'package:to_do/common/constants.dart';
import 'package:to_do/widget/taskCard.dart';

class Custom_check extends StatefulWidget {
  final complete;
  final idTodos;
  const Custom_check({
    Key? key,
    required this.widget,
    required this.complete,
    required this.idTodos,
  }) : super(key: key);

  final TaskCard widget;

  @override
  State<Custom_check> createState() => _Custom_checkState();
}

class _Custom_checkState extends State<Custom_check> {
  bool loading = false;
  late bool isChecked;
  late Future todoUpdate;
  late String check;
  void _onLoading() {
    setState(() {
      loading = true;
      new Future.delayed(new Duration(seconds: 1), updateCheck);
    });
  }

  @override
  void initState() {
    if (widget.complete != "active") {
      isChecked = true;
    } else {
      isChecked = false;
    }
    // TODO: implement initState
    // todoUpdate = ApiService().updateTodo(isChecked, id);

    super.initState();
  }

  void updateCheck() {
    ApiService().updateTodo(check, widget.idTodos).then((value) => {
          if (value == true)
            {
              Alert(message: "Berhasil Update", shortDuration: true).show(),
              if (mounted)
                {
                  setState(() {
                    loading = false;
                  }),
                },
            }
          else
            {
              Alert(message: "gagal update", shortDuration: true).show(),
              if (mounted)
                {
                  setState(() {
                    loading = false;
                  }),
                },
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return (!loading)
        ? GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
                if (isChecked) {
                  check = "non-active";
                } else {
                  check = "active";
                }
              });
              print(check);
              _onLoading();
            },
            child: AnimatedContainer(
              height: 28,
              width: 28,
              duration: Duration(microseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color:
                    (widget.widget.colorKondisi != "urgent") ? normal : urgent,
                border: Border.all(color: Colors.black),
              ),
              child: widget.complete != "active"
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                    )
                  : null,
            ),
          )
        : SizedBox(height: 20, width: 20, child: CircularProgressIndicator());
  }
}
