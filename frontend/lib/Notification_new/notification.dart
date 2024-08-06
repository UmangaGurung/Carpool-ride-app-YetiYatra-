import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import '../HistoryScreen/GlobalUrl.dart';
import 'package:yeti_yatra_project/main_scaffold.dart';


class NotificationModel {
  final String rider;
  final String message;
  final DateTime createdAt;
  final Uint8List? imageData;
  final String id;
  final String requestId;
  final bool payed;
  final bool accepted;
  final String scheduleid;
  final String phone;
  final String riderName;
  final String requester;

  NotificationModel(
      {required this.rider,
      required this.message,
      required this.createdAt,
      this.imageData,
      required this.id,
      required this.requestId,
      required this.payed,
      required this.accepted,
      required this.scheduleid,
      required this.phone,
      required this.riderName,
      required this.requester,});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        rider: json['rider'] ?? 'Unknown Rider', // Default value if null
        message: json['message'] ?? 'No message', // Default value if null
        createdAt: DateTime.parse(json['createdAt']),
        imageData: json['image'] != null ? base64Decode(json['image']) : null,
        id: json['_id'] ?? 'No ID', // Default value if null
        requestId: json['requestid'] ?? 'No Request ID',
        payed: json['payed'] ?? false,
        scheduleid: json['scheduleId'] ?? 'No ID',
        accepted: json['accepted'] ?? false,
        phone: json['riderPhone'] ?? 'Unknown Number',
        riderName: json['riderName'] ?? 'Unknown Rider',
        requester: json['requester'] ?? 'Unknown requester',
    );
  }

  factory NotificationModel.fromJsonForRideTaken(Map<String, dynamic> json) {
    return NotificationModel(
        rider: json['user'] ?? 'Unknown User', // Default value if null
        message: json['message'] ?? 'No message', // Default value if null
        createdAt: DateTime.parse(json['createdAt']),
        imageData: json['image'] != null ? base64Decode(json['image']) : null,
        id: json['_id'] ?? 'No ID', // Default value if null
        requestId: json['requestid'] ?? 'No Request ID',
        payed: json['payed'] ?? false,
        scheduleid: json['scheduleId'] ?? 'No ID',
        accepted: json['accepted'] ?? false,
        phone: json['riderPhone'] ?? 'Unknown Number',
        riderName: json['riderName'] ?? 'Unknown Rider',
        requester: json['requester'] ?? 'Unknown requester',
    );
  }
}

