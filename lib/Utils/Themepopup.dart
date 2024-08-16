import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Themeprovider.dart';

void showThemeSelectionDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.all(16.0),
        title: const Text('Select Theme', style: TextStyle(color: Colors.black)),
        content: Container(
          constraints: BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light Theme'),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = false;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Theme'),
                onTap: () {
                  ref.read(appThemeProvider.notifier).state = true;
                  ref.read(goldenThemeProvider.notifier).state = false;
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Golden Theme'),
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
