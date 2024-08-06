import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:yeti_yatra_project/test/signup.dart';
import 'package:yeti_yatra_project/login.dart';
import 'package:get/get.dart';
import 'package:yeti_yatra_project/SignUpDemo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeti_yatra_project/test/afterLogin.dart';
import 'package:yeti_yatra_project/welcome.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yeti_yatra_project/editprofile.dart';
import 'package:yeti_yatra_project/changepassword.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    Profile(
      token: prefs.getString('token'),
    ),
  );
}

class Profile extends StatelessWidget {
  final token;
  const Profile({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null ? ProfileState(token: token) : CardWidget(),
    );
  }
}

class ProfileState extends StatefulWidget {
  final token;
  const ProfileState({@required this.token, Key? key}) : super(key: key);

  @override
  State<ProfileState> createState() => _ProfileStateState();
}

class _ProfileStateState extends State<ProfileState> {
  late String username;
  late String phone;
  late Uint8List imageData = Uint8List(0);

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initialize() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
    phone = jwtDecodedToken['phone'];
    String imageBase64 = jwtDecodedToken['image'];

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      imageData = base64Decode(imageBase64);
    } else {
      // Default image if none provided
      // Example: AssetImage('images/default_image.png')
      // or display a placeholder image
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 207, 249, 1),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.13),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          title: Text(
            'User Profile',
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.827,
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
                            imageData,
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
                              '$username',
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
                            Text('$phone'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  // margin: EdgeInsets.only(left: screenHeight*0.03),
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(27),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(
                          'Edit Profile',
                          style: TextStyle(fontFamily: 'Futura'),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(
                            () => EditProfile(
                              username: username,
                              phone: phone,
                              imageData: imageData,
                            ),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        leading: Icon(Icons.lock),
                        title: Text(
                          'Change Password',
                          style: TextStyle(fontFamily: 'Futura'),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(
                            () => ChangePassword(
                              username: username,
                              phone: phone,
                              imageData: imageData,
                            ),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        leading: Icon(Icons.policy),
                        title: Text(
                          'Our Policies',
                          style: TextStyle(fontFamily: 'Futura'),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to policies screen
                        },
                      ),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                      ),
                      ListTile(
                        leading: Icon(Icons.help_outline),
                        title: Text(
                          'FAQs',
                          style: TextStyle(fontFamily: 'Futura'),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to FAQs screen
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                SizedBox(
                  width: screenWidth * 0.57,
                  height: (screenHeight * 0.6) * 0.1,
                  child: ElevatedButton(
                    onPressed: () async{
                      await removeToken();
                      Get.to(
                        () => CardWidget(),
                        transition: Transition.zoom,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: Text(
                      'LOGOUT',
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
    );
  }
}

Future<bool> removeToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? authToken = prefs.getString('token');

  final String url = 'http://192.168.1.67:5000';

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
