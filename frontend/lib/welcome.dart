// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// // import 'package:yeti_yatra_project/signup.dart';
// import 'package:yeti_yatra_project/login.dart';
// import 'package:get/get.dart';
// import 'package:yeti_yatra_project/SignUpDemo.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:yeti_yatra_project/test/afterLogin.dart';
// import 'package:yeti_yatra_project/test/profile.dart';
// import 'package:yeti_yatra_project/main_scaffold.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? token = prefs.getString('token'); // Use nullable type for token
//   runApp(
//     MyApp(
//       token: token, // Pass nullable token
//     ),
//   );
//   print(token);
// }
//
// class MyApp extends StatelessWidget {
//   final String? token; // Use nullable type for token
//   const MyApp({this.token, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: token != null && !JwtDecoder.isExpired(token!)
//           ? MainScaffold(token: token!) // Use token! to assert non-nullability
//           : CardWidget(), // Use CardWidget() when token is null or expired
//     );
//   }
// }
//
//
// class CardWidget extends StatefulWidget {
//   const CardWidget({Key? key}) : super(key: key);
//   @override
//   _CardWidgetState createState() => _CardWidgetState();
// }
//
// class _CardWidgetState extends State<CardWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(248, 248, 251, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 margin: EdgeInsets.only(top: screenHeight * 0.1),
//                 width: screenWidth,
//                 height: screenHeight * 0.4,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                 ),
//                 child: CircleAvatar(
//                   radius: screenWidth * 0.425,
//                   backgroundColor: Color.fromRGBO(248, 248, 251, 1),
//                   child: ClipOval(
//                     child: Image.asset(
//                       'images/yeticon.png',
//                       fit: BoxFit.cover,
//                       height: screenHeight * 0.9,
//                       width: screenWidth * 0.9,
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenWidth * 0.7,
//                 height: screenHeight * 0.07,
//                 alignment: Alignment.topCenter,
//                 child: Padding(
//                   padding: EdgeInsets.only(top: screenHeight * 0.0001),
//                   child: Text(
//                     'Welcome',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: screenWidth * 0.111,
//                         fontWeight: FontWeight.w900),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenWidth * 0.74,
//                 height: screenHeight * 0.04,
//                 alignment: Alignment.center,
//                 child: Text(
//                   'Welcome to YetiYatra, where drivers set destinations and dates, while users can request a ride.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: screenWidth * 0.03,
//                     fontFamily: 'Futura',
//                   ),
//                 ),
//               ),
//               Container(
//                 width: screenWidth * 0.6,
//                 height: screenWidth * 0.55,
//                 padding: EdgeInsets.only(bottom: screenHeight * 0.035),
//                 decoration: BoxDecoration(
//                     // color: Colors.blue,
//                     ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: screenWidth * 0.57,
//                       height: (screenHeight * 0.6) * 0.1,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Get.to(() => Login(),
//                               transition: Transition.zoom,
//                               duration: const Duration(milliseconds: 500));
//                         },
//                         child: Text(
//                           'LOGIN',
//                           style: TextStyle(fontFamily: 'Poppins'),
//                         ),
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                             Color.fromRGBO(34, 207, 249, 1),
//                           ),
//                           foregroundColor:
//                               MaterialStateProperty.all<Color>(Colors.white),
//                           shape: MaterialStateProperty.all(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     SizedBox(
//                       width: screenWidth * 0.57,
//                       height: (screenHeight * 0.6) * 0.1,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Get.to(() => SignUp(),
//                               transition: Transition.zoom,
//                               duration: const Duration(milliseconds: 500));
//                         },
//                         child: Text(
//                           'SIGN UP',
//                           style: TextStyle(fontFamily: 'Poppins'),
//                         ),
//                         style: ButtonStyle(
//                           foregroundColor: MaterialStatePropertyAll<Color>(
//                             Color.fromRGBO(34, 207, 249, 1),
//                           ),
//                           shape: MaterialStateProperty.all(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50),
//                               side: BorderSide(
//                                 color: Color.fromRGBO(34, 207, 249, 1),
//                                 width: 1,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// //   void _navigatetoSignUp() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => SignUp(),
// //       ),
// //     );
// //   }
// //
// //   void _navigatetoLogin() {
// //     Navigator.push(
// //       context,
// //       MaterialPageRoute(
// //         builder: (context) => Login(),
// //       ),
// //     );
// //   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeti_yatra_project/main_scaffold.dart';
import 'package:yeti_yatra_project/login.dart';
import 'package:yeti_yatra_project/SignUpDemo.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token'); // Use nullable type for token

  runApp(MyApp(token: token));
  // print('TOKEN DATA: $token');
}

class MyApp extends StatelessWidget {
  final String? token; // Nullable token

  const MyApp({this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
      publicKey: "test_public_key_3bcb7dbe844446fc8026153058226e93",
      enabledDebugging: true,
      builder: (context, navKey) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: token != null && !JwtDecoder.isExpired(token!)
              ? MainScaffold(token: token!) // Use token! to assert non-nullability
              : CardWidget(), // Use CardWidget() when token is null or expired
          navigatorKey: navKey,
          localizationsDelegates: const [
            KhaltiLocalizations.delegate
          ],
        );
      },
    );
  }
}

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 251, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.1),
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.425,
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
                  height: screenHeight * 0.07,
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.0001),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: screenWidth * 0.111,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.74,
                  height: screenHeight * 0.04,
                  alignment: Alignment.center,
                  child: Text(
                    'Welcome to YetiYatra, where drivers set destinations and dates, while users can request a ride.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      fontFamily: 'Futura',
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.55,
                  padding: EdgeInsets.only(bottom: screenHeight * 0.035),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.57,
                        height: (screenHeight * 0.6) * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => Login(),
                                transition: Transition.zoom,
                                duration: const Duration(milliseconds: 500));
                          },
                          child: Text(
                            'LOGIN',
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
                      SizedBox(height: 20),
                      SizedBox(
                        width: screenWidth * 0.57,
                        height: (screenHeight * 0.6) * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => SignUp(),
                                transition: Transition.zoom,
                                duration: const Duration(milliseconds: 500));
                          },
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(fontFamily: 'Poppins'),
                          ),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(34, 207, 249, 1),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                  width: 1,
                                ),
                              ),
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
      ),
    );
  }
}

