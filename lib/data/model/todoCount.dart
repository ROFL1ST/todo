// To parse this JSON data, do
//
//     final taskCountApi = taskCountApiFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TaskCountApi taskCountApiFromJson(String str) => TaskCountApi.fromJson(json.decode(str));

String taskCountApiToJson(TaskCountApi data) => json.encode(data.toJson());

class TaskCountApi {
    TaskCountApi({
        required this.data,
    });

    List<Datum> data;

    factory TaskCountApi.fromJson(Map<String, dynamic> json) => TaskCountApi(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
    });

    int id;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}
