// To parse this JSON data, do
//
//     final taskApi = taskApiFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TaskApi taskApiFromJson(String str) => TaskApi.fromJson(json.decode(str));

String taskApiToJson(TaskApi data) => json.encode(data.toJson());

class TaskApi {
    TaskApi({
        required this.datas,
    });

    List<Data> datas;

    factory TaskApi.fromJson(Map<String, dynamic> json) => TaskApi(
        datas: List<Data>.from(json["datas"].map((x) => Data.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "datas": List<dynamic>.from(datas.map((x) => x.toJson())),
    };
}

class Data {
    Data({
        required this.id,
        required this.title,
        required this.percentage,
    });

    int id;
    String title;
    double percentage;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        percentage: json["percentage"] == null ? null : json["percentage"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "percentage": percentage == null ? null : percentage,
    };
}
