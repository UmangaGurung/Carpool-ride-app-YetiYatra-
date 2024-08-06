import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'userImage.dart';
import 'PhoneGenderEntry.dart';
import 'package:yeti_yatra_project/login.dart';

void main() {
  runApp(MySignUpApp());
}

class MySignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      String username = _username.text;
      String password = _password.text;

      Get.to(
            () => PhoneGenderEntry(
          username: username,
          password: password,
        ),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 251, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.4,
                    backgroundColor: Color.fromRGBO(248, 248, 251, 1),
                    child: ClipOval(
                      child: Image.asset(
                        'images/yeticon.png',
                        fit: BoxFit.cover,
                        height: screenHeight * 0.9,
                        width: screenWidth * 0.9,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.077,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.0001),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.111,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.025,
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Please set your user information',
                    style: TextStyle(
                      fontSize: screenWidth * 0.0315,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.495,
                  margin: EdgeInsets.only(left: screenWidth * 0.05),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Futura',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.014),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              width: screenWidth * 0.9,
                              child: TextFormField(
                                controller: _username,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a username';
                                  } else if (value!.length < 4) {
                                    return 'Username should be more than 3 characters';
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                  Color.fromRGBO(255, 255, 255, 1.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Password',
                        style: TextStyle(fontFamily: 'Futura'),
                      ),
                      SizedBox(height: screenHeight * 0.014),
                      SizedBox(
                        width: screenWidth * 0.9,
                        // height: (screenHeight * 0.5) * 0.1,
                        child: TextFormField(
                          controller: _password,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            } else if (value!.length < 8) {
                              return 'Password must atleast be 8 characters long';
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            EdgeInsets.only(left: 10, bottom: 5),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.055),
                      Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          height: (screenHeight * 0.539) * 0.12,
                          width: screenWidth * 0.5,
                          child: ElevatedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            child: Text(
                              'NEXT',
                              style: TextStyle(fontFamily: 'Futura'),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(34, 207, 249, 1),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.0079),
                        height: screenHeight * 0.03,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Futura',
                                color: Color.fromRGBO(34, 207, 249, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Login(),
                                //   ),
                                // );
                                Get.to(
                                      () => Login(),
                                  transition: Transition.rightToLeft,
                                  duration: Duration(milliseconds: 500),
                                );
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontFamily: 'Futura',
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                  Color.fromRGBO(34, 207, 249, 1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
