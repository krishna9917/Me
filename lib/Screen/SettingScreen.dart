import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Dialogs/AlertBox.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Screen/WalletScreen.dart';
import 'package:me_app/Screen/ProfileScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Resources/Strings.dart';
import '../Utils/AppBar.dart';
import 'ChangePassword.dart';
import 'LoginScreen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  LoginData user = LoginData();

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    LoginScreen().launch(context);
  }

  void _launchPrivacyPolicyURL() async {
    final Uri url =
        Uri.parse('https://www.onlinetradelearn.com/privacy-policy/');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(ref: ref), // Pass ref here
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 280,
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Image.asset(
                        ImagePaths.appLogo,
                        height: 200,
                      ),
                      Positioned(
                        bottom: 25, // Distance from the bottom
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Username: ${user.userData?.name}",
                                  style: Styles.normalText(context: context,
                                      isBold: true,
                                      color: Colors.amber.shade800),
                                ),
                                Text(
                                  "MemberId: ${user.userData?.uniqueId}",
                                  style: Styles.normalText(context: context,
                                      isBold: true,
                                      color: Colors.amber.shade800),
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
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "Wallet",
                        style: Styles.normalText(context: context,isBold: true),
                      ),
                      subtitle: Text(
                        "See amount add and deduct from your wallet",
                        style: Styles.normalText(context: context,fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                      onTap: () {
                        WalletScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "Profile",
                        style: Styles.normalText(context: context,isBold: true),
                      ),
                      subtitle: Text(
                        "See/Edit your profile detail",
                        style: Styles.normalText(context: context,fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                      onTap: () {
                        ProfileScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "Change Password",
                        style: Styles.normalText(context: context,isBold: true),
                      ),
                      subtitle: Text(
                        "Change password of your account",
                        style: Styles.normalText(context: context,fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                      onTap: () {
                        ChangePassword(
                          isComingFromAccount: true,
                        ).launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text("Notification",
                          style: Styles.normalText(context: context,isBold: true)),
                      subtitle: Text("See important notification history",
                          style: Styles.normalText(context: context,fontSize: 12)),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 15, color: Colors.black),
                      onTap: () {
                        //NotificationScreen().launch(context);
                      },
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "Privacy Policy",
                        style: Styles.normalText(context: context,isBold: true),
                      ),
                      subtitle: Text(
                        "Know your privacy policy",
                        style: Styles.normalText(context: context,fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                      onTap: () => _launchPrivacyPolicyURL(),
                    ),
                  ),
                  const Divider(),
                  SizedBox(
                    height: 60,
                    child: ListTile(
                      title: Text(
                        "Logout",
                        style: Styles.normalText(context: context,isBold: true),
                      ),
                      subtitle: Text(
                        "Logout your account",
                        style: Styles.normalText(context: context,fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                      onTap: () {
                        AlertBox.showAlert(
                            context,
                            Text(
                              Strings.logoutWarning,
                              style: Styles.normalText(context: context,isBold: true),
                            ), () {
                          logout();
                        });
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

  Future<void> getUserData() async {
    user = (await LoginData.getData())!;
    setState(() {});
  }
}
