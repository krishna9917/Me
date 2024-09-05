import 'package:flutter/material.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Screen/HomeScreen.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import '../Utils/AppTheme.dart';
import '../Utils/Colors.dart';

class ChangePassword extends StatefulWidget {
  final bool isComingFromAccount;

  // Constructor
  ChangePassword({Key? key, required this.isComingFromAccount})
      : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  String? opw, npw;
  bool isLoading = false;

  changePassword() async {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      setState(() {
        isLoading = true;
      });
      StatusMessage? response =
          await ApiInterface.changePassword(context, npw!, opw!);
      if (response!.status == 1) {
        HelperFunction.showMessage(context, response.message.toString(),
            type: 2);
        if (widget.isComingFromAccount) {
          Navigator.pop(context);
        } else {
          HomeScreen().launch(context, isNewTask: true);
        }
      } else {
        HelperFunction.showMessage(context, response.message!, type: 3);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.changePassword),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    const Center(
                      child: Icon(
                        Icons.account_circle,
                        size: 100,
                      ),
                    ),
                    15.height,
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: Strings.existingPassword,
                          hintStyle: Theme.of(context).textTheme.titleLarge,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 1.0),
                          ),
                        ),
                        style: Theme.of(context).textTheme.headlineLarge,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Strings.existingPasswordRequired;
                          }
                          if (value.trim().length < 3) {
                            return Strings.passwordMustBeValid;
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: Strings.newPassword,
                          hintStyle: Theme.of(context).textTheme.titleLarge,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 1.0),
                          ),
                        ),
                        style: Theme.of(context).textTheme.headlineLarge,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Strings.newPasswordRequired;
                          }
                          if (value.trim().length < 6) {
                            return Strings.passwordMustBeValid;
                          }
                          return null;
                        },
                        onChanged: (value) => npw = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: Strings.confirmPassword,
                          hintStyle: Theme.of(context).textTheme.titleLarge,
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: appColors.color2!, width: 1.0),
                          ),
                        ),
                        style: Theme.of(context).textTheme.headlineLarge,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return Strings.confirmPasswordRequired;
                          }
                          if (value.trim().length < 6) {
                            return Strings.passwordMustBeValid;
                          }
                          if (value.trim() != npw?.trim()) {
                            return Strings.passwordDoNotMatch;
                          }
                          return null;
                        },
                        onChanged: (value) => npw = value,
                      ),
                    ),
                    SizedBox(
                      width: 380,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton(
                          onPressed: () {
                            changePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: goldenn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white))
                              : Text(
                                  Strings.updatePassword,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
