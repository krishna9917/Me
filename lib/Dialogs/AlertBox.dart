import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Resources/ImagePaths.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class AlertBox {
  static void showAlert(
      BuildContext context, Widget message, Function() confirmEvent) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: message,
                titleTextStyle: Styles.normalText(),
                actions: [
                  25.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          Strings.decline.toUpperCase(),
                          style: Styles.normalText(
                              isBold: true, color: Colors.red),
                        ),
                      ).onTap(() {
                        Navigator.pop(context);
                      }),
                      20.width,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        color: Colors.black,
                        child: Text(
                          Strings.confirm.toUpperCase(),
                          style: Styles.normalText(
                              isBold: true, color: Colors.white),
                        ),
                      ).onTap(() {
                        Navigator.pop(context);
                        confirmEvent();
                      })
                    ],
                  ),
                ]));
  }

  static void showStatus(
      BuildContext context, String message, bool isErrorMessage) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Image.asset(
                      isErrorMessage
                          ? ImagePaths.circleCross
                          : ImagePaths.circleTick,
                      width: 100,
                      height: 100,
                    ),
                    10.height,
                    Text(
                      message,
                      style: Styles.normalText(isBold: true),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 15),
                          child: Text(
                            Strings.close.toUpperCase(),
                            style: Styles.normalText(
                                isBold: true, color: Colors.white),
                          ),
                        ).onTap(() {
                          Navigator.pop(context);
                        }),
                      ),
                    ],
                  ),
                ]));
  }

  static void showLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0, // Removes the shadow
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [SpinKitSpinningLines(color: Colors.blue)],
        ),
      ),
    );
  }

  static void dismissLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
