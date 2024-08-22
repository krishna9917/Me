/// livedata : [{"Exchange":"NFO","InstrumentIdentifier":"AARTIIND-I","LastTradeTime":1724234392,"ServerTime":1724234392,"AverageTradedPrice":627.31,"BuyPrice":622.35,"BuyQty":1000,"Close":620.7,"High":629.5,"Low":621,"LastTradePrice":624.7,"LastTradeQty":0,"Open":623.3,"OpenInterest":12344000,"QuotationLot":1000,"SellPrice":624.5,"SellQty":1000,"TotalQtyTraded":516000,"Value":323691960,"PreOpen":false,"PriceChange":4,"PriceChangePercentage":0.64,"OpenInterestChange":-388000,"MessageType":"RealtimeResult","LowerCircuit":558.65,"UpperCircuit":682.8}]

class LiveRate {
  LiveRate({
      List<Livedata>? livedata,}){
    _livedata = livedata;
}

  LiveRate.fromJson(dynamic json) {
    if (json['livedata'] != null) {
      _livedata = [];
      json['livedata'].forEach((v) {
        _livedata?.add(Livedata.fromJson(v));
      });
    }
  }
  List<Livedata>? _livedata;
LiveRate copyWith({  List<Livedata>? livedata,
}) => LiveRate(  livedata: livedata ?? _livedata,
);
  List<Livedata>? get livedata => _livedata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_livedata != null) {
      map['livedata'] = _livedata?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// Exchange : "NFO"
/// InstrumentIdentifier : "AARTIIND-I"
/// LastTradeTime : 1724234392
/// ServerTime : 1724234392
/// AverageTradedPrice : 627.31
/// BuyPrice : 622.35
/// BuyQty : 1000
/// Close : 620.7
/// High : 629.5
/// Low : 621
/// LastTradePrice : 624.7
/// LastTradeQty : 0
/// Open : 623.3
/// OpenInterest : 12344000
/// QuotationLot : 1000
/// SellPrice : 624.5
/// SellQty : 1000
/// TotalQtyTraded : 516000
/// Value : 323691960
/// PreOpen : false
/// PriceChange : 4
/// PriceChangePercentage : 0.64
/// OpenInterestChange : -388000
/// MessageType : "RealtimeResult"
/// LowerCircuit : 558.65
/// UpperCircuit : 682.8

class Livedata {
  Livedata({
      String? exchange, 
      String? instrumentIdentifier, 
      num? lastTradeTime, 
      num? serverTime, 
      num? averageTradedPrice, 
      num? buyPrice, 
      num? buyQty, 
      num? close, 
      num? high, 
      num? low, 
      num? lastTradePrice, 
      num? lastTradeQty, 
      num? open, 
      num? openInterest, 
      num? quotationLot, 
      num? sellPrice, 
      num? sellQty, 
      num? totalQtyTraded, 
      num? value, 
      bool? preOpen, 
      num? priceChange, 
      num? priceChangePercentage, 
      num? openInterestChange, 
      String? messageType, 
      num? lowerCircuit, 
      num? upperCircuit,}){
    _exchange = exchange;
    _instrumentIdentifier = instrumentIdentifier;
    _lastTradeTime = lastTradeTime;
    _serverTime = serverTime;
    _averageTradedPrice = averageTradedPrice;
    _buyPrice = buyPrice;
    _buyQty = buyQty;
    _close = close;
    _high = high;
    _low = low;
    _lastTradePrice = lastTradePrice;
    _lastTradeQty = lastTradeQty;
    _open = open;
    _openInterest = openInterest;
    _quotationLot = quotationLot;
    _sellPrice = sellPrice;
    _sellQty = sellQty;
    _totalQtyTraded = totalQtyTraded;
    _value = value;
    _preOpen = preOpen;
    _priceChange = priceChange;
    _priceChangePercentage = priceChangePercentage;
    _openInterestChange = openInterestChange;
    _messageType = messageType;
    _lowerCircuit = lowerCircuit;
    _upperCircuit = upperCircuit;
}

  Livedata.fromJson(dynamic json) {
    _exchange = json['Exchange'];
    _instrumentIdentifier = json['InstrumentIdentifier'];
    _lastTradeTime = json['LastTradeTime'];
    _serverTime = json['ServerTime'];
    _averageTradedPrice = json['AverageTradedPrice'];
    _buyPrice = json['BuyPrice'];
    _buyQty = json['BuyQty'];
    _close = json['Close'];
    _high = json['High'];
    _low = json['Low'];
    _lastTradePrice = json['LastTradePrice'];
    _lastTradeQty = json['LastTradeQty'];
    _open = json['Open'];
    _openInterest = json['OpenInterest'];
    _quotationLot = json['QuotationLot'];
    _sellPrice = json['SellPrice'];
    _sellQty = json['SellQty'];
    _totalQtyTraded = json['TotalQtyTraded'];
    _value = json['Value'];
    _preOpen = json['PreOpen'];
    _priceChange = json['PriceChange'];
    _priceChangePercentage = json['PriceChangePercentage'];
    _openInterestChange = json['OpenInterestChange'];
    _messageType = json['MessageType'];
    _lowerCircuit = json['LowerCircuit'];
    _upperCircuit = json['UpperCircuit'];
  }
  String? _exchange;
  String? _instrumentIdentifier;
  num? _lastTradeTime;
  num? _serverTime;
  num? _averageTradedPrice;
  num? _buyPrice;
  num? _buyQty;
  num? _close;
  num? _high;
  num? _low;
  num? _lastTradePrice;
  num? _lastTradeQty;
  num? _open;
  num? _openInterest;
  num? _quotationLot;
  num? _sellPrice;
  num? _sellQty;
  num? _totalQtyTraded;
  num? _value;
  bool? _preOpen;
  num? _priceChange;
  num? _priceChangePercentage;
  num? _openInterestChange;
  String? _messageType;
  num? _lowerCircuit;
  num? _upperCircuit;
Livedata copyWith({  String? exchange,
  String? instrumentIdentifier,
  num? lastTradeTime,
  num? serverTime,
  num? averageTradedPrice,
  num? buyPrice,
  num? buyQty,
  num? close,
  num? high,
  num? low,
  num? lastTradePrice,
  num? lastTradeQty,
  num? open,
  num? openInterest,
  num? quotationLot,
  num? sellPrice,
  num? sellQty,
  num? totalQtyTraded,
  num? value,
  bool? preOpen,
  num? priceChange,
  num? priceChangePercentage,
  num? openInterestChange,
  String? messageType,
  num? lowerCircuit,
  num? upperCircuit,
}) => Livedata(  exchange: exchange ?? _exchange,
  instrumentIdentifier: instrumentIdentifier ?? _instrumentIdentifier,
  lastTradeTime: lastTradeTime ?? _lastTradeTime,
  serverTime: serverTime ?? _serverTime,
  averageTradedPrice: averageTradedPrice ?? _averageTradedPrice,
  buyPrice: buyPrice ?? _buyPrice,
  buyQty: buyQty ?? _buyQty,
  close: close ?? _close,
  high: high ?? _high,
  low: low ?? _low,
  lastTradePrice: lastTradePrice ?? _lastTradePrice,
  lastTradeQty: lastTradeQty ?? _lastTradeQty,
  open: open ?? _open,
  openInterest: openInterest ?? _openInterest,
  quotationLot: quotationLot ?? _quotationLot,
  sellPrice: sellPrice ?? _sellPrice,
  sellQty: sellQty ?? _sellQty,
  totalQtyTraded: totalQtyTraded ?? _totalQtyTraded,
  value: value ?? _value,
  preOpen: preOpen ?? _preOpen,
  priceChange: priceChange ?? _priceChange,
  priceChangePercentage: priceChangePercentage ?? _priceChangePercentage,
  openInterestChange: openInterestChange ?? _openInterestChange,
  messageType: messageType ?? _messageType,
  lowerCircuit: lowerCircuit ?? _lowerCircuit,
  upperCircuit: upperCircuit ?? _upperCircuit,
);
  String? get exchange => _exchange;
  String? get instrumentIdentifier => _instrumentIdentifier;
  num? get lastTradeTime => _lastTradeTime;
  num? get serverTime => _serverTime;
  num? get averageTradedPrice => _averageTradedPrice;
  num? get buyPrice => _buyPrice;
  num? get buyQty => _buyQty;
  num? get close => _close;
  num? get high => _high;
  num? get low => _low;
  num? get lastTradePrice => _lastTradePrice;
  num? get lastTradeQty => _lastTradeQty;
  num? get open => _open;
  num? get openInterest => _openInterest;
  num? get quotationLot => _quotationLot;
  num? get sellPrice => _sellPrice;
  num? get sellQty => _sellQty;
  num? get totalQtyTraded => _totalQtyTraded;
  num? get value => _value;
  bool? get preOpen => _preOpen;
  num? get priceChange => _priceChange;
  num? get priceChangePercentage => _priceChangePercentage;
  num? get openInterestChange => _openInterestChange;
  String? get messageType => _messageType;
  num? get lowerCircuit => _lowerCircuit;
  num? get upperCircuit => _upperCircuit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Exchange'] = _exchange;
    map['InstrumentIdentifier'] = _instrumentIdentifier;
    map['LastTradeTime'] = _lastTradeTime;
    map['ServerTime'] = _serverTime;
    map['AverageTradedPrice'] = _averageTradedPrice;
    map['BuyPrice'] = _buyPrice;
    map['BuyQty'] = _buyQty;
    map['Close'] = _close;
    map['High'] = _high;
    map['Low'] = _low;
    map['LastTradePrice'] = _lastTradePrice;
    map['LastTradeQty'] = _lastTradeQty;
    map['Open'] = _open;
    map['OpenInterest'] = _openInterest;
    map['QuotationLot'] = _quotationLot;
    map['SellPrice'] = _sellPrice;
    map['SellQty'] = _sellQty;
    map['TotalQtyTraded'] = _totalQtyTraded;
    map['Value'] = _value;
    map['PreOpen'] = _preOpen;
    map['PriceChange'] = _priceChange;
    map['PriceChangePercentage'] = _priceChangePercentage;
    map['OpenInterestChange'] = _openInterestChange;
    map['MessageType'] = _messageType;
    map['LowerCircuit'] = _lowerCircuit;
    map['UpperCircuit'] = _upperCircuit;
    return map;
  }

}