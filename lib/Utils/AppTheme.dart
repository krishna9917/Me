import 'package:flutter/material.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Resources/Strings.dart';
import 'Colors.dart';

ThemeData getAppTheme(
    BuildContext context, bool isDarkTheme, bool isGoldenTheme) {

  Color textColor = isGoldenTheme
      ? Colors.amber
      : isDarkTheme
          ? Colors.white
          : Colors.black;
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
          color1: isGoldenTheme || isDarkTheme ? Colors.blueGrey : Colors.white,
          color2: isGoldenTheme
              ? Colors.amber
              : isDarkTheme
                  ? Colors.white
                  : Colors.black87,
          color3:
              isGoldenTheme || isDarkTheme ? Colors.blueGrey : Colors.black87,
          color4: isGoldenTheme ? Colors.amber : Colors.white,
          color5: isGoldenTheme ? Colors.amber : Colors.black),
    ],
    scaffoldBackgroundColor: isGoldenTheme
        ? Colors.black
        : (isDarkTheme ? Colors.black : Colors.grey.shade200),
    textTheme: TextTheme(
        titleLarge:
            Styles.normalText(context: context, color: textColor, isBold: true),
        titleMedium: Styles.normalText(
            context: context, color: textColor, fontSize: 12, isBold: true),
        titleSmall: Styles.normalText(
            context: context, color: textColor, fontSize: 9, isBold: true),
        headlineLarge: Styles.normalText(context: context, color: textColor),
        headlineMedium:
            Styles.normalText(context: context, color: textColor, fontSize: 12),
        headlineSmall:
            Styles.normalText(context: context, color: textColor, fontSize: 9)),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(isGoldenTheme
          ? Colors.red
          : (isDarkTheme ? Colors.orange : Colors.white)),
    ),
    iconTheme: IconThemeData(color: textColor),
    listTileTheme: ListTileThemeData(
        iconColor: isGoldenTheme
            ? Colors.red
            : (isDarkTheme ? Colors.orange : Colors.white)),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white)),
    tabBarTheme: TabBarTheme(
        dividerColor: Colors.white10,
        labelColor: isGoldenTheme ? Colors.amber : Colors.white,
        unselectedLabelColor:
            isGoldenTheme ? Colors.amber.shade300 : Colors.white70,
        labelStyle: Theme.of(context).textTheme.titleSmall,
        unselectedLabelStyle: Theme.of(context).textTheme.titleSmall),
    dialogTheme: DialogTheme(
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        contentTextStyle: Theme.of(context).textTheme.headlineLarge,
        backgroundColor:
            isGoldenTheme || isDarkTheme ? Colors.blueGrey : Colors.white),
  );
}



@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final Color? color4;
  final Color? color5;

  const AppColors(
      {required this.color1,
      required this.color2,
      required this.color3,
      required this.color4,
      required this.color5});

  @override
  AppColors copyWith(
      {Color? color1, Color? color2, Color? color3, Color? color4}) {
    return AppColors(
        color1: color1 ?? this.color1,
        color2: color2 ?? this.color2,
        color3: color3 ?? this.color3,
        color4: color4 ?? this.color4,
        color5: color5 ?? this.color5);
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      color1: Color.lerp(color1, other.color1, t),
      color2: Color.lerp(color2, other.color2, t),
      color3: Color.lerp(color3, other.color3, t),
      color4: Color.lerp(color4, other.color4, t),
      color5: Color.lerp(color5, other.color5, t),
    );
  }
}
