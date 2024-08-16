import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Screen/ChangePassword.dart';
import 'package:me_app/Screen/WalletScreen.dart';
import 'package:me_app/Screen/NotificationScreen.dart';
import 'package:me_app/Screen/ProfileScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/AppBar.dart';
import 'LoginScreen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  Future<void> logout() async {
    // Clear user session data from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data'); // Replace with your actual key if needed
    await prefs.setBool('isFirstLogin', true);
      LoginScreen().launch(context);
    // Navigate to login screen
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginScreen()), // Replace with your login screen widget
    // );
  }

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
                        logout(); // Close the dialog
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


  void _launchPrivacyPolicyURL() async {
    final Uri url = Uri.parse('https://www.onlinetradelearn.com/privacy-policy/');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(ref: ref),  // Pass ref here
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: 400,
              child: Card(
                color: Colors.black,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 200,
                    ),
                    Positioned(
                      bottom: 3, // Distance from the bottom
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Username: Mayank Demo",
                                style: TextStyle(color: Colors.amber.shade800),
                              ),
                              Text(
                                "MemberId: Otl9384",
                                style: TextStyle(color: Colors.amber.shade800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color:Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Wallet",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "See amount add and deduct from your wallet",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color:Colors.black),
                      onTap: () {
                        WalletScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Profile",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,),
                      ),
                      subtitle: Text(
                        "See/Edit your profile detail",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color:Colors.black),
                      onTap: () {
                        ProfileScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Change Password",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "Change password of your account",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color:Colors.black),
                      onTap: () {
                        Changepassword().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Notification",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "See important notification history",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15, color:Colors.black),
                      onTap: () {
                        //NotificationScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Privacy Policy",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "Know your privacy policy",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color:Colors.black),
                      onTap: () =>_launchPrivacyPolicyURL(),

                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height:60,
                    child: ListTile(
                      title: Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        "Logout your account",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18, color:Colors.black),
                      onTap: (){  _showDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
