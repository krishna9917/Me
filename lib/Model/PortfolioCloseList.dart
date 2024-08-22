// To parse this JSON data, do
//
//     final portfolioCloseList = portfolioCloseListFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

PortfolioCloseList portfolioCloseListFromJson(String str) =>
    PortfolioCloseList.fromJson(json.decode(str));

String portfolioCloseListToJson(PortfolioCloseList data) =>
    json.encode(data.toJson());

class PortfolioCloseList {
  int? status;
  String? message;
  String? totalLedgerBalance;
  int? totalMarginBalance;
  int? totalPlBalance;
  int? totalBrokerage;
  int? netProfitLoss;
  List<Datum>? data;

  PortfolioCloseList({
    this.status,
    this.message,
    this.totalLedgerBalance,
    this.totalMarginBalance,
    this.totalPlBalance,
    this.totalBrokerage,
    this.netProfitLoss,
    this.data,
  });

  factory PortfolioCloseList.fromJson(Map<String, dynamic> json) =>
      PortfolioCloseList(
        status: json["status"],
        message: json["message"],
        totalLedgerBalance: json["totalLedgerBalance"],
        totalMarginBalance: json["totalMarginBalance"],
        totalPlBalance: json["totalPLBalance"],
        totalBrokerage: json["totalBrokerage"],
        netProfitLoss: json["netProfitLoss"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalLedgerBalance": totalLedgerBalance,
        "totalMarginBalance": totalMarginBalance,
        "totalPLBalance": totalPlBalance,
        "totalBrokerage": totalBrokerage,
        "netProfitLoss": netProfitLoss,
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
  int? intradayMargin;
  double? holdingMargin;
  int? lotSize;
  double? bidPrice;
  double? avgBuyPrice;
  double? avgSellPrice;
  String? totalDebitAmount;
  String? ledgerBalance;
  double? marginBalance;
  String? m2MBalance;
  String? plBalance;
  String? brokerage;
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
    this.lotSize,
    this.bidPrice,
    this.avgBuyPrice,
    this.avgSellPrice,
    this.totalDebitAmount,
    this.ledgerBalance,
    this.marginBalance,
    this.m2MBalance,
    this.plBalance,
    this.brokerage,
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
        intradayMargin: json["intradayMargin"].toInt(),
        holdingMargin: json["holdingMargin"].toDouble(),
        lotSize: json["lotSize"],
        bidPrice: json["bid_price"].toDouble(),
        avgBuyPrice: json["avgBuyPrice"].toDouble(),
        avgSellPrice: json["avgSellPrice"].toDouble(),
        totalDebitAmount: json["total_debit_amount"],
        ledgerBalance: json["ledger_balance"],
        marginBalance: json["margin_balance"].toDouble(),
        m2MBalance: json["m2m_balance"],
        plBalance: json["pl_balance"],
        brokerage: json["brokerage"],
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
        "lotSize": lotSize,
        "bid_price": bidPrice,
        "avgBuyPrice": avgBuyPrice,
        "avgSellPrice": avgSellPrice,
        "total_debit_amount": totalDebitAmount,
        "ledger_balance": ledgerBalance,
        "margin_balance": marginBalance,
        "m2m_balance": m2MBalance,
        "pl_balance": plBalance,
        "brokerage": brokerage,
        "orderDateTime": orderDateTime,
      };
}
