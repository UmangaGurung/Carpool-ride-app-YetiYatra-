import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yeti_yatra_project/HistoryScreen/GlobalUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeti_yatra_project/welcome.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HistoryScreen/GlobalUrl.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  String username;
  String phone;
  Uint8List imageData;

  EditProfile(
      {required this.username, required this.phone, required this.imageData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _username.text = widget.username;
    _phone.text = widget.phone;
  }

  Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');

    final String url = Global.url;

    if (authToken != null) {
      try {
        await prefs.remove('token');
        final response = await http.post(
          Uri.parse('$url/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );

        if (response.statusCode == 200) {
          print('Token removed and invalidated successfully.');
          return true;
        } else {
          print('Failed to invalidate the token: ${response.statusCode}');
          return false;
        }
      } catch (error) {
        print('Error occurred during token removal: $error');
        return false;
      }
    } else {
      print('No token found in local storage.');
      return false;
    }
  }

  void update() async {
    final String url = Global.url;

    if (_formKey.currentState?.validate() ?? false) {
      String oldUsername = widget.username;
      String newUsername = _username.text;
      String newPhone = _phone.text;

      Map<String, dynamic> data = {
        'olduser': oldUsername,
        'username': newUsername,
        'phone': newPhone,
      };

      try {
        final response = await http.post(
          Uri.parse('$url/edit'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          await removeToken();

          print('Navigation to CardWidget triggered.');
        } else {
          print('Failed to update profile: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile.')),
          );
        }
      } catch (error) {
        print('Error updating profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error updating profile. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 207, 249, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          leading: IconButton(
            padding: EdgeInsets.only(top: screenHeight * 0.043, left: screenWidth * 0.05),
            icon: const Icon(
              Icons.arrow_circle_left_rounded,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.045),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              height: screenHeight * 0.841,
              width: screenWidth,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color.fromRGBO(248, 248, 251, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: screenHeight * 0.03),
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.17,
                          backgroundColor: Color.fromRGBO(248, 248, 251, 1),
                          child: ClipOval(
                            child: Image.memory(
                              widget.imageData,
                              fit: BoxFit.cover,
                              height: screenHeight * 0.9,
                              width: screenWidth * 0.9,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.04),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              Text(
                                widget.username,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w800,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              Text(widget.phone),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Container(
                    width: screenWidth,
                    height: screenHeight * 0.35,
                    margin: EdgeInsets.only(left: screenWidth * 0.05),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.014),
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
                              fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.025,
                        ),
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.014),
                        SizedBox(
                          width: screenWidth * 0.9,
                          // height: (screenHeight * 0.5) * 0.1,
                          child: TextFormField(
                            controller: _phone,
                            validator: (value) {
                              RegExp regExp = RegExp(r'^[0-9]+$');
                              if (value == null || value.isEmpty) {
                                return 'Please enter a phone number';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Invalid Format';
                              } else if (value.length < 10) {
                                return 'Phone number must be at least 10 characters long';
                              }

                              return null;
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
                        SizedBox(
                          height: screenHeight * 0.04,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.57,
                    height: (screenHeight * 0.6) * 0.1,
                    child: ElevatedButton(
                      onPressed: () {
                        update();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: AlertDialog(
                                title: Text('Values Updated'),
                                content: Text('You must login again.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close dialog
                                      // Navigate to CardWidget
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => CardWidget(),
                                      //   ),
                                      // );
                                      Get.offAll(
                                            () => CardWidget(),
                                        transition: Transition.zoom,
                                        duration: const Duration(milliseconds: 500),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Update',
                        style: TextStyle(fontFamily: 'Poppins'),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(34, 207, 249, 1),
                        ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
