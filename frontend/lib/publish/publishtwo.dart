import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'timeformat.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'publishMap.dart';
import 'package:yeti_yatra_project/main_scaffold.dart';


class PublishPage extends StatefulWidget {
  final token;
  const PublishPage({@required this.token, Key? key}) : super(key: key);

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  int? checkCallBack = 0;
  String? title;
  IconData? icon;
  Color customColor = Color.fromRGBO(250, 250, 250, 0.9);
  bool s_index=false;

  final _formkeyschedule = GlobalKey<FormState>();
  late String username;
  late String phone;
  late Uint8List imageData = Uint8List(0);
  final TextEditingController _leaving = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _seats = TextEditingController();

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
    } else {

    }
  }
  //test
  //

  void _submitSchedule() async {
    if (_formkeyschedule.currentState?.validate() ?? false) {
      String leaving = _leaving.text;
      String destination = _destination.text;
      String date = _dateController.text;
      String time = _time.text;
      String emptyseats = _seats.text;

      Map<String, dynamic> data = {
        'username': username,
        'phone': phone,
        'leaving': leaving,
        'destination': destination,
        'date': date,
        'time': time,
        'emptyseats': emptyseats,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(token: widget.token, result: data),
        ),
      );
    } else {
      // Show error if form is not valid
      _showValidationErrorDialog(context);
    }
  }

  void _showValidationErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please fill all the required fields correctly.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _validationSnackBar(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fields are empty')),
    );
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
        '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}';
      });
    }
  }

  void _onSearchPressed() async {
    final TextEditingController modalController = TextEditingController();

    setState(() {
      checkCallBack = 1;
      customColor = Colors.blue;
      title = 'Starting point';
      icon = Icons.arrow_circle_left_outlined;
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to take up the full screen
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.84, // 90% of screen height
          maxChildSize: 1.0, // Full screen
          minChildSize: 0.25, // Minimum height when collapsed
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                height: MediaQuery.of(context).size.height, // Adjust height
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Color.fromRGBO(34, 207, 249, 1),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: modalController,
                        decoration: InputDecoration(
                          hintText: 'Starting point',
                          hintStyle: TextStyle(fontFamily: 'Futura', fontSize: 17, color: Colors.grey),
                          labelStyle: TextStyle(fontFamily: 'Futura'),
                        ),
                        onFieldSubmitted: (value) {
                          Navigator.of(context).pop(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          // Update the parent text field with the result from the modal
          _leaving.text = result;
        });
      }

      setState(() {
        customColor = Color.fromRGBO(250, 250, 250, 0.9);
        title = '';
        checkCallBack = 0;
      });
    });
  }


  void _onSearchPressed2() async {
    final TextEditingController modalController2 = TextEditingController();

    setState(() {
      checkCallBack = 2;
      customColor = Colors.blue;
      title = 'Going To';
      icon = Icons.arrow_circle_left_outlined;
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow the bottom sheet to take up the full screen
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.84, // 90% of screen height
          maxChildSize: 1.0, // Full screen
          minChildSize: 0.25, // Minimum height when collapsed
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.03,
                  right: MediaQuery.of(context).size.width * 0.03,
                ),
                height: MediaQuery.of(context).size.height, // Adjust height
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Color.fromRGBO(34, 207, 249, 1),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: modalController2,
                        decoration: InputDecoration(
                          hintText: 'Destination point',
                          hintStyle: TextStyle(fontFamily: 'Futura', fontSize: 17, color: Colors.grey),
                          labelStyle: TextStyle(fontFamily: 'Futura'),
                        ),
                        onFieldSubmitted: (value) {
                          Navigator.of(context).pop(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((result) {
      if (result != null) {
        setState(() {
          // Update the parent text field with the result from the modal
          _destination.text = result;
        });
      }

      setState(() {
        customColor = Color.fromRGBO(250, 250, 250, 0.9);
        title = '';
        checkCallBack = 0;
      });
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
      child: Scaffold(
        backgroundColor: Color.fromRGBO(34, 207, 249, 1),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formkeyschedule,
              child: Container(
                // height: screenHeight * 0.7618,
                height: screenHeight * 0.77,
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
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.65,
                      margin: EdgeInsets.only(
                        left: screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.027,
                          ),
                          Text(
                            'Leaving From',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          SizedBox(
                            width: screenWidth * 0.9,
                            height: (screenHeight * 0.5) * 0.1189,
                            child: GestureDetector(
                              onTap: _onSearchPressed,
                              child: TextFormField(
                                controller: _leaving,
                                enabled: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _validationSnackBar(context);
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  hintText: _leaving.text.isEmpty ? 'Set your starting point' : null,
                                  hintStyle: TextStyle(fontFamily: 'Futura', fontSize: 15, color: Colors.grey),
                                  contentPadding: EdgeInsets.only(left: 20, bottom: 5),
                                  prefixIcon: Icon(
                                    Icons.location_pin,
                                    color: Color.fromRGBO(34, 207, 249, 1),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Going To',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          SizedBox(
                            width: screenWidth * 0.9,
                            height: (screenHeight * 0.5) * 0.1189,
                            child: GestureDetector(
                              onTap: _onSearchPressed2,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _validationSnackBar(context);
                                  }
                                },
                                controller: _destination,
                                enabled: false,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(255, 255, 255, 1.0),
                                    ),
                                  ),
                                  hintText: _destination.text.isEmpty ? 'Set your end point' : null,
                                  hintStyle: TextStyle(fontFamily: 'Futura', fontSize: 15, color: Colors.grey),
                                  contentPadding: EdgeInsets.only(left: 20, bottom: 5),
                                  prefixIcon: Icon(
                                    Icons.location_pin,
                                    color: Color.fromRGBO(34, 207, 249, 1),
                                  ),
                                ),
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Date',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          SizedBox(
                            width: screenWidth * 0.9,
                            height: (screenHeight * 0.5) * 0.1189,
                            child: GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      _validationSnackBar(context);
                                    }
                                  },
                                  controller: _dateController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 255, 255, 1.0),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(255, 255, 255, 1.0),
                                      ),
                                    ),
                                    hintText: _selectedDate == null
                                        ? 'Set your Date'
                                        : null,
                                    hintStyle: TextStyle(
                                      fontFamily: 'Futura',
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                    contentPadding:
                                    EdgeInsets.only(left: 20, bottom: 5),
                                    prefixIcon: Icon(
                                      Icons.calendar_month,
                                      color: Color.fromRGBO(34, 207, 249, 1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Time',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          SizedBox(
                            width: screenWidth * 0.9,
                            height: (screenHeight * 0.5) * 0.1189,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  _validationSnackBar(context);
                                }
                              },
                              controller: _time,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                TimeInputFormatter(),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                  ),
                                ),
                                hintText: 'Hour:Minutes',
                                hintStyle:
                                TextStyle(fontFamily: 'Futura', fontSize: 15, color: Colors.grey),
                                contentPadding:
                                EdgeInsets.only(left: 20, bottom: 5),
                                prefixIcon: Icon(
                                  Icons.time_to_leave,
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Empty Seats',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                          SizedBox(
                            width: screenWidth * 0.9,
                            height: (screenHeight * 0.5) * 0.1189,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  _validationSnackBar(context);
                                }
                              },
                              controller: _seats,
                              keyboardType: TextInputType.numberWithOptions(decimal: false),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Color.fromRGBO(255, 255, 255, 1.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                  ),
                                ),
                                hintText: 'Select no. of empty seats',
                                hintStyle:
                                TextStyle(fontFamily: 'Futura', fontSize: 15, color: Colors.grey),
                                contentPadding:
                                EdgeInsets.only(left: 20, bottom: 5),
                                prefixIcon: Icon(
                                  Icons.people_alt_outlined,
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.014),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: screenWidth * 0.57,
                        height: (screenHeight * 0.6) * 0.1,
                        child: ElevatedButton(
                          onPressed: () {
                            _submitSchedule();
                          },
                          child: Text(
                            'Schedule',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
