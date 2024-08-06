import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'GlobalUrl.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:yeti_yatra_project/main_scaffold.dart';

class NotificationModel {
  final String id;
  final String requesterName;
  final String requesterPhone;
  final String rider;
  final String riderPhone;
  final String leaving;
  final String destination;
  final String scheduleId;
  final int noOfPassengers;
  final String status;
  final DateTime createdAt;
  final String username;
  final String phone;
  final int emptySeats;
  final bool pending;
  final String scheduledDate;

  NotificationModel({
    required this.id,
    required this.requesterName,
    required this.requesterPhone,
    required this.rider,
    required this.riderPhone,
    required this.leaving,
    required this.destination,
    required this.scheduleId,
    required this.noOfPassengers,
    required this.status,
    required this.createdAt,
    required this.username,
    required this.phone,
    required this.emptySeats,
    required this.pending,
    required this.scheduledDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? 'No ID',
      requesterName: json['requesterName'] ?? 'Unknown Requester',
      requesterPhone: json['requesterPhone'] ?? 'Unknown Phone',
      rider: json['rider'] ?? 'Unknown Rider',
      riderPhone: json['riderPhone'] ?? 'Unknown Rider Phone',
      leaving: json['leaving'] ?? 'Unknown',
      destination: json['destination'] ?? 'Unknown',
      scheduleId: json['scheduleId'] ?? 'No Schedule ID',
      noOfPassengers: json['noOfPassengers'] ?? 0,
      status: json['status'] ?? 'Unknown Status',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      scheduledDate: json['date'] ?? 'Unknown Date',
      username: json['username'] ?? 'Unknown Username',
      phone: json['phone'] ?? 'Unknown Phone',
      emptySeats: json['emptySeats'] ?? 0,
      pending: json['pending'] ?? false,
    );
  }

  factory NotificationModel.fromJsonForRideTaken(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? 'No ID',
      requesterName: json['requesterName'] ?? 'Unknown Requester',
      requesterPhone: json['requesterPhone'] ?? 'Unknown Phone',
      rider: json['rider'] ?? 'Unknown Rider',
      riderPhone: json['riderPhone'] ?? 'Unknown Rider Phone',
      leaving: json['leaving'] ?? 'Unknown',
      destination: json['destination'] ?? 'Unknown',
      scheduleId: json['scheduleId'] ?? 'No Schedule ID',
      noOfPassengers: json['noOfPassengers'] ?? 0,
      status: json['status'] ?? 'Unknown Status',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      scheduledDate: json['date'] ?? 'Unknown Date',
      username: json['username'] ?? 'Unknown Username',
      phone: json['phone'] ?? 'Unknown Phone',
      emptySeats: json['emptySeats'] ?? 0,
      pending: json['pending'] ?? false,
    );
  }
}

