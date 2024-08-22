import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class HelperFunction {
  // internet connection checking
  static Future<bool> isInternetConnected(BuildContext context,
      {bool requireShowMessage = true}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      if (requireShowMessage) {
        showMessage(context, Strings.noInternetConnection, type: 3);
      }
      return false;
    }
    return false;
  }

  //Snackbar   type  -- 1 -> black background ,2 ->  green background  3---> red background means error
  static void showMessage(BuildContext context, String message,
      {int type = 1, SnackBarAction? snackBarAction}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (type == 3) Vibration.vibrate(pattern: [100, 500]);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message == null || message == "" ? "Something went wrong" : message,
          style: Styles.normalText(color: Colors.white),
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
