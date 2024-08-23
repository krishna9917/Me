import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

GetMcx getMcxFromJson(String str) => GetMcx.fromJson(json.decode(str));

String getMcxToJson(GetMcx data) => json.encode(data.toJson());

class GetMcx {
  int? status;
  String? message;
  List<StockData>? data;

  GetMcx({
    this.status,
    this.message,
    this.data,
  });

  factory GetMcx.fromJson(Map<String, dynamic> json) => GetMcx(
        status: json["status"],
        message: json["message"],
        data: List<StockData>.from(json["data"].map((x) => StockData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class StockData {
  String? categoryId;
  String? title;
  String? expireDate;
  String? instrumentToken;
  String? instrumentType;
  String? quotationLot;
  int? isChecked;
  int? status;
  num? priceChange;
  num? priceChangePercentage;
  Color? priceChangeColor;
  num? high;
  num? buyPrice;
  num? low;
  Color? buyPriceColor;
  Color? salePriceColor;
  num? salePrice;
  num? lastTradePrice;

  StockData({
    this.categoryId,
    this.title,
    this.expireDate,
    this.instrumentToken,
    this.instrumentType,
    this.quotationLot,
    this.isChecked,
    this.status,
    this.priceChange = 0,
    this.priceChangePercentage = 0.0,
    this.priceChangeColor = Colors.black,
    this.high = 0,
    this.buyPrice = 0,
    this.low = 0,
    this.buyPriceColor = Colors.transparent,
    this.salePriceColor = Colors.transparent,
    this.salePrice = 0,
    this.lastTradePrice = 0,
  });

  factory StockData.fromJson(Map<String, dynamic> json) => StockData(
        categoryId: json["category_id"],
        title: json["title"],
        expireDate: json["expire_date"],
        instrumentToken: json["instrument_token"],
        instrumentType: json["instrument_type"],
        quotationLot: json["QuotationLot"],
        isChecked: json["is_checked"],
        status: json["status"].toString().toInt(),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "title": title,
        "expire_date": expireDate,
        "instrument_token": instrumentToken,
        "instrument_type": instrumentType,
        "QuotationLot": quotationLot,
        "is_checked": isChecked,
        "status": status,
      };

  StockData copyWith({
    String? categoryId,
    String? title,
    String? expireDate,
    String? instrumentToken,
    String? instrumentType,
    String? quotationLot,
    int? isChecked,
    int? status,
    num? priceChange,
    num? priceChangePercentage,
    Color? priceChangeColor,
    num? high,
    num? buyPrice,
    num? low,
    Color? buyPriceColor,
    Color? salePriceColor,
    num? salePrice,
    num? lastTradePrice,
  }) {
    return StockData(
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      expireDate: expireDate ?? this.expireDate,
      instrumentToken: instrumentToken ?? this.instrumentToken,
      instrumentType: instrumentType ?? this.instrumentType,
      quotationLot: quotationLot ?? this.quotationLot,
      isChecked: isChecked ?? this.isChecked,
      status: status ?? this.status,
      priceChange: priceChange ?? this.priceChange,
      priceChangePercentage:
          priceChangePercentage ?? this.priceChangePercentage,
      priceChangeColor: priceChangeColor ?? this.priceChangeColor,
      high: high ?? this.high,
      buyPrice: buyPrice ?? this.buyPrice,
      low: low ?? this.low,
      buyPriceColor: buyPriceColor ?? this.buyPriceColor,
      salePriceColor: salePriceColor ?? this.salePriceColor,
      salePrice: salePrice ?? this.salePrice,
      lastTradePrice: lastTradePrice ?? this.lastTradePrice,
    );
  }
}