Future<List<NotificationModel>> fetchRideGivenNotifications(
    String username) async {
  final String url = Global.url;
  final response = await http.get(Uri.parse('$url/rideGiven/$username'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['scheduleData'];
    return data.map((item) => NotificationModel.fromJson(item)).toList();
  } else {
    throw Exception(
        'Failed to load ride given notifications. Status code: ${response.statusCode}');
  }
}

Future<List<NotificationModel>> fetchRideTakenNotifications(
    String username) async {
  final String url = Global.url;
  final response = await http.get(Uri.parse('$url/rideTaken/$username'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body)['rideRequests'];
    return data
        .map((item) => NotificationModel.fromJsonForRideTaken(item))
        .toList();
  } else {
    throw Exception(
        'Failed to load ride taken notifications. Status code: ${response.statusCode}');
  }
}

class HistoryPage extends StatefulWidget {
  final token;

  const HistoryPage({super.key, required this.token});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<NotificationModel>> _notifications;
  late String username;
  late String phone;
  String _filter = 'rideGiven';
  late Uint8List imageData = Uint8List(0);

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
    String imageBase64 = jwtDecodedToken['image'];

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      imageData = base64Decode(imageBase64);
    } else {}
    _loadNotifications();
  }

  void _loadNotifications() {
    if (_filter == 'rideGiven') {
      _notifications = fetchRideGivenNotifications(username);
    } else {
      _notifications = fetchRideTakenNotifications(username);
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
    String formatDate(DateTime date) {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(date);
    }
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
                          'Rides Scheduled',
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
                          return Center(child: Text('Nothing to see here'));
                        } else {
                          final notifications = snapshot.data!;
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (context, index) {
                              final notification = notifications[index];
                              final timeAgo = DateTime.now()
                                  .difference(notification.createdAt)
                                  .inMinutes;

                              return Card(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16),
                                  // title: _filter == 'rideGiven'
                                  //     ? Text(notification.username)
                                  //     : Text(notification.rider),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (_filter == 'rideGiven') ...[
                                        // Text('Phone: ${notification.phone}'),
                                        // Text('Leaving: ${notification.leaving}'),
                                        // Text('Destination: ${notification.destination}'),
                                        // Text('Scheduled Date: ${notification.scheduledDate}'),
                                        // Text('Empty Seats: ${notification.emptySeats}'),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Color.fromRGBO(34, 207, 249, 1),
                                                          child: Icon(Icons.home,
                                                              color: Colors.white, size: 30)),
                                                      Container(
                                                        height: 30,
                                                        width: 3,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Color.fromRGBO(34, 207, 249, 1),
                                                          child: Icon(Icons.place,
                                                              color: Colors.white, size: 30))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Container(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Leaving From',
                                                          style: TextStyle(
                                                              fontSize: 15, fontFamily: 'Futura'),
                                                        ),
                                                        Text(
                                                          notification.leaving,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Futura'),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          'Going To',
                                                          style: TextStyle(
                                                              fontSize: 15, fontFamily: 'Futura'),
                                                        ),
                                                        Text(
                                                          notification.destination,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Futura'),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_month,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        notification.scheduledDate,
                                                        style: TextStyle(fontFamily: 'Futura'),
                                                      ),
                                                      SizedBox(width: 100),
                                                      Icon(
                                                        Icons.people,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        notification.emptySeats.toString(),
                                                        style: TextStyle(fontFamily: 'Futura'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration: BoxDecoration(
                                                            color: Colors.lightBlue,
                                                            borderRadius: BorderRadius.circular(50),
                                                            image: DecorationImage(
                                                              image: MemoryImage(imageData),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Text(notification.username,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20, fontFamily: 'Futura'),),
                                                            Text(notification.phone, style: TextStyle(fontFamily: 'Futura'),),
                                                            SizedBox(height: 10)
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 15),
                                                      // ElevatedButton(
                                                      //   onPressed: () {
                                                      //     _showBookingDialog(context, result);
                                                      //   },
                                                      //   child: Text('Book It'),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        // Text('Rider Phone: ${notification.riderPhone}'),
                                        // Text('Leaving: ${notification.leaving}'),
                                        // Text('Destination: ${notification.destination}'),
                                        // Text('No. of Passengers: ${notification.noOfPassengers}'),
                                        // Text('Status: ${notification.status}'),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Color.fromRGBO(34, 207, 249, 1),
                                                          child: Icon(Icons.home,
                                                              color: Colors.white, size: 30)),
                                                      Container(
                                                        height: 30,
                                                        width: 3,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      CircleAvatar(
                                                          backgroundColor:
                                                          Color.fromRGBO(34, 207, 249, 1),
                                                          child: Icon(Icons.place,
                                                              color: Colors.white, size: 30))
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Container(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          'Leaving From',
                                                          style: TextStyle(
                                                              fontSize: 15, fontFamily: 'Futura'),
                                                        ),
                                                        Text(
                                                          notification.leaving,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Futura'),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          'Going To',
                                                          style: TextStyle(
                                                              fontSize: 15, fontFamily: 'Futura'),
                                                        ),
                                                        Text(
                                                          notification.destination,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Futura'),
                                                        )
                                                      ]),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Divider(),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.calendar_month,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        formatDate(notification.createdAt),
                                                        style: TextStyle(fontFamily: 'Futura'),
                                                      ),
                                                      SizedBox(width: 100),
                                                      Icon(
                                                        Icons.people,
                                                        color: Color.fromRGBO(34, 207, 249, 1),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Text(
                                                        notification.noOfPassengers.toString(),
                                                        style: TextStyle(fontFamily: 'Futura'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        child: Container(
                                                          height: 60,
                                                          width: 60,
                                                          decoration: BoxDecoration(
                                                            color: Colors.lightBlue,
                                                            borderRadius: BorderRadius.circular(50),
                                                            image: DecorationImage(
                                                                image:
                                                                AssetImage('images/avatar.jpg'),
                                                                fit: BoxFit.cover),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Container(
                                                        child: Column(
                                                          children: [
                                                            Text(notification.rider,
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 20, fontFamily: 'Futura'),),
                                                            Text(notification.riderPhone, style: TextStyle(fontFamily: 'Futura'),),
                                                            SizedBox(height: 10)
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 15),
                                                      // ElevatedButton(
                                                      //   onPressed: () {
                                                      //     _showBookingDialog(context, result);
                                                      //   },
                                                      //   child: Text('Book It'),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                      SizedBox(height: 8),
                                    ],
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
}
