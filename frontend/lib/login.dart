import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:yeti_yatra_project/signup.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeti_yatra_project/SignUpDemo.dart';
import 'package:yeti_yatra_project/test/afterLogin.dart';
import 'package:yeti_yatra_project/test/profile.dart';
import 'main_scaffold.dart';
import 'test/navtest.dart';
import 'HistoryScreen/GlobalUrl.dart';

class MyLoginApp extends StatelessWidget {
  const MyLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  late SharedPreferences prefs;

  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _loginInfo() async {
    final String url = Global.url;

    if (_formkey.currentState?.validate() ?? false) {
      String username = _username.text;
      String password = _password.text;

      Map<String, dynamic> data = {
        'username': username,
        'password': password,
      };

      try {
        final response = await http.post(
          Uri.parse('$url/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

        // Check if the 'status' key exists and is a boolean
        if (jsonResponse.containsKey('status') &&
            jsonResponse['status'] is bool) {
          if (jsonResponse['status']) {
            var myToken = jsonResponse['token'];
            prefs.setString('token', myToken);
            // Get.to(
            //   () => ProfileState(token: myToken),
            //   transition: Transition.rightToLeft,
            //   duration: const Duration(milliseconds: 500),
            // );
            Get.to(
              () => MainScaffold(token: myToken,),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500),
            );
          } else {
            print('Login failed: ${jsonResponse['message']}');
          }
        } else {
          throw Exception('Invalid response format: ${jsonResponse}');
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('${error}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 248, 251, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
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
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.077,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.0001),
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.111,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.025,
                  alignment: Alignment.center,
                  child: Text(
                    'Please enter your username and password',
                    style: TextStyle(
                      fontSize: screenWidth * 0.0315,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.495,
                  margin: EdgeInsets.only(left: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(fontFamily: 'Futura'),
                      ),
                      SizedBox(height: screenHeight * 0.014),
                      SizedBox(
                        width: screenWidth * 0.9,
                        // height: (screenHeight * 0.5) * 0.1,
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
                            fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 5),
                          ),
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
                              return 'Not a valid password';
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
                              _loginInfo();
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(fontFamily: 'Futura'),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(34, 207, 249, 1),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
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
                              'Dont have an account yet? ',
                              style: TextStyle(
                                fontFamily: 'Futura',
                                color: Color.fromRGBO(34, 207, 249, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => SignUp(),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 500),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Futura',
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      Color.fromRGBO(34, 207, 249, 1),
                                ),
                              ),
                            )
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
