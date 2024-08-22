import 'package:nb_utils/nb_utils.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String? userId;
  String? uniqueId;
  String? name;
  String? token;
  String? walletBalance;
  String? marginBalance;
  String? m2MBalance;
  String? mobile;
  String? isFirstTimeLogin;
  String? profilePhoto;

  LoginModel({
    this.userId,
    this.uniqueId,
    this.name,
    this.token,
    this.walletBalance,
    this.marginBalance,
    this.m2MBalance,
    this.mobile,
    this.isFirstTimeLogin,
    this.profilePhoto,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        userId: json["user_id"],
        uniqueId: json["unique_id"],
        name: json["name"],
        token: json["token"],
        walletBalance: json["wallet_balance"],
        marginBalance: json["margin_balance"],
        m2MBalance: json["m2m_balance"],
        mobile: json["mobile"],
        isFirstTimeLogin: json["is_first_time_login"],
        profilePhoto: json["profile_photo"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "unique_id": uniqueId,
        "name": name,
        "token": token,
        "wallet_balance": walletBalance,
        "margin_balance": marginBalance,
        "m2m_balance": m2MBalance,
        "mobile": mobile,
        "is_first_time_login": isFirstTimeLogin,
        "profile_photo": profilePhoto,
      };

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonData = jsonEncode(toJson());
    await prefs.setString('loginData', jsonData);
  }

  static Future<LoginModel?> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('loginData');
    if (jsonData != null) {
      return LoginModel.fromJson(jsonDecode(jsonData));
    }
    return null;
  }
}
