// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:jwt_decoder/jwt_decoder.dart';
//
// // Notification Model
// class NotificationModel {
//   final String rider;
//   final String message;
//   final DateTime createdAt;
//   final Uint8List? imageData;
//   final String id;
//   final String requestId;
//
//   NotificationModel({
//     required this.rider,
//     required this.message,
//     required this.createdAt,
//     this.imageData,
//     required this.id,
//     required this.requestId
//   });
//
//   factory NotificationModel.fromJson(Map<String, dynamic> json) {
//     return NotificationModel(
//       rider: json['rider'],
//       message: json['message'],
//       createdAt: DateTime.parse(json['createdAt']),
//       imageData: json['image'] != null ? base64Decode(json['image']) : null,
//       id: json['_id'],
//       requestId: json['requestid'],
//     );
//   }
// }
//
// Future<List<NotificationModel>> fetchNotifications(String username) async {
//   final response = await http
//       .get(Uri.parse('http://192.168.1.66:5000/notifications/$username'));
//
//   if (response.statusCode == 200) {
//     // Use 200 for successful GET requests
//     List<dynamic> data = json.decode(response.body)['notifications'];
//     return data.map((item) => NotificationModel.fromJson(item)).toList();
//   } else {
//     throw Exception(
//         'Failed to load notifications. Status code: ${response.statusCode}');
//   }
// }
//
// // Notifications Page
// class NotificationsPage extends StatefulWidget {
//   final token;
//
//   NotificationsPage({required this.token});
//
//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }
//
// class _NotificationsPageState extends State<NotificationsPage> {
//   late Future<List<NotificationModel>> _notifications;
//   late String username;
//   late String phone;
//   final Map<String, Uint8List?> _imageCache = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _initialize();
//   }
//
//   void _initialize() {
//     Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
//     username = jwtDecodedToken['username'];
//     phone = jwtDecodedToken['phone'];
//     _notifications = fetchNotifications(username);
//   }
//
//   void _acceptRideRequest(NotificationModel notification) async {
//     final String url = 'http://192.168.1.66:5000';
//
//     Map<String, dynamic> data = {
//       'username': username,
//       'phone': phone,
//       'requestId': notification.requestId,
//       'notificationId': notification.id,
//     };
//
//     final response = await http.post(
//       Uri.parse('http://192.168.1.66:5000/acceptride'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(data),
//     );
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Ride request has been accepted')),
//       );
//       // Optionally refresh notifications after acceptance
//       setState(() {
//         _notifications = fetchNotifications(username);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to accept ride request')),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(34, 207, 249, 1),
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(248, 248, 251, 1),
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(25),
//               topRight: Radius.circular(25),
//             ),
//           ),
//           child: FutureBuilder<List<NotificationModel>>(
//             future: _notifications,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return Center(child: Text('No notifications'));
//               } else {
//                 final notifications = snapshot.data!;
//                 return Column(
//                   children: [
//                     SizedBox(height: 15,),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: notifications.length,
//                         itemBuilder: (context, index) {
//                           final notification = notifications[index];
//                           final imageData = notification.imageData;
//                           final timeAgo = DateTime.now()
//                               .difference(notification.createdAt)
//                               .inMinutes;
//
//                           return Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () {
//                                 showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return AlertDialog(
//                                       title: Text('Confirm Action'),
//                                       content: Text('Do you want to accept this ride request?'),
//                                       actions: [
//                                         TextButton(
//                                           child: Text('Cancel'),
//                                           onPressed: () {
//                                             Navigator.of(context).pop(); // Close the dialog
//                                           },
//                                         ),
//                                         TextButton(
//                                           child: Text('OK'),
//                                           onPressed: () {
//                                             Navigator.of(context).pop(); // Close the dialog
//                                             _acceptRideRequest(notification); // Call the method
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 );
//                               },
//                               splashColor: Colors.grey.withOpacity(0.2),
//                               highlightColor: Colors.grey.withOpacity(0.1),
//                               child: Padding(
//                                 padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
//                                 child: Row(
//                                   children: [
//                                     if (imageData != null)
//                                       CircleAvatar(
//                                         backgroundImage: MemoryImage(imageData),
//                                         radius: 30,
//                                       )
//                                     else
//                                       CircleAvatar(
//                                         radius: 30,
//                                         child: Icon(Icons.person),
//                                       ),
//                                     SizedBox(width: 16),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'New Ride Request', // Example text, you can adjust this
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15,
//                                                 fontFamily: 'Futura'
//                                             ),
//                                           ),
//                                           SizedBox(height: 4),
//                                           Text(
//                                             notification.message,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.grey[600],
//                                               fontFamily: 'Futura',
//                                             ),
//                                           ),
//                                           SizedBox(height: 4),
//                                           Text(
//                                             '$timeAgo mins ago',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                               color: Colors.grey[500],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 );
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }