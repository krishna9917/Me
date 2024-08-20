import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
              showBackButton ? ImagePaths.backBtn : ImagePaths.logo),
          // Replace with your logo image
          onPressed: () {
            if (showBackButton) {
              Navigator.pop(context);
            } else {
              _showDialog(context);
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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
            // Define a max width and height to keep it square-like
            child: Column(
              //  crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Strings.areYouSureToClose,
                  style: Styles.normalText(isBold: true),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 20),
                // Add space between text and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        Strings.decline.toUpperCase(),
                        style:
                            Styles.normalText(isBold: true, color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        // Color of the text and icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              0), // No border radius to keep the button square
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        // logout();
                      },
                      child: Text(
                        Strings.confirm.toUpperCase(),
                        style: Styles.normalText(isBold: true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Square corners
          ),
        );
      },
    );
  }
}
