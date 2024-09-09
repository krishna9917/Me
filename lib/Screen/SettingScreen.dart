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
import '../Utils/AppTheme.dart';
import 'ChangePassword.dart';
import 'LoginScreen.dart';
import 'NotificationScreen.dart';

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
    final appColors = Theme.of(context).extension<AppColors>()!;
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
                                Text("Username: ${user.userData?.name}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: appColors.color4)),
                                Text("MemberId: ${user.userData?.uniqueId}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: appColors.color4)),
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
            Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(
                      "Wallet",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "See amount add and deduct from your wallet",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
                    onTap: () {
                      WalletScreen().launch(context);
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(
                      "Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "See/Edit your profile detail",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
                    onTap: () {
                      ProfileScreen().launch(context);
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(
                      "Change Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "Change password of your account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
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
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text("See important notification history",
                        style: Theme.of(context).textTheme.headlineMedium),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
                    onTap: () {
                      NotificationScreen().launch(context);
                    },
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(
                      "Privacy Policy",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "Know your privacy policy",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
                    onTap: () => _launchPrivacyPolicyURL(),
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: 60,
                  child: ListTile(
                    title: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "Logout your account",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: appColors.color2,
                      size: 18,
                    ),
                    onTap: () {
                      AlertBox.showAlert(
                          context,
                          Text(
                            Strings.logoutWarning,
                            style: Styles.normalText(
                                context: context, isBold: true),
                          ), () {
                        logout();
                      });
                    },
                  ),
                ),
              ],
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
