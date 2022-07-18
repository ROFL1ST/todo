// To parse this JSON data, do
//
//     final userApi = userApiFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserApi userApiFromJson(String str) => UserApi.fromJson(json.decode(str));

String userApiToJson(UserApi data) => json.encode(data.toJson());

class UserApi {
    UserApi({
        required this.data,
    });

    List<Datum> data;

    factory UserApi.fromJson(Map<String, dynamic> json) => UserApi(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        required this.id,
        required this.username,
        required this.name,
        required this.identity,
        required this.imageUrl,
        required this.cal,
        required this.gender,
    });

    int id;
    String username;
    String name;
    String identity;
    dynamic imageUrl;
    String cal;
    String gender;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        identity: json["identity"],
        imageUrl: json["image_url"],
        cal: json["cal"],
        gender: json["gender"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "identity": identity,
        "image_url": imageUrl,
        "cal": cal,
        "gender": gender,
    };
}
