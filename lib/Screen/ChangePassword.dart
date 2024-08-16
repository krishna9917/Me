import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/ChangePasswordModel.dart';
import '../Services/Service_Api.dart';
import '../Utils/Bottom_navigation.dart';
import '../Utils/Colors.dart';

class Changepassword extends StatefulWidget {
  @override
  _ChangepasswordState createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final _formKey = GlobalKey<FormState>();

  String? opw, npw, userID = "145"; // Default userID

  bool _obscureText = true;
  bool isLoading = false;

  changePassword() async {
    setState(() {
      isLoading = true;
    });

    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // Ensure non-null values for the data map
      var data = {
        'userID': '145',
        'opw': opw ?? '',  // Provide a default empty string if opw is null
        'npw': npw ?? '',  // Provide a default empty string if npw is null
      };

      try {
        // final loginModel = loginModelFromJson(stdata);
        // final token = loginModel.token;
        //
        // if (token != null && token.isNotEmpty) {
        var responseData = await ServicesApi().sendPostRequest(
          url: 'https://www.onlinetradelearn.com/mcx/authController/changePassword',
          data: data,
          token: 'VStzSlVUZWovWnl1eElrUFM1Z3o1RlphV3YzNlYvbVRPVjRFWExaNFlWV1d3d'
              'jdLSzd2UmI2R2RrQWp1ZnVyYnlkbHRqaDE5Uk9ubHU5K0xsS3N4WTBsRWRzR01QZzNsRzZzME5LSVRkQ0E9',
        );
        print("responseData:$responseData");
        if (responseData != null && responseData.isNotEmpty) {
          var changepasswordd = changePasswordModelFromJson(responseData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 200.0),
              elevation: 6,
              content: Text('Change Password Successful'),
              duration: Duration(seconds: 2),
            ),
          );
          Bottom_Navigation().launch(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(bottom: 300.0),
              elevation: 6,
              content: Text('Incorrect password.', style: TextStyle(color: Colors.black)),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.white,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 300.0),
            elevation: 6,
            content: Text('An error occurred. Please try again.', style: TextStyle(color: Colors.black)),
            duration: Duration(seconds: 3),
          ),
        );
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Change Password', style: TextStyle(color: Colors.white)),
      ),
      body:  isLoading
          ? Center(
        child: Image.asset('assets/loader.png'),
      )
          :Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Icon(Icons.account_circle, size: 80, color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Existing Password',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          if (value.trim().length < 3) {
                            return 'Password must be at least 6 characters in length';
                          }
                          return null;
                        },
                        onChanged: (value) => userID = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters in length';
                          }
                          return null;
                        },
                        onChanged: (value) => opw = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: Colors.white),
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'This field is required';
                          }
                          if (value.trim().length < 6) {
                            return 'Password must be at least 6 characters in length';
                          }
                          if (value.trim() != npw?.trim()) {
                            return 'Passwords do not match';
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
                            print("button is pressed");
                            changePassword();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: goldenn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: Text("UPDATE PASSWORD"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
