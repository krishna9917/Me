import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Resources/Strings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../Utils/HelperFunction.dart';

class ApiInterface {
  static String BASE_URL =
      "https://www.onlinetradelearn.com/mcx/authController/";

  static HttpWithMiddleware httpClient = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  static Future<LoginData?> userDetails(BuildContext context) async {
    var (bool status, Response? response) =
        await _postApiCall(context, "userDetail");
    return status ? LoginData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<LoginData?> login(
      BuildContext context, String userName, String password) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "loginAuth",
        requestParams: {"username": userName, "password": password});
    return status ? LoginData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<(bool, Response?)> _getApiCall(
      BuildContext context, String endPoint,
      {Map<String, String>? requestParams}) async {
    if (await HelperFunction.isInternetConnected(context)) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      requestParams ??= {};
      requestParams.addAll({
        "userID": sharedPreferences.getString(Strings.USER_ID).toString(),
        "fcm_id": "",
        "deviceName": ""
      });
      final response = await httpClient.get(
          Uri.parse(BASE_URL + endPoint)
              .replace(queryParameters: requestParams),
          headers: getHeader());
      return (
        (response.statusCode == 200 && response.body.isNotEmpty),
        response
      );
    }
    {
      return (false, null);
    }
  }

  static Future<(bool status, Response? response)> _postApiCall(
      BuildContext context, String endPoint,
      {Map<String, dynamic>? requestParams}) async {
    if (await HelperFunction.isInternetConnected(context)) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final deviceInfoPlugin = DeviceInfoPlugin();
      final deviceInfo = await deviceInfoPlugin.androidInfo;
      requestParams ??= {};
      requestParams.addAll({
        "userID": sharedPreferences.getString(Strings.USER_ID).toString(),
        "fcm_id": "",
        "deviceName": deviceInfo.display+" "+deviceInfo.model
      });
      final response = await httpClient.post(Uri.parse(BASE_URL + endPoint),
          headers: await getHeader(), body: jsonEncode(requestParams));
      return (
        (response.statusCode == 200 && response.body.isNotEmpty),
        response
      );
    } else {
      return (false, null);
    }
  }

  static getHeader() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.androidInfo;
    return {
      "Deviceid": deviceInfo.id.toString(),
      "Content-Type": "application/x-www-form-urlencoded",
      "Accept": "application/json",
      "Token": sharedPreferences.getString(Strings.ACCESS_TOKEN).toString()
    };
  }
}
