// To parse this JSON data, do
//
//     final todoApi = todoApiFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'package:meta/meta.dart';
import 'dart:convert';

TodoApi todoApiFromJson(String str) => TodoApi.fromJson(json.decode(str));

String todoApiToJson(TodoApi data) => json.encode(data.toJson());

class TodoApi {
  TodoApi({
    required this.data,
  });

  List<Datum> data;

  factory TodoApi.fromJson(Map<String, dynamic> json) => TodoApi(
      data: json["data"] != null
          ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)))
          : <Datum>[]);

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.active,
    required this.priority,
    required this.deadline,
    required this.reminder,
  });

  int id;
  String title;
  String active;
  String priority;
  String deadline;
  String reminder;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        active: json["active"],
        priority: json["priority"],
        deadline: json["deadline"],
        // ignore: prefer_if_null_operators
        reminder: json["reminder"] == null ? null : json["reminder"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "active": active,
        "priority": priority,
        "deadline": deadline,
        // ignore: prefer_if_null_operators
        "reminder": reminder == null ? null : reminder,
      };
}
