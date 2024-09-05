import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Resources/Strings.dart';
import 'Themeprovider.dart';

void showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
  Future<void> storeChangedTheme(bool isDarkTheme, bool isGoldenTheme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
        Strings.theme,
        isDarkTheme
            ? Strings.darkTheme
            : isGoldenTheme
                ? Strings.goldenTheme
                : Strings.lightTheme);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(Strings.selectTheme,
            style: Theme.of(context).textTheme.titleLarge),
        content: Container(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  Strings.lightTheme,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = false;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  storeChangedTheme(false, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  Strings.darkTheme,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = true;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  storeChangedTheme(true, false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(
                  Strings.goldenTheme,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = false;
                  ref.read(goldenThemeProvider.notifier).state = true;
                  storeChangedTheme(false, true);
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
