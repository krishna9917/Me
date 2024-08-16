import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Model/LoginData.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/LoginModel.dart';
import '../Model/UpdateLogin.dart';
import '../Services/Service_Api.dart';
import '../Utils/Bottom_navigation.dart';
import '../Utils/Colors.dart';
import '../Utils/Images.dart';
import 'ChangePassword.dart';
import 'LoginScreen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool isLoading = false;
  var userdata;

  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future<void> checkLoginStatus() async {
    var userLoginData = await LoginData.getData();
    if (userLoginData != null) {
      setState(() {
        isLoading = true;
      });
      LoginData? data = await ApiInterface.userDetails(context);
      if (data!.status == 1) {
        if (data.userData!.isFirstTimeLogin == 1) {
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
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.clear();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, checkLoginStatus);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.black),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'assets/logo.png',
                          // Replace with your actual file path
                          gaplessPlayback: true, // Ensures smooth playback
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