Future<List<NotificationModel>> fetchRideGivenNotifications(
    String username) async {
  final String url = Global.url;
  final response = await http
      .get(Uri.parse('$url/notifications/$username'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['notifications'];
    return data.map((item) => NotificationModel.fromJson(item)).toList();
  } else {
    throw Exception(
        'Failed to load ride given notifications. Status code: ${response.statusCode}');
  }
}

Future<List<NotificationModel>> fetchRideTakenNotifications(
    String username) async {
  final String url = Global.url;
  final response = await http
      .get(Uri.parse('$url/usernotifications/$username'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['notifications'];
    return data
        .map((item) => NotificationModel.fromJsonForRideTaken(item))
        .toList();
  } else {
    throw Exception(
        'Failed to load ride taken notifications. Status code: ${response.statusCode}');
  }
}

// Notifications Page
class NotificationsPage extends StatefulWidget {
  final token;

  NotificationsPage({required this.token});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationModel>> _notifications;
  late String username;
  late String phone;
  final Map<String, Uint8List?> _imageCache = {};
  String _filter = 'rideGiven'; // Default filter
  bool isPaymentCompleted = false;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
    phone = jwtDecodedToken['phone'];
    _loadNotifications();
  }

  void _loadNotifications() {
    if (_filter == 'rideGiven') {
      _notifications = fetchRideGivenNotifications(username);
    } else {
      _notifications = fetchRideTakenNotifications(username);
    }
  }

  

  void _acceptRideRequest(NotificationModel notification) async {
    if (notification.accepted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ride Request Already Accepted'),
            content: Text(
                'The ride request for this schedule has already been accepted.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the function as no further action is needed
    }

    final String url = Global.url;

    Map<String, dynamic> data = {
      'username': username,
      'phone': phone,
      'requestId': notification.requestId,
      'notificationId': notification.id,
      'scheduleId': notification.scheduleid,
      'accepted': true
    };

    try {
      final response = await http.post(
        Uri.parse('$url/acceptride'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        onSuccessCallback();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride request has been accepted')),
        );
        _loadNotifications(); // Reload notifications
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept ride request')),
        );
      }
    } catch (error) {
      // Handle any errors that occur during the HTTP request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('An error occurred while accepting the ride request')),
      );
      print('Error: $error');
    }
  }

  void _changeFilter(String filter) {
    setState(() {
      _filter = filter;
      _loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Navigate to MainPage when back button is pressed
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainScaffold(token: widget.token)),
              (Route<dynamic> route) => false,
        );
        return false; // Prevent default back navigation
      },
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(248, 248, 251, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _changeFilter('rideGiven'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (_filter == 'rideGiven') {
                                return Color.fromRGBO(
                                    34, 207, 249, 1); // Blue for selected
                              }
                              return Colors.white; // White for unselected
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (_filter == 'rideGiven') {
                                return Colors.white; // White text for selected
                              }
                              return Color.fromRGBO(
                                  34, 207, 249, 1); // Blue text for unselected
                            },
                          ),
                          // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                              side: BorderSide(
                                  color: Color.fromRGBO(
                                      34, 207, 249, 1)), // Border color
                            ),
                          ),
                        ),
                        child: Text(
                          'Ride Requests',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _changeFilter('rideTaken'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (_filter == 'rideTaken') {
                                return Color.fromRGBO(
                                    34, 207, 249, 1); // Blue for selected
                              }
                              return Colors.white; // White for unselected
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (_filter == 'rideTaken') {
                                return Colors.white; // White text for selected
                              }
                              return Color.fromRGBO(
                                  34, 207, 249, 1); // Blue text for unselected
                            },
                          ),
                          // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                              side: BorderSide(
                                  color: Color.fromRGBO(
                                      34, 207, 249, 1)), // Border color
                            ),
                          ),
                        ),
                        child: Text(
                          'Rides Requested',
                          style: TextStyle(
                            fontFamily: 'Futura',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: FutureBuilder<List<NotificationModel>>(
                      future: _notifications,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No notifications'));
                        } else {
                          final notifications = snapshot.data!;
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              final imageData = notification.imageData;
                              final timeAgo = DateTime.now()
                                  .difference(notification.createdAt)
                                  .inMinutes;

                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Confirm Action'),
                                          content: Text(_filter == 'rideGiven'
                                              ? 'Do you want to accept this ride request?'
                                              : 'Do you want to process payment for this ride request?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                                if (_filter == 'rideGiven') {
                                                  _acceptRideRequest(
                                                      notification);
                                                  // _notificationsUpdate(notification);
                                                } else {
                                                  // _showBookingDialog(context, notification);
                                                  showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                        true, // Allow scrolling if needed
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        padding:
                                                            EdgeInsets.all(16),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'Khalti Payment',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 16),
                                                            Text(
                                                              'You are about to complete the payment to ${notification.riderName}. The phone number associated with this payment is ${notification.phone}.',
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey[700]),
                                                            ),
                                                            SizedBox(height: 16),
                                                            Text(
                                                              'Amount: NPR 1000.00', // Adjust the amount as needed
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(height: 16),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                print(notification
                                                                    .id);
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                if (!notification
                                                                    .payed) {
                                                                  _showBookingDialog(
                                                                      context,
                                                                      notification);
                                                                } else {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                        title: Text(
                                                                            "Payment Already Done"),
                                                                        content: Text(
                                                                            "Your payment has already been processed."),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Text('OK'),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                }
                                                              },
                                                              child: Text(
                                                                  'Confirm Payment'),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  splashColor: Colors.grey.withOpacity(0.2),
                                  highlightColor: Colors.grey.withOpacity(0.1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, right: 15, top: 10, bottom: 10),
                                    child: Row(
                                      children: [
                                        if (imageData != null)
                                          CircleAvatar(
                                            backgroundImage:
                                                MemoryImage(imageData),
                                            radius: 30,
                                          )
                                        else
                                          CircleAvatar(
                                            radius: 30,
                                            child: Icon(Icons.person),
                                          ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _filter == 'rideGiven'
                                                    ? 'New Ride Request' // Text for ride given
                                                    : 'Ride Request Accepted', // Text for ride taken
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    fontFamily: 'Futura'),
                                              ),
                                              if (_filter == 'rideTaken' &&
                                                  notification.payed)
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 0),
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                ),
                                              SizedBox(height: 4),
                                              Text(
                                                notification.message,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                  fontFamily: 'Futura',
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '$timeAgo mins ago',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[500],
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
                            },
                          );
                        }
                      },
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

  bool _paymentSuccessful = false;

  void _showBookingDialog(
      BuildContext context, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: _paymentSuccessful
              ? Text('Payment has already been made for this ride.')
              : Text('Are you sure you want to book this ride?'),
          actions: [
            TextButton(
              onPressed: () {
                if (!_paymentSuccessful) {
                  Navigator.pop(context);
                  _bookRide(context, notification); // Pass context to _bookRide
                } else {
                  Navigator.pop(
                      context); // Just close the dialog if payment is already successful
                }
              },
              child: Text(_paymentSuccessful ? 'OK' : 'Yes'),
            ),
            if (!_paymentSuccessful)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
          ],
        );
      },
    );
  }

  void _bookRide(BuildContext context, NotificationModel notification) async {
    if (notification.payed) {
      return;
    }
    try {
      await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: 10000, // Example amount in paisa (100 paisa = 1 unit)
          productIdentity: "ProductId_${notification.id}",
          productName: "ProductName_${notification.rider}",
        ),
        onSuccess: (PaymentSuccessModel success) {
          if (scaffoldMessengerKey.currentContext != null) {
            // Update the paymentSuccessful boolean to true and trigger a rebuild
            setState(() {
              _paymentSuccessful = true;
            });
            _updatePaymentStatus(notification);
            _showPaymentResultDialog(scaffoldMessengerKey.currentContext!, true,
                notification); // Show success dialog
          }
          print('Payment successful: ${success.toString()}');
        },
        onFailure: (PaymentFailureModel failure) {
          if (scaffoldMessengerKey.currentContext != null) {
            // Update the paymentSuccessful boolean to false and trigger a rebuild
            setState(() {
              _paymentSuccessful = false;
            });
            _showPaymentResultDialog(scaffoldMessengerKey.currentContext!,
                false, notification); // Show failure dialog
          }
          print('Payment failed: ${failure.toString()}');
        },
        onCancel: () {
          if (scaffoldMessengerKey.currentContext != null) {
            // Update the paymentSuccessful boolean to false and trigger a rebuild
            setState(() {
              _paymentSuccessful = false;
            });
            _showPaymentResultDialog(scaffoldMessengerKey.currentContext!,
                false, notification); // Show cancel dialog
          }
          print('Payment cancelled');
        },
      );
    } catch (e) {
      // Handle any exceptions that might occur
      print('Exception occurred: $e');
    }
  }

  void _showPaymentResultDialog(
      BuildContext context, bool success, NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(success ? "Payment Successful" : "Payment Failed"),
          content: Text(success
              ? "Your payment was successful. Thank you for booking!"
              : "Your payment failed. Please try again."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSuccessCallback();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _updatePaymentStatus(NotificationModel notification) async {
    final String url = Global.url;

    Map<String, dynamic> data = {
      'scheduleId': notification.scheduleid,
      'notificationId':
          notification.id, // Match this field name with your backend
      'status': true, // Ensure this matches the backend expected status field
    };

    try {
      final response = await http.post(
        Uri.parse('$url/updatePayment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ride request has been accepted')),
        );
        _loadNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept ride request')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
      print('Exception occurred: $e');
    }
  }

  void onSuccessCallback() {
    setState(() {
      _loadNotifications();
    });
  }
}
