// To parse this JSON data, do
//
//     final cancelTrade = cancelTradeFromJson(jsonString);

import 'dart:convert';

CancelTrade cancelTradeFromJson(String str) => CancelTrade.fromJson(json.decode(str));

String cancelTradeToJson(CancelTrade data) => json.encode(data.toJson());

class CancelTrade {
  int? status;
  String? message;

  CancelTrade({
    this.status,
    this.message,
  });

  factory CancelTrade.fromJson(Map<String, dynamic> json) => CancelTrade(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
