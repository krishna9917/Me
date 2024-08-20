import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
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


  static void showStatus(BuildContext context, String message,bool isErrorMessage)
  {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            content: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Image.asset(isErrorMessage?"assets/img_error.png":"assets/img_success.png",width: 100,height: 100,),
                10.height,
                Text(message,style: Styles.normalText(isBold: true),)
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
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


}