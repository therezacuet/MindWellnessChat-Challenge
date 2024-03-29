// To parse this JSON data, do
//
//     final userNameStatusUpdateModel = userNameStatusUpdateModelFromJson(jsonString);

import 'dart:convert';

UserNameStatusUpdateModel userNameStatusUpdateModelFromJson(String str) => UserNameStatusUpdateModel.fromJson(json.decode(str));

String userNameStatusUpdateModelToJson(UserNameStatusUpdateModel data) => json.encode(data.toJson());

class UserNameStatusUpdateModel {
  UserNameStatusUpdateModel({
    required this.id,
    required this.name,
    required this.statusLine,
  });

  String id;
  String name;
  String statusLine;

  factory UserNameStatusUpdateModel.fromJson(Map<String, dynamic> json) => UserNameStatusUpdateModel(
    id: json["_id"],
    name: json["name"],
    statusLine: json["status_line"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "status_line": statusLine,
  };
}
