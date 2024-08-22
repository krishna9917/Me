// To parse this JSON data, do
//
//     final updateLogin = updateLoginFromJson(jsonString);

import 'dart:convert';

UpdateLogin updateLoginFromJson(String str) =>
    UpdateLogin.fromJson(json.decode(str));

String updateLoginToJson(UpdateLogin data) => json.encode(data.toJson());

class UpdateLogin {
  int? status;
  String? message;
  UserData? userData;

  UpdateLogin({
    this.status,
    this.message,
    this.userData,
  });

  factory UpdateLogin.fromJson(Map<String, dynamic> json) => UpdateLogin(
        status: json["status"],
        message: json["message"],
        userData: UserData.fromJson(json["user_data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "user_data": userData!.toJson(),
      };
}

class UserData {
  String? uniqueId;
  String? name;
  String? mobile;
  String? isFirstTimeLogin;
  String? walletBalance;
  double? marginBalance;
  String? m2MBalance;
  String? profilePhoto;
  String? token;

  UserData({
    this.uniqueId,
    this.name,
    this.mobile,
    this.isFirstTimeLogin,
    this.walletBalance,
    this.marginBalance,
    this.m2MBalance,
    this.profilePhoto,
    this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uniqueId: json["unique_id"],
        name: json["name"],
        mobile: json["mobile"],
        isFirstTimeLogin: json["is_first_time_login"],
        walletBalance: json["wallet_balance"],
        marginBalance: json["margin_balance"].toDouble(),
        m2MBalance: json["m2m_balance"],
        profilePhoto: json["profile_photo"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "unique_id": uniqueId,
        "name": name,
        "mobile": mobile,
        "is_first_time_login": isFirstTimeLogin,
        "wallet_balance": walletBalance,
        "margin_balance": marginBalance,
        "m2m_balance": m2MBalance,
        "profile_photo": profilePhoto,
        "token": token,
      };
}
