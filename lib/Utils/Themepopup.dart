import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Resources/Styles.dart';
import '../Resources/Strings.dart';
import 'Themeprovider.dart';

void showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: const Text(Strings.selectTheme,
            style: TextStyle(color: Colors.black)),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  Strings.lightTheme,
                  style: Styles.normalText(isBold: true),
                ),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = false;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  Strings.darkTheme,
                  style: Styles.normalText(isBold: true),
                ),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = true;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(Strings.goldenTheme, style: Styles.normalText(isBold: true),),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = false;
                  ref.read(goldenThemeProvider.notifier).state = true;
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
