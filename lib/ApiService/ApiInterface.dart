import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:me_app/Dialogs/AlertBox.dart';
import 'package:me_app/Model/GetMCXModel.dart';
import 'package:me_app/Model/GetNotification.dart';
import 'package:me_app/Model/GetPortfolioList.dart';
import 'package:me_app/Model/GetProfileData.dart';
import 'package:me_app/Model/GetWalletModel.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Model/TradeData.dart';
import 'package:me_app/Resources/Strings.dart';
import 'package:me_app/Screen/LoginScreen.dart';
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

  static Future<LoginData?> userDetails(BuildContext context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context, "userDetail", showLoading);
    return status ? LoginData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<LoginData?> login(
      BuildContext context, String userName, String password,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "loginAuth", showLoading,
        requestParams: {"username": userName, "password": password});
    return status ? LoginData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<GetMcx?> getStockList(BuildContext context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _getApiCall(context, "getMcxCategoryList", showLoading);
    return status ? GetMcx.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<LiveRate?> getLiveRate(BuildContext context,
      {String token = "", bool showLoading = false}) async {
    var (bool status, Response? response) = await _getApiCall(
        context, "getLiveRate", showLoading,
        requestParams: token != "" ? {"token": token} : {});
    final data = status ? LiveRate.fromJson(jsonDecode(response!.body)) : null;
    sessionOut(data?.isLogin != null && data?.isLogin == 0, context,
        data?.message ?? "");
    return data;
  }

  static Future<StatusMessage?> addToWatchList(
      BuildContext context, String categoryId, num isChecked,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _getApiCall(
        context, "addUserWatchList", true, requestParams: {
      "category_id": categoryId,
      "ischecked": isChecked.toString()
    });
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<TradeData?> tradeList(BuildContext context, int tradeStatus,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "getTradeList", showLoading,
        requestParams: {"status": tradeStatus.toString()});
    return status ? TradeData.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> updateTradeStatus(
      BuildContext context, String orderId, String type,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _postApiCall(
        context, "closeCancelTrade", true,
        requestParams: {"orderID": orderId, "type": type});
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<PortfolioCloseList?> getPortfolioClose(BuildContext? context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getClosePortfolioList", showLoading);
    return status
        ? PortfolioCloseList.fromJson(jsonDecode(response!.body))
        : null;
  }

  static Future<GetPortfolioList?> getPortfolio(BuildContext? context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getPortfolioList", showLoading);
    return status
        ? GetPortfolioList.fromJson(jsonDecode(response!.body))
        : null;
  }

  static Future<GetWallet?> getWalletHistory(BuildContext? context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getWalletHistory", showLoading);
    return status ? GetWallet.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<GetProfiledata?> getProfile(BuildContext? context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "getProfileData", showLoading);
    return status ? GetProfiledata.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> changePassword(
      BuildContext? context, String newPassword, String oldPassword,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _postApiCall(
        context!, "changePassword", true,
        requestParams: {"opw": oldPassword, "npw": newPassword});
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<GetNotification?> getNotifications(BuildContext? context,
      {bool showLoading = false}) async {
    var (bool status, Response? response) = await _postApiCall(
      context!,
      "getNotificationList",
      true,
    );
    return status ? GetNotification.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<StatusMessage?> placeOrder(
      BuildContext? context,
      String catId,
      String expireDate,
      String orderType,
      String bidType,
      String bidPrice,
      String lotSize,
      {bool showLoading = false}) async {
    var (bool status, Response? response) =
        await _postApiCall(context!, "orderAuth", true, requestParams: {
      "catID": catId,
      "exipreDate": expireDate,
      "orderType": orderType,
      "bidType": bidType,
      "bidPrice": bidPrice,
      "lotSize": lotSize
    });
    return status ? StatusMessage.fromJson(jsonDecode(response!.body)) : null;
  }

  static Future<(bool, Response?)> _getApiCall(
      BuildContext context, String endPoint, bool showLoading,
      {Map<String, dynamic>? requestParams}) async {
    if (await HelperFunction.isInternetConnected(context)) {
      if (showLoading) {
        AlertBox.showLoader(context);
      }

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final deviceInfoPlugin = DeviceInfoPlugin();

      // Initialize device info with null checks
      String deviceName = 'Unknown Device';
      if (!kIsWeb) {
        try {
          final deviceInfo = await deviceInfoPlugin.androidInfo;
          deviceName = "${deviceInfo.display ?? 'Unknown Display'} ${deviceInfo.model ?? 'Unknown Model'}";
        } catch (e) {
          print('Error fetching device info: $e');
        }
      }

      String? token = await FirebaseMessaging.instance.getToken();

      requestParams ??= {};
      requestParams.addAll({
        "userID": sharedPreferences.getString(Strings.USER_ID) ?? 'Unknown UserID',
        "fcm_id": token ?? 'Unknown FCM Token',
        "deviceName": deviceName,
      });

      try {
        final uri = Uri.parse(BASE_URL + endPoint).replace(queryParameters: requestParams);
        final response = await httpClient.get(uri, headers: await getHeader());

        if (showLoading) {
          AlertBox.dismissLoader(context);
        }

        return (
        (response.statusCode == 200 && response.body.isNotEmpty),
        response
        );
      } catch (e) {
        print('Error making GET request: $e');
        if (showLoading) {
          AlertBox.dismissLoader(context);
        }
        return (false, null);
      }
    } else {
      return (false, null);
    }
  }

  static Future<(bool status, Response? response)> _postApiCall(
      BuildContext context, String endPoint, bool showLoading,
      {Map<String, dynamic>? requestParams}) async {
    if (await HelperFunction.isInternetConnected(context)) {
      if (showLoading) {
        AlertBox.showLoader(context);
      }

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final deviceInfoPlugin = DeviceInfoPlugin();

      // Initialize device info with null checks
      String deviceName = 'Unknown Device';
      if (!kIsWeb) {
        try {
          final deviceInfo = await deviceInfoPlugin.androidInfo;
          deviceName =
              "${deviceInfo.display ?? 'Unknown Display'} ${deviceInfo.model ?? 'Unknown Model'}";
        } catch (e) {
          print('Error fetching device info: $e');
        }
      }

      String? token = await FirebaseMessaging.instance.getToken();

      requestParams ??= {};
      requestParams.addAll({
        "userID":
            sharedPreferences.getString(Strings.USER_ID) ?? 'Unknown UserID',
        "fcm_id": token ?? 'Unknown FCM Token',
        "deviceName": deviceName,
      });

      try {
        final response = await httpClient.post(
          Uri.parse(BASE_URL + endPoint),
          headers: await getHeader(),
          body: requestParams,
        );

        if (showLoading) {
          AlertBox.dismissLoader(context);
        }

        return (
          (response.statusCode == 200 && response.body.isNotEmpty),
          response
        );
      } catch (e) {
        print('Error making POST request: $e');
        if (showLoading) {
          AlertBox.dismissLoader(context);
        }
        return (false, null);
      }
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

  static Future<void> sessionOut(
      bool isLogout, BuildContext context, String message) async {
    if (isLogout) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.clear();
      LoginScreen().launch(context, isNewTask: true);
      HelperFunction.showMessage(context, message, type: 3);
    }
  }
}
