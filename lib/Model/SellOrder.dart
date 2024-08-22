// To parse this JSON data, do
//
//     final placeOrder = placeOrderFromJson(jsonString);

import 'dart:convert';

PlaceOrder placeOrderFromJson(String str) =>
    PlaceOrder.fromJson(json.decode(str));

String placeOrderToJson(PlaceOrder data) => json.encode(data.toJson());

class PlaceOrder {
  int? status;
  String? message;
  String? walletBalance;
  double? marginBalance;
  String? m2MBalance;
  String? bidPrice;

  PlaceOrder({
    this.status,
    this.message,
    this.walletBalance,
    this.marginBalance,
    this.m2MBalance,
    this.bidPrice,
  });

  factory PlaceOrder.fromJson(Map<String, dynamic> json) => PlaceOrder(
        status: json["status"],
        message: json["message"],
        walletBalance: json["wallet_balance"],
        marginBalance: json["margin_balance"].toDouble(),
        m2MBalance: json["m2m_balance"],
        bidPrice: json["bidPrice"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "wallet_balance": walletBalance,
        "margin_balance": marginBalance,
        "m2m_balance": m2MBalance,
        "bidPrice": bidPrice,
      };
}
