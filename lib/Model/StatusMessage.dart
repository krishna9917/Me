/// status : 1
/// message : "success"

class StatusMessage {
  StatusMessage({
      num? status, 
      String? message,}){
    _status = status;
    _message = message;
}

  StatusMessage.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }
  num? _status;
  String? _message;
StatusMessage copyWith({  num? status,
  String? message,
}) => StatusMessage(  status: status ?? _status,
  message: message ?? _message,
);
  num? get status => _status;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }

}