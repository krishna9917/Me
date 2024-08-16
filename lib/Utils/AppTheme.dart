import 'package:flutter/material.dart';

import 'Colors.dart';

ThemeData getAppTheme(BuildContext context, bool isDarkTheme, bool isGoldenTheme) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
        color1: isGoldenTheme
            ? goldencolor
            : isDarkTheme
            ? Colors.blue
            : Colors.green,
        color2: isGoldenTheme
            ? Colors.black
            : isDarkTheme
            ? Colors.pink
            : Colors.blue,
        color3: isGoldenTheme
            ? Colors.green
            : isDarkTheme
            ? Colors.yellow
            : Colors.red,
      ),
    ],
    scaffoldBackgroundColor: isGoldenTheme
        ? Colors.black
        : (isDarkTheme ? Colors.black : Colors.white),
    textTheme: Theme.of(context)
        .textTheme
        .copyWith(
      titleSmall: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: 12),
    )
        .apply(
      bodyColor: isGoldenTheme
          ? goldencolor
          : (isDarkTheme ? Colors.white : Colors.black),
      displayColor: Colors.grey,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(
          isGoldenTheme
              ? Colors.red
              : (isDarkTheme ? Colors.orange : Colors.white)),
    ),
    listTileTheme: ListTileThemeData(
        iconColor: isGoldenTheme
            ? Colors.red
            : (isDarkTheme ? Colors.orange : Colors.white)),
    appBarTheme: AppBarTheme(
        backgroundColor: isGoldenTheme
            ? Colors.black
            : (isDarkTheme ? Colors.black : Colors.white),
        iconTheme: IconThemeData(color: Colors.white)), // Set back icon color to white
    tabBarTheme: TabBarTheme(
      labelColor: isGoldenTheme
          ? Colors.white
          : (isDarkTheme ? Colors.white : Colors.black), // Selected tab label color
      unselectedLabelColor: isGoldenTheme
          ? Colors.grey // You can set a different color for unselected tabs
          : (isDarkTheme ? Colors.white54 : Colors.black54), // Unselected tab label color
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(color: Colors.black),
      contentTextStyle: TextStyle(color: Colors.black),
    ),
  );
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? color1;
  final Color? color2;
  final Color? color3;

  const AppColors({
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  AppColors copyWith({
    Color? color1,
    Color? color2,
    Color? color3,
  }) {
    return AppColors(
      color1: color1 ?? this.color1,
      color2: color2 ?? this.color2,
      color3: color3 ?? this.color3,
    );
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
    );
  }
}
