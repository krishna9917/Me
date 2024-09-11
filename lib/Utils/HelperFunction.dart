import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class HelperFunction {
  static HttpWithMiddleware httpClient = HttpWithMiddleware.build(middlewares: [
    HttpLogger(logLevel: LogLevel.BODY),
  ]);

  static Future<bool> isInternetConnected(BuildContext context,
      {bool requireShowMessage = true}) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (requireShowMessage) {
        showMessage(context, "No internet connection", type: 3);
      }
      return false;
    }
    return true;
  }

  //Snackbar   type  -- 1 -> black background ,2 ->  green background  3---> red background means error
  static void showMessage(BuildContext context, String message,
      {int type = 1, SnackBarAction? snackBarAction}) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    // Check for vibration support before attempting to vibrate
    if (type == 3 && !kIsWeb) {
      Vibration.vibrate(pattern: [100, 500]);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.isEmpty ? "Something went wrong" : message,
          style: TextStyle(
              color: Colors.white), // Assuming Styles.normalText gives this
        ),
        backgroundColor: type == 2
            ? Colors.green
            : type == 3
                ? Colors.red
                : Colors.black,
        action: snackBarAction,
      ),
    );
  }

  static openIntentAsPerUrl(Uri url, BuildContext context) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      showMessage(context, "Unable to call $url", type: 3);
    }
  }

  static bool isEmptyField(String text, String message, BuildContext context) {
    if (text.isEmpty) {
      showMessage(context, message, type: 3);
    }
    return text.isEmpty;
  }

  static String formattedDate(String dateTimeString) {
    DateFormat inputFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime dateTime = inputFormat.parse(dateTimeString);
    DateFormat outputFormat = DateFormat("dd MMM HH:mm");
    return outputFormat.format(dateTime);
  }
}
