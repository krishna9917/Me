import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Resources/ImagePaths.dart';
import '../Resources/Strings.dart';
import '../Utils/Bottom_navigation.dart';
import '../Utils/Colors.dart';
import 'ChangePassword.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? username;
  String? password;
  bool _isObscure = true;
  String? pswd;
  var userdata;
  bool _showErrorIcon = false;

  Future<void> login() async {
    setState(() {
      isLoading = true;
      _showErrorIcon = true;
    });
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      if (username != null && pswd != null) {
        LoginData? loginResponse =
        await ApiInterface.login(context, username!, pswd!);
        if (loginResponse?.status == 1) {
          LoginData.saveData(loginResponse!);
          if (loginResponse.userData!.isFirstTimeLogin == 1) {
            ChangePassword(
              isComingFromAccount: false,
            ).launch(context, isNewTask: true);
          } else {
            Bottom_Navigation().launch(context, isNewTask: true);
          }
        } else {
          HelperFunction.showMessage(context, loginResponse?.message ?? "",
              type: 3);
        }
      } else {
        HelperFunction.showMessage(context, "Username or password cannot be null",
            type: 3);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _requestNotificationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: Image.asset(
                        ImagePaths.appLogo,
                        height: 250,
                        width: 250,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // User ID input field
                            Stack(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    suffixIcon: _showErrorIcon &&
                                        _formKey.currentState?.validate() !=
                                            true
                                        ? const Icon(Icons.error,
                                        color: Colors.red)
                                        : null,
                                    contentPadding:
                                    const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                                    hintText: 'Enter your user id',
                                    hintStyle: Styles.normalText(
                                        context: context, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: _showErrorIcon &&
                                            _formKey.currentState
                                                ?.validate() !=
                                                true
                                            ? Colors.red
                                            : Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 2.0),
                                    ),
                                  ),
                                  style: Styles.normalText(
                                      context: context, color: Colors.white),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter your user ID';
                                    }
                                    if (value.trim().length < 3) {
                                      return 'User ID must be at least 3 characters long';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    username = value;
                                    if (_showErrorIcon) {
                                      _formKey.currentState?.validate();
                                    }
                                  },
                                ),
                                Positioned(
                                  left: 12,
                                  top: 4,
                                  child: Text(
                                    Strings.userId,
                                    style: Styles.normalText(
                                      context: context,
                                      color: Colors.amber,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            // Password input field
                            Stack(
                              children: [
                                TextFormField(
                                  obscureText: _isObscure,
                                  decoration: InputDecoration(
                                    suffixIcon: _showErrorIcon &&
                                        _formKey.currentState?.validate() !=
                                            true
                                        ? const Icon(Icons.error,
                                        color: Colors.red)
                                        : IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure = !_isObscure;
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10.0, 20.0, 10.0, 20.0),
                                    hintText: Strings.enterYourPassword,
                                    hintStyle: Styles.normalText(
                                        context: context, color: Colors.white),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                        color: _showErrorIcon &&
                                            _formKey.currentState
                                                ?.validate() !=
                                                true
                                            ? Colors.red
                                            : Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  style: Styles.normalText(
                                      context: context, color: Colors.white),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return Strings.pleaseEnterPassword;
                                    }
                                    if (value.trim().length < 3) {
                                      return Strings.passwordMustBeValid;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    pswd = value;
                                    if (_showErrorIcon) {
                                      _formKey.currentState?.validate();
                                    }
                                  },
                                ),
                                Positioned(
                                  left: 12,
                                  top: 4,
                                  child: Text(
                                    Strings.password,
                                    style: Styles.normalText(
                                      context: context,
                                      color: Colors.amber,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40),
                            Center(
                              child: SizedBox(
                                height: 45,
                                width: 500,
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: goldenn,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                          Colors.white))
                                      : Text(
                                    Strings.login,
                                    style: Styles.normalText(
                                        context: context,
                                        isBold: true,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              Strings.termsConditions,
                              style: Styles.normalText(
                                  context: context,
                                  isBold: true,
                                  color: Colors.white,
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }
}
