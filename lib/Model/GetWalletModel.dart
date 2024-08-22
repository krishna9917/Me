// To parse this JSON data, do
//
//     final getWallet = getWalletFromJson(jsonString);

import 'dart:convert';

GetWallet getWalletFromJson(String str) => GetWallet.fromJson(json.decode(str));

String getWalletToJson(GetWallet data) => json.encode(data.toJson());

class GetWallet {
  int? status;
  String? message;
  List<Datum>? data;

  GetWallet({
    this.status,
    this.message,
    this.data,
  });

  factory GetWallet.fromJson(Map<String, dynamic> json) => GetWallet(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? type;
  String? beforePoint;
  String? affectPoint;
  String? afterPoint;
  String? description;
  String? created;

  Datum({
    this.type,
    this.beforePoint,
    this.affectPoint,
    this.afterPoint,
    this.description,
    this.created,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        type: json["type"],
        beforePoint: json["before_point"],
        affectPoint: json["affect_point"],
        afterPoint: json["after_point"],
        description: json["description"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "before_point": beforePoint,
        "affect_point": affectPoint,
        "after_point": afterPoint,
        "description": description,
        "created": created,
      };
}
