import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:me_app/Model/GetMCXModel.dart';
import 'package:me_app/Model/GetPortfolioList.dart';
import 'package:me_app/Model/GetProfileData.dart';
import 'package:me_app/Model/GetWalletModel.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Model/TradeData.dart';
import 'package:me_app/Resources/Strings.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import '../Model/PortfolioCloseList.dart';
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

  static Future<GetMcx?> getStockList(BuildContext context) async {
    var (bool status, Response? response) =
        await _getApiCall(context, "getMcxCategoryList");
    return status ? GetMcx.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<LiveRate?> getLiveRate(BuildContext context) async {
    var (bool status, Response? response) =
        await _getApiCall(context, "getLiveRate");
    return status ? LiveRate.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> addToWatchList(
      BuildContext context, String categoryId, num isChecked) async {
    var (bool status, Response? response) = await _getApiCall(
        context, "addUserWatchList", requestParams: {
      "category_id": categoryId,
      "ischecked": isChecked.toString()
    });
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<TradeData?> tradeList(
      BuildContext context, int tradeStatus) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "getTradeList",
        requestParams: {"status": tradeStatus.toString()});
    return status ? TradeData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> updateTradeStatus(
      BuildContext context, String orderId, String type) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "closeCancelTrade",
        requestParams: {"orderID": orderId, "type": type});
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<PortfolioCloseList?> getPortfolioClose(
      BuildContext? context) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getClosePortfolioList");
    return status
        ? PortfolioCloseList.fromJson(jsonDecode(response!.body))
        : null;
  }

  static Future<GetPortfolioList?> getPortfolio(BuildContext? context) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getPortfolioList");
    return status
        ? GetPortfolioList.fromJson(jsonDecode(response!.body))
        : null;
  }

  static Future<GetWallet?> getWalletHistory(BuildContext? context) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getWalletHistory");
    return status ? GetWallet.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<GetProfiledata?> getProfile(BuildContext? context) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getProfileData");
    return status ? GetProfiledata.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> changePassword(
      BuildContext? context, String newPassword, String oldPassword) async {
    var (bool status, Response? response) = await _postApiCall(
        context!, "changePassword",
        requestParams: {"opw": oldPassword, "npw": newPassword});
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<(bool, Response?)> _getApiCall(
      BuildContext context, String endPoint,
      {Map<String, dynamic>? requestParams}) async {
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
          headers: await getHeader());
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
        "deviceName": deviceInfo.display + " " + deviceInfo.model
      });
      final response = await httpClient.post(Uri.parse(BASE_URL + endPoint),
          headers: await getHeader(), body: requestParams);
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
