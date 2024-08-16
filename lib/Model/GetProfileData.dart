// To parse this JSON data, do
//
//     final getProfiledata = getProfiledataFromJson(jsonString);

import 'dart:convert';

GetProfiledata getProfiledataFromJson(String str) => GetProfiledata.fromJson(json.decode(str));

String getProfiledataToJson(GetProfiledata data) => json.encode(data.toJson());

class GetProfiledata {
  int? status;
  String? message;
  int? nseTrading;
  int? mcxTrading;
  String? nseBrokerage;
  String? nseIntradayMargin;
  String? nseHoldingMargin;
  String? mcxBrokerage;
  String? mcxBrokerageType;
  List<Mcx>? mcxIntraday;
  List<Mcx>? mcxHolding;
  McxBrokeragePerLot? mcxBrokeragePerLot;

  GetProfiledata({
    this.status,
    this.message,
    this.nseTrading,
    this.mcxTrading,
    this.nseBrokerage,
    this.nseIntradayMargin,
    this.nseHoldingMargin,
    this.mcxBrokerage,
    this.mcxBrokerageType,
    this.mcxIntraday,
    this.mcxHolding,
    this.mcxBrokeragePerLot,
  });

  factory GetProfiledata.fromJson(Map<String, dynamic> json) => GetProfiledata(
    status: json["status"],
    message: json["message"],
    nseTrading: json["nse_trading"],
    mcxTrading: json["mcx_trading"],
    nseBrokerage: json["nse_brokerage"],
    nseIntradayMargin: json["nse_intraday_margin"],
    nseHoldingMargin: json["nse_holding_margin"],
    mcxBrokerage: json["mcx_brokerage"],
    mcxBrokerageType: json["mcx_brokerage_type"],
    mcxIntraday: List<Mcx>.from(json["mcx_intraday"].map((x) => Mcx.fromJson(x))),
    mcxHolding: List<Mcx>.from(json["mcx_holding"].map((x) => Mcx.fromJson(x))),
    mcxBrokeragePerLot: McxBrokeragePerLot.fromJson(json["mcx_brokerage_per_lot"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "nse_trading": nseTrading,
    "mcx_trading": mcxTrading,
    "nse_brokerage": nseBrokerage,
    "nse_intraday_margin": nseIntradayMargin,
    "nse_holding_margin": nseHoldingMargin,
    "mcx_brokerage": mcxBrokerage,
    "mcx_brokerage_type": mcxBrokerageType,
    "mcx_intraday": List<dynamic>.from(mcxIntraday!.map((x) => x.toJson())),
    "mcx_holding": List<dynamic>.from(mcxHolding!.map((x) => x.toJson())),
    "mcx_brokerage_per_lot": mcxBrokeragePerLot!.toJson(),
  };
}

class McxBrokeragePerLot {
  String? gold;
  String? goldMini;
  String? aluminium;
  String? copper;
  String? crudeoil;
  String? lead;
  String? naturalGas;
  String? zinc;
  String? silver;
  String? silverMini;
  String? crudeoilm;
  String? naturalgasm;

  McxBrokeragePerLot({
    this.gold,
    this.goldMini,
    this.aluminium,
    this.copper,
    this.crudeoil,
    this.lead,
    this.naturalGas,
    this.zinc,
    this.silver,
    this.silverMini,
    this.crudeoilm,
    this.naturalgasm,
  });

  factory McxBrokeragePerLot.fromJson(Map<String, dynamic> json) => McxBrokeragePerLot(
    gold: json["GOLD"],
    goldMini: json["GOLD MINI"],
    aluminium: json["ALUMINIUM"],
    copper: json["COPPER"],
    crudeoil: json["CRUDEOIL"],
    lead: json["LEAD"],
    naturalGas: json["NATURAL GAS"],
    zinc: json["ZINC"],
    silver: json["SILVER"],
    silverMini: json["SILVER MINI"],
    crudeoilm: json["CRUDEOILM"],
    naturalgasm: json["NATURALGASM"],
  );

  Map<String, dynamic> toJson() => {
    "GOLD": gold,
    "GOLD MINI": goldMini,
    "ALUMINIUM": aluminium,
    "COPPER": copper,
    "CRUDEOIL": crudeoil,
    "LEAD": lead,
    "NATURAL GAS": naturalGas,
    "ZINC": zinc,
    "SILVER": silver,
    "SILVER MINI": silverMini,
    "CRUDEOILM": crudeoilm,
    "NATURALGASM": naturalgasm,
  };
}

class Mcx {
  String? title;
  String? margin;

  Mcx({
    this.title,
    this.margin,
  });

  factory Mcx.fromJson(Map<String, dynamic> json) => Mcx(
    title: json["title"],
    margin: json["margin"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "margin": margin,
  };
}
