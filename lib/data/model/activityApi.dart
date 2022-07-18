// To parse this JSON data, do
//
//     final activityApi = activityApiFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ActivityApi activityApiFromJson(String str) => ActivityApi.fromJson(json.decode(str));

String activityApiToJson(ActivityApi data) => json.encode(data.toJson());

class ActivityApi {
    ActivityApi({
        required this.data,
    });

    List<Datum> data;

    factory ActivityApi.fromJson(Map<String, dynamic> json) => ActivityApi(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.icon,
        required this.name,
        required this.color,
    });

    int id;
    String icon;
    String name;
    String color;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        icon: json["icon"],
        name: json["name"],
        color: json["color"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "name": name,
        "color": color,
    };
}
