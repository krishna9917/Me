// To parse this JSON data, do
//
//     final liveRateToken = liveRateTokenFromJson(jsonString);

import 'dart:convert';

List<LiveRateToken> liveRateTokenFromJson(String str) =>
    List<LiveRateToken>.from(
        json.decode(str).map((x) => LiveRateToken.fromJson(x)));

String liveRateTokenToJson(List<LiveRateToken> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LiveRateToken {
  String? exchange;
  String? instrumentIdentifier;
  int? lastTradeTime;
  int? serverTime;
  double? averageTradedPrice;
  double? buyPrice;
  int? buyQty;
  double? close;
  int? high;
  double? low;
  double? lastTradePrice;
  int? lastTradeQty;
  double? open;
  int? openInterest;
  int? quotationLot;
  double? sellPrice;
  int? sellQty;
  int? totalQtyTraded;
  int? value;
  bool? preOpen;
  double? priceChange;
  double? priceChangePercentage;
  int? openInterestChange;
  String? messageType;
  double? lowerCircuit;
  double? upperCircuit;

  LiveRateToken({
    this.exchange,
    this.instrumentIdentifier,
    this.lastTradeTime,
    this.serverTime,
    this.averageTradedPrice,
    this.buyPrice,
    this.buyQty,
    this.close,
    this.high,
    this.low,
    this.lastTradePrice,
    this.lastTradeQty,
    this.open,
    this.openInterest,
    this.quotationLot,
    this.sellPrice,
    this.sellQty,
    this.totalQtyTraded,
    this.value,
    this.preOpen,
    this.priceChange,
    this.priceChangePercentage,
    this.openInterestChange,
    this.messageType,
    this.lowerCircuit,
    this.upperCircuit,
  });

  factory LiveRateToken.fromJson(Map<String, dynamic> json) => LiveRateToken(
        exchange: json["Exchange"],
        instrumentIdentifier: json["InstrumentIdentifier"],
        lastTradeTime: json["LastTradeTime"],
        serverTime: json["ServerTime"],
        averageTradedPrice: json["AverageTradedPrice"].toDouble(),
        buyPrice: json["BuyPrice"].toDouble(),
        buyQty: json["BuyQty"],
        close: json["Close"].toDouble(),
        high: json["High"],
        low: json["Low"].toDouble(),
        lastTradePrice: json["LastTradePrice"].toDouble(),
        lastTradeQty: json["LastTradeQty"],
        open: json["Open"].toDouble(),
        openInterest: json["OpenInterest"],
        quotationLot: json["QuotationLot"],
        sellPrice: json["SellPrice"].toDouble(),
        sellQty: json["SellQty"],
        totalQtyTraded: json["TotalQtyTraded"],
        value: json["Value"],
        preOpen: json["PreOpen"],
        priceChange: json["PriceChange"].toDouble(),
        priceChangePercentage: json["PriceChangePercentage"].toDouble(),
        openInterestChange: json["OpenInterestChange"],
        messageType: json["MessageType"],
        lowerCircuit: json["LowerCircuit"].toDouble(),
        upperCircuit: json["UpperCircuit"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Exchange": exchange,
        "InstrumentIdentifier": instrumentIdentifier,
        "LastTradeTime": lastTradeTime,
        "ServerTime": serverTime,
        "AverageTradedPrice": averageTradedPrice,
        "BuyPrice": buyPrice,
        "BuyQty": buyQty,
        "Close": close,
        "High": high,
        "Low": low,
        "LastTradePrice": lastTradePrice,
        "LastTradeQty": lastTradeQty,
        "Open": open,
        "OpenInterest": openInterest,
        "QuotationLot": quotationLot,
        "SellPrice": sellPrice,
        "SellQty": sellQty,
        "TotalQtyTraded": totalQtyTraded,
        "Value": value,
        "PreOpen": preOpen,
        "PriceChange": priceChange,
        "PriceChangePercentage": priceChangePercentage,
        "OpenInterestChange": openInterestChange,
        "MessageType": messageType,
        "LowerCircuit": lowerCircuit,
        "UpperCircuit": upperCircuit,
      };
}
