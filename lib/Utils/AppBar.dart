import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Dialogs/AlertBox.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import 'Themepopup.dart';
import 'Themeprovider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final WidgetRef ref;
  bool showBackButton;

  CustomAppBar({required this.ref, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Image.asset(
              width: showBackButton ? 25 : 60,
              height: showBackButton ? 25 : 60,
              showBackButton ? ImagePaths.backBtn : ImagePaths.logo),
          onPressed: () {
            if (showBackButton) {
              Navigator.pop(context);
            } else {
              AlertBox.showAlert(
                  context,
                  Text(
                    Strings.areYouSureToClose,
                    style: Styles.normalText(context: context,isBold: true),
                  ), () {
                SystemNavigator.pop();
              });
            }
          },
        ),
        const Spacer(),
        IconButton(
          icon: Image.asset(ImagePaths.themeChanger),
          onPressed: () {
            showThemeSelectionDialog(context, ref);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
