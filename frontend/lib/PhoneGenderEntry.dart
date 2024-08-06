import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'userImage.dart'; // Import as needed
import 'package:yeti_yatra_project/login.dart';
import 'package:yeti_yatra_project/userImage.dart';

class PhoneGenderEntry extends StatefulWidget {
  final String username;
  final String password;

  PhoneGenderEntry({required this.username, required this.password});

  @override
  _PhoneGenderEntryState createState() => _PhoneGenderEntryState();
}

class _PhoneGenderEntryState extends State<PhoneGenderEntry> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();
  String? _selectGender;
  List<String> gender = ['Male', 'Female'];

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submitForm() async {
    String username = widget.username;
    String password = widget.password;
    String phone = _phone.text;
    String gender = _selectGender ?? 'Not Specified';
    // print('Username: $username, Password: $password, Phone: $phone, Gender: $gender');

    Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'phone': phone,
      'gender': gender,
    };

    if (_formKey.currentState?.validate() ?? false) {
      Get.to(
            () => ImagePage(data: data),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 500),
      );
    }

    // try {
    //   final response = await http.post(
    //     Uri.parse('$url/register'),
    //     headers: {'Content-Type': 'application/json'},
    //     body: jsonEncode(data),
    //   );
    //
    //   if (response.statusCode == 201) {
    //     // Get.to(
    //     //       () => Login(),
    //     //   transition: Transition.rightToLeft,
    //     //   duration: Duration(milliseconds: 500),
    //     // );
    //     Get.to(
    //           () => ImagePage(
    //
    //           ),
    //       transition: Transition.rightToLeft,
    //       duration: Duration(milliseconds: 500),
    //     );
    //   } else {
    //     throw Exception(
    //         'Failed to send data: ${response.statusCode} ${response.body}');
    //   }
    // } catch (error) {
    //   throw Exception('Error sending data: $error');
    // }
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
                        'Phone Number',
                        style: TextStyle(fontFamily: 'Futura'),
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
                      SizedBox(height: screenHeight * 0.025),
                      Text(
                        'Gender',
                        style: TextStyle(fontFamily: 'Futura'),
                      ),
                      SizedBox(
                        height: screenHeight * 0.014,
                      ),
                      SizedBox(
                        width: screenWidth * 0.9,
                        child: DropdownButtonFormField<String>(
                          dropdownColor: Color.fromRGBO(255, 255, 255, 1.0),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12.0), // Adjust padding
                          ),
                          value: _selectGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectGender = newValue.toString();
                            });
                          },
                          items: gender.map((valueItem) {
                            return DropdownMenuItem<String>(
                              value: valueItem,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  valueItem,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    height: 1.2, // Line height
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a gender';
                            }
                          },
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
