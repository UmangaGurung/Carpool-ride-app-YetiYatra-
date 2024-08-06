import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class publishone extends StatelessWidget {
  const publishone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Schedule(),
    );
  }
}

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
  
}

class _ScheduleState extends State<Schedule> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  int? checkCallBack = 0;
  String? title;
  IconData? icon;
  Color customColor = Color.fromRGBO(250, 250, 250, 0.9);
  final TextEditingController _startpoint = TextEditingController();
  final TextEditingController _endpoint = TextEditingController();

  String tokenForSession = '37465';
  var uuid = Uuid();
  List<dynamic> listForPlaces = [];
  void makeSuggestion(String input) async {
    // String googlePlacesApiKey= 'AIzaSyBL_EPLYpDJzNdTqX7UBEaG3bTM_R9YUZc';
    String googlePlacesApiKey = "AIzaSyBkiXF-G0ly-2ZnUxJ2SM6ix4GG3FI4g5k";
    String groundURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundURL?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var responseResult = await http.get(
      Uri.parse(request),
    );

    var Resultdata = responseResult.body.toString();

    print('Result Data $Resultdata');

    if (responseResult.statusCode == 200) {
      setState(() {
        listForPlaces =
            jsonDecode(responseResult.body.toString())['prediction'];
      });
    } else {
      throw Exception('Showing data failed');
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(_startpoint.text);
  }

  void initState() {
    super.initState();
    _startpoint.addListener(() {
      onModify();
    });
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
    setState(() {
      checkCallBack = 1;
      customColor = Colors.blue;
      title = 'Starting point';
      icon = Icons.arrow_circle_left_outlined;
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the bottom sheet to take up the full screen
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
                    // Expanded(
                    //   child: GestureDetector(
                    //     child: TextFormField(
                    //       // enabled: false,
                    //       controller: _startpoint,
                    //       decoration: InputDecoration(
                    //         hintText: 'Starting point',
                    //         labelStyle: TextStyle(fontFamily: 'Futura'),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    GestureDetector(
                      child: Column(
                        children: [
                          TextFormField(
                            // enabled: false,
                            controller: _startpoint,
                            decoration: InputDecoration(
                              hintText: 'Starting point',
                              labelStyle: TextStyle(fontFamily: 'Futura'),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: listForPlaces.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () async{
                                    List<Location> locations= await locationFromAddress(listForPlaces[index] ['description']);
                                    print(locations.last.latitude);
                                    print(locations.last.longitude);
                                    },
                                    title: Text(listForPlaces[index] ['description']),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {
      customColor = Color.fromRGBO(250, 250, 250, 0.9);
      title = '';
      checkCallBack = 0;
    });
  }

  void _onSearchPressed2() async {
    setState(() {
      checkCallBack = 2;
      customColor = Colors.blue;
      title = 'Going To';
      icon = Icons.arrow_circle_left_outlined;
    });

    await showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the bottom sheet to take up the full screen
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.84,
          maxChildSize: 1.0,
          minChildSize: 0.25,
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
                height: MediaQuery.of(context).size.height,
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
                      child: GestureDetector(
                        child: TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: 'Going To',
                            labelStyle: TextStyle(fontFamily: 'Futura'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {
      customColor = Color.fromRGBO(250, 250, 250, 0.9);
      title = '';
      checkCallBack = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(34, 207, 249, 1),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(screenHeight * 0.13),
      //   child: AppBar(
      //     backgroundColor: Color.fromRGBO(34, 207, 249, 1),
      //     title: Text(
      //       'Schedule a Ride',
      //       style: TextStyle(
      //         fontFamily: 'Poppins',
      //       ),
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.7618,
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
                            // validator: (value) {},
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
                              hintText: 'Set your starting point',
                              hintStyle: TextStyle(
                                  fontFamily: 'Futura',
                                  fontSize: 15,
                                  color: Colors.grey),
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 5),
                              prefixIcon: Icon(
                                Icons.location_pin,
                                color: Color.fromRGBO(34, 207, 249, 1),
                              ),
                            ),
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
                            // validator: (value) {},
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
                              hintText: 'Set your end point',
                              hintStyle: TextStyle(
                                  fontFamily: 'Futura',
                                  fontSize: 15,
                                  color: Colors.grey),
                              contentPadding:
                                  EdgeInsets.only(left: 20, bottom: 5),
                              prefixIcon: Icon(
                                Icons.location_pin,
                                color: Color.fromRGBO(34, 207, 249, 1),
                              ),
                            ),
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
                              // validator: (value) {},
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
                          // validator: (value) {},
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
                            hintText: 'Set your departure time',
                            hintStyle: TextStyle(
                                fontFamily: 'Futura',
                                fontSize: 15,
                                color: Colors.grey),
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
                          // validator: (value) {},
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
                            hintStyle: TextStyle(
                                fontFamily: 'Futura',
                                fontSize: 15,
                                color: Colors.grey),
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
                        // Get.to(
                        //       () => CardWidget(),
                        //   transition: Transition.zoom,
                        //   duration: const Duration(milliseconds: 500),
                        // );
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
    );
  }
}
