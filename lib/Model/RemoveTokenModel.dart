// To parse this JSON data, do
//
//     final removeCheck = removeCheckFromJson(jsonString);

import 'dart:convert';

RemoveCheck removeCheckFromJson(String str) =>
    RemoveCheck.fromJson(json.decode(str));

String removeCheckToJson(RemoveCheck data) => json.encode(data.toJson());

class RemoveCheck {
  int? status;
  String? message;

  RemoveCheck({
    this.status,
    this.message,
  });

  factory RemoveCheck.fromJson(Map<String, dynamic> json) => RemoveCheck(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
