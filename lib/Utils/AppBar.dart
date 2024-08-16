import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Themepopup.dart';
import 'Themeprovider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final WidgetRef ref;

  CustomAppBar({required this.ref});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Image.asset('assets/logo.png'), // Replace with your logo image
          onPressed: () {
            _showDialog(context);
          },
        ),
        Spacer(),
        IconButton(
          icon: Image.asset('assets/theme.png'),
          onPressed: () {
            showThemeSelectionDialog(context, ref);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
          content: Container(
            constraints: BoxConstraints(maxWidth: 300, maxHeight: 300), // Define a max width and height to keep it square-like
            child: Column(
            //  crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you surely to close the application',
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20), // Add space between text and buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text(
                        'DECLINE',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black, // Color of the text and icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0), // No border radius to keep the button square
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                       // logout();
                      },
                      child: Text('CONFIRM'),
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
