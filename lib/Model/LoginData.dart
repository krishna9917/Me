import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

import '../Resources/Strings.dart';

/// status : 1
/// message : "Logged in Successfully."
/// user_data : {"user_id":"145","unique_id":"OTL9384","name":"Mayank demo","token":"bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0M1FBQjFhcHliZGhzdmM5TlRTWlpGbGo0ZklXcytCMCswZktwbHRwTXh3TDlyRjdya25US0JCeTg1L1NPYkxaWWs9","wallet_balance":"425495.52","margin_balance":"425495.52","m2m_balance":"425495.52","mobile":"","is_first_time_login":"0","profile_photo":""}

class LoginData {
  LoginData({
    num? status,
    String? message,
    UserData? userData,
  }) {
    _status = status;
    _message = message;
    _userData = userData;
  }

  LoginData.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _userData =
        json['user_data'] != null ? UserData.fromJson(json['user_data']) : null;
  }

  num? _status;
  String? _message;
  UserData? _userData;

  LoginData copyWith({
    num? status,
    String? message,
    UserData? userData,
  }) =>
      LoginData(
        status: status ?? _status,
        message: message ?? _message,
        userData: userData ?? _userData,
      );

  num? get status => _status;

  String? get message => _message;

  UserData? get userData => _userData;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_userData != null) {
      map['user_data'] = _userData?.toJson();
    }
    return map;
  }

  static Future<void> saveData(LoginData loginData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(loginData.toJson());
    await prefs.setString(Strings.USER_DETAILS, jsonData);
    await prefs.setString(Strings.ACCESS_TOKEN, loginData.userData!.token!);
    await prefs.setString(Strings.USER_ID, loginData.userData!.userId!);
  }

  static Future<LoginData?> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString(Strings.USER_DETAILS);
    if (jsonData != null) {
      return LoginData.fromJson(jsonDecode(jsonData));
    }
    return null;
  }
}

/// user_id : "145"
/// unique_id : "OTL9384"
/// name : "Mayank demo"
/// token : "bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0M1FBQjFhcHliZGhzdmM5TlRTWlpGbGo0ZklXcytCMCswZktwbHRwTXh3TDlyRjdya25US0JCeTg1L1NPYkxaWWs9"
/// wallet_balance : "425495.52"
/// margin_balance : "425495.52"
/// m2m_balance : "425495.52"
/// mobile : ""
/// is_first_time_login : "0"
/// profile_photo : ""

class UserData {
  UserData({
    String? userId,
    String? uniqueId,
    String? name,
    String? token,
    String? walletBalance,
    String? marginBalance,
    String? m2mBalance,
    String? mobile,
    String? isFirstTimeLogin,
    String? profilePhoto,
  }) {
    _userId = userId;
    _uniqueId = uniqueId;
    _name = name;
    _token = token;
    _walletBalance = walletBalance;
    _marginBalance = marginBalance;
    _m2mBalance = m2mBalance;
    _mobile = mobile;
    _isFirstTimeLogin = isFirstTimeLogin;
    _profilePhoto = profilePhoto;
  }

  UserData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _uniqueId = json['unique_id'];
    _name = json['name'];
    _token = json['token'];
    _walletBalance = json['wallet_balance'];
    _marginBalance = json['margin_balance'].toString();
    _m2mBalance = json['m2m_balance'];
    _mobile = json['mobile'];
    _isFirstTimeLogin = json['is_first_time_login'];
    _profilePhoto = json['profile_photo'];
  }

  String? _userId;
  String? _uniqueId;
  String? _name;
  String? _token;
  String? _walletBalance;
  String? _marginBalance;
  String? _m2mBalance;
  String? _mobile;
  String? _isFirstTimeLogin;
  String? _profilePhoto;

  UserData copyWith({
    String? userId,
    String? uniqueId,
    String? name,
    String? token,
    String? walletBalance,
    String? marginBalance,
    String? m2mBalance,
    String? mobile,
    String? isFirstTimeLogin,
    String? profilePhoto,
  }) =>
      UserData(
        userId: userId ?? _userId,
        uniqueId: uniqueId ?? _uniqueId,
        name: name ?? _name,
        token: token ?? _token,
        walletBalance: walletBalance ?? _walletBalance,
        marginBalance: marginBalance ?? _marginBalance,
        m2mBalance: m2mBalance ?? _m2mBalance,
        mobile: mobile ?? _mobile,
        isFirstTimeLogin: isFirstTimeLogin ?? _isFirstTimeLogin,
        profilePhoto: profilePhoto ?? _profilePhoto,
      );

  String? get userId => _userId;

  String? get uniqueId => _uniqueId;

  String? get name => _name;

  String? get token => _token;

  String? get walletBalance => _walletBalance;

  String? get marginBalance => _marginBalance;

  String? get m2mBalance => _m2mBalance;

  String? get mobile => _mobile;

  String? get isFirstTimeLogin => _isFirstTimeLogin;

  String? get profilePhoto => _profilePhoto;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['unique_id'] = _uniqueId;
    map['name'] = _name;
    map['token'] = _token;
    map['wallet_balance'] = _walletBalance;
    map['margin_balance'] = _marginBalance;
    map['m2m_balance'] = _m2mBalance;
    map['mobile'] = _mobile;
    map['is_first_time_login'] = _isFirstTimeLogin;
    map['profile_photo'] = _profilePhoto;
    return map;
  }
}
