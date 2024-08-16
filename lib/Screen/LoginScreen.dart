import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/LoginModel.dart';
import '../Model/UpdateLogin.dart';
import '../Resources/Strings.dart';
import '../Services/Service_Api.dart';
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
  String? pswd;
  var userdata;
  bool _showErrorIcon = false; // Track if the form was submitted

  Future<void> login() async {
    setState(() {
      isLoading = true;
      _showErrorIcon = true;
    });
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      LoginData? loginResponse =
          await ApiInterface.login(context, username!, pswd!);
      if (loginResponse?.status == 1) {
        LoginData.saveData(loginResponse!);
        if (loginResponse.userData!.isFirstTimeLogin == 1)
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Changepassword()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Bottom_Navigation()),
          );
        }
      } else {
        HelperFunction.showMessage(context, loginResponse!.message!, type: 3);
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  40.height,
                  Center(
                    child:
                        Image.asset('assets/logo.png', height: 250, width: 250),
                  ),
                  0.height,
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25, top: 20, bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 20.0),
                                  hintText: 'Enter your user id',
                                  hintStyle: Styles.normalText(),
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
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                ),
                                style: TextStyle(color: Colors.white),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '';
                                  }
                                  if (value.trim().length < 3) {
                                    return '';
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
                              const Positioned(
                                left: 12,
                                top: 4,
                                child: Text(
                                  'User ID',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          20.height,
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
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      10.0, 20.0, 10.0, 20.0),
                                  hintText: 'Enter your password',
                                  hintStyle: Styles.normalText(),
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
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                ),
                                style: Styles.normalText(),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '';
                                  }
                                  if (value.trim().length < 3) {
                                    return '';
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
                              const Positioned(
                                left: 12,
                                top: 4,
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          10.height,
                          Center(
                            child: SizedBox(
                              height: 45,
                              width: 500,
                              child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
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
                                                goldenn))
                                    : const Text(
                                        "Log in",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 14),
                                      ),
                              ),
                            ),
                          ),
                          10.height,
                          Text(
                              'No real money involved. This is a virtual trading \napplication with all features to trade.',
                              style:
                                  boldTextStyle(color: Colors.white, size: 10)),
                          10.height,
                          Text(
                              'This application is used for exchanging views on market\nfor training purposes only.',
                              style:
                                  boldTextStyle(color: Colors.white, size: 10)),
                          20.height,
                        ],
                      ),
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
