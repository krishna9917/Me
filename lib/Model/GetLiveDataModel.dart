// To parse this JSON data, do
//
//     final getLiveData = getLiveDataFromJson(jsonString);

import 'dart:convert';

List<GetLiveData> getLiveDataFromJson(String str) => List<GetLiveData>.from(json.decode(str).map((x) => GetLiveData.fromJson(x)));

String getLiveDataToJson(List<GetLiveData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetLiveData {
  String? exchange;
  String? instrumentIdentifier;
  double? lastTradePrice;
  double? buyPrice;
  double? high;
  double? low;
  double? sellPrice;
  double? priceChange;
  double? priceChangePercentage;
  double? lowerCircuit;
  double? upperCircuit;
  int? quotationLot;

  GetLiveData({
    this.exchange,
    this.instrumentIdentifier,
    this.lastTradePrice,
    this.buyPrice,
    this.high,
    this.low,
    this.sellPrice,
    this.priceChange,
    this.priceChangePercentage,
    this.lowerCircuit,
    this.upperCircuit,
    this.quotationLot,
  });

  factory GetLiveData.fromJson(Map<String, dynamic> json) => GetLiveData(
    exchange: json["Exchange"],
    instrumentIdentifier: json["InstrumentIdentifier"],
    lastTradePrice: json["LastTradePrice"].toDouble(),
    buyPrice: json["BuyPrice"].toDouble(),
    high: json["High"].toDouble(),
    low: json["Low"].toDouble(),
    sellPrice: json["SellPrice"].toDouble(),
    priceChange: json["PriceChange"].toDouble(),
    priceChangePercentage: json["PriceChangePercentage"].toDouble(),
    lowerCircuit: json["LowerCircuit"].toDouble(),
    upperCircuit: json["UpperCircuit"].toDouble(),
    quotationLot: json["QuotationLot"],
  );

  Map<String, dynamic> toJson() => {
    "Exchange": exchange,
    "InstrumentIdentifier": instrumentIdentifier,
    "LastTradePrice": lastTradePrice,
    "BuyPrice": buyPrice,
    "High": high,
    "Low": low,
    "SellPrice": sellPrice,
    "PriceChange": priceChange,
    "PriceChangePercentage": priceChangePercentage,
    "LowerCircuit": lowerCircuit,
    "UpperCircuit": upperCircuit,
    "QuotationLot": quotationLot,
  };
}
