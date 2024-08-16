// To parse this JSON data, do
//
//     final tradeList = tradeListFromJson(jsonString);

import 'dart:convert';

List<TradeList> tradeListFromJson(String str) => List<TradeList>.from(json.decode(str).map((x) => TradeList.fromJson(x)));

String tradeListToJson(List<TradeList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TradeList {
  String? orderId;
  String? categoryId;
  String? token;
  String? categoryName;
  String? expireDate;
  String? orderType;
  String? bidType;
  String? lot;
  String? intradayMargin;
  int? holdingMargin;
  String? bidPrice;
  String? sellPrice;
  String? totalDebitAmount;
  String? ledgerBalance;
  String? marginBalance;
  String? m2MBalance;
  String? totalProfit;
  String? brokerage;
  String? status;
  String? closeOrderType;
  String? orderDateTime;
  String? orderUpdateDateTime;

  TradeList({
    this.orderId,
    this.categoryId,
    this.token,
    this.categoryName,
    this.expireDate,
    this.orderType,
    this.bidType,
    this.lot,
    this.intradayMargin,
    this.holdingMargin,
    this.bidPrice,
    this.sellPrice,
    this.totalDebitAmount,
    this.ledgerBalance,
    this.marginBalance,
    this.m2MBalance,
    this.totalProfit,
    this.brokerage,
    this.status,
    this.closeOrderType,
    this.orderDateTime,
    this.orderUpdateDateTime,
  });

  factory TradeList.fromJson(Map<String, dynamic> json) => TradeList(
    orderId: json["orderID"],
    categoryId: json["category_id"],
    token: json["token"],
    categoryName: json["category_name"],
    expireDate: json["expire_date"],
    orderType: json["order_type"],
    bidType: json["bid_type"],
    lot: json["lot"],
    intradayMargin: json["intradayMargin"],
    holdingMargin: json["holdingMargin"],
    bidPrice: json["bid_price"],
    sellPrice: json["sell_price"],
    totalDebitAmount: json["total_debit_amount"],
    ledgerBalance: json["ledger_balance"],
    marginBalance: json["margin_balance"],
    m2MBalance: json["m2m_balance"],
    totalProfit: json["total_profit"],
    brokerage: json["brokerage"],
    status: json["status"],
    closeOrderType: json["close_order_type"],
    orderDateTime: json["orderDateTime"],
    orderUpdateDateTime: json["orderUpdateDateTime"],
  );

  Map<String, dynamic> toJson() => {
    "orderID": orderId,
    "category_id": categoryId,
    "token": token,
    "category_name": categoryName,
    "expire_date": expireDate,
    "order_type": orderType,
    "bid_type": bidType,
    "lot": lot,
    "intradayMargin": intradayMargin,
    "holdingMargin": holdingMargin,
    "bid_price": bidPrice,
    "sell_price": sellPrice,
    "total_debit_amount": totalDebitAmount,
    "ledger_balance": ledgerBalance,
    "margin_balance": marginBalance,
    "m2m_balance": m2MBalance,
    "total_profit": totalProfit,
    "brokerage": brokerage,
    "status": status,
    "close_order_type": closeOrderType,
    "orderDateTime": orderDateTime,
    "orderUpdateDateTime": orderUpdateDateTime,
  };
}
