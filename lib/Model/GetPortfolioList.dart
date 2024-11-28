// To parse this JSON data, do
//
//     final getPortfolioList = getPortfolioListFromJson(jsonString);

import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

GetPortfolioList getPortfolioListFromJson(String str) =>
    GetPortfolioList.fromJson(json.decode(str));

String getPortfolioListToJson(GetPortfolioList data) =>
    json.encode(data.toJson());

class GetPortfolioList {
  int? status;
  String? message;
  String? totalLedgerBalance;
  double? totalMarginBalance;
  double? totalPlBalance;
  double? totalM2MBalance;
  List<Datum>? data;

  GetPortfolioList({
    this.status,
    this.message,
    this.totalLedgerBalance,
    this.totalMarginBalance,
    this.totalPlBalance,
    this.totalM2MBalance,
    this.data,
  });

  factory GetPortfolioList.fromJson(Map<String, dynamic> json) =>
      GetPortfolioList(
        status: json["status"],
        message: json["message"],
        totalLedgerBalance: json["totalLedgerBalance"],
        totalMarginBalance: json["totalMarginBalance"].toDouble(),
        totalPlBalance: json["totalPLBalance"].toDouble(),
        totalM2MBalance: json["totalM2MBalance"].toDouble(),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalLedgerBalance": totalLedgerBalance,
        "totalMarginBalance": totalMarginBalance,
        "totalPLBalance": totalPlBalance,
        "totalM2MBalance": totalM2MBalance,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? orderId;
  String? categoryId;
  String? categoryName;
  String? instrumentToken;
  String? expireDate;
  String? orderType;
  String? bidType;
  String? lot;
  String? intradayMargin;
  String? holdingMargin;
  String? totalReqHoldingMargin;
  int? lotSize;
  double? bidPrice;
  double? avrageBidPrice;
  String? totalDebitAmount;
  String? ledgerBalance;
  String? marginBalance;
  String? m2MBalance;
  String? cmprate;
  int? plBalance;
  String? orderDateTime;

  Datum({
    this.orderId,
    this.categoryId,
    this.categoryName,
    this.instrumentToken,
    this.expireDate,
    this.orderType,
    this.bidType,
    this.lot,
    this.intradayMargin,
    this.holdingMargin,
    this.totalReqHoldingMargin,
    this.lotSize,
    this.bidPrice,
    this.avrageBidPrice,
    this.totalDebitAmount,
    this.ledgerBalance,
    this.marginBalance,
    this.m2MBalance,
    this.cmprate,
    this.plBalance,
    this.orderDateTime,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        orderId: json["orderID"],
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        instrumentToken: json["instrument_token"],
        expireDate: json["expire_date"],
        orderType: json["order_type"],
        bidType: json["bid_type"],
        lot: json["lot"],
        intradayMargin: json["intradayMargin"].toString(),
        holdingMargin: json["holdingMargin"].toString(),
        totalReqHoldingMargin: json["totalReqHoldingMargin"],
        lotSize: json["lotSize"],
        bidPrice: json["bid_price"].toString().toDouble(),
        avrageBidPrice: json["avrageBidPrice"].toDouble(),
        totalDebitAmount: json["total_debit_amount"],
        ledgerBalance: json["ledger_balance"],
        marginBalance: json["margin_balance"],
        m2MBalance: json["m2m_balance"],
        cmprate: json["cmprate"],
        plBalance: json["pl_balance"],
        orderDateTime: json["orderDateTime"],
      );

  Map<String, dynamic> toJson() => {
        "orderID": orderId,
        "category_id": categoryId,
        "category_name": categoryName,
        "instrument_token": instrumentToken,
        "expire_date": expireDate,
        "order_type": orderType,
        "bid_type": bidType,
        "lot": lot,
        "intradayMargin": intradayMargin,
        "holdingMargin": holdingMargin,
        "totalReqHoldingMargin": totalReqHoldingMargin,
        "lotSize": lotSize,
        "bid_price": bidPrice,
        "avrageBidPrice": avrageBidPrice,
        "total_debit_amount": totalDebitAmount,
        "ledger_balance": ledgerBalance,
        "margin_balance": marginBalance,
        "m2m_balance": m2MBalance,
        "cmprate": cmprate,
        "pl_balance": plBalance,
        "orderDateTime": orderDateTime,
      };
}
