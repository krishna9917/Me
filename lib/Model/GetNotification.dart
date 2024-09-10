/// status : 1
/// message : "success"
/// data : [{"type":"1","message":"Welcome ","created":"09-Sep-2024 19:52:08"}]

class GetNotification {
  GetNotification({
      num? status, 
      String? message, 
      List<Data>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  GetNotification.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  num? _status;
  String? _message;
  List<Data>? _data;
GetNotification copyWith({  num? status,
  String? message,
  List<Data>? data,
}) => GetNotification(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  num? get status => _status;
  String? get message => _message;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// type : "1"
/// message : "Welcome "
/// created : "09-Sep-2024 19:52:08"

class Data {
  Data({
      String? type, 
      String? message, 
      String? created,}){
    _type = type;
    _message = message;
    _created = created;
}

  Data.fromJson(dynamic json) {
    _type = json['type'];
    _message = json['message'];
    _created = json['created'];
  }
  String? _type;
  String? _message;
  String? _created;
Data copyWith({  String? type,
  String? message,
  String? created,
}) => Data(  type: type ?? _type,
  message: message ?? _message,
  created: created ?? _created,
);
  String? get type => _type;
  String? get message => _message;
  String? get created => _created;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['message'] = _message;
    map['created'] = _created;
    return map;
  }

}