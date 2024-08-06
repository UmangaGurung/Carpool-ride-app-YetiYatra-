import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yeti_yatra_project/SearchScreen/Widget/slider_container_list.dart';
import 'package:yeti_yatra_project/SearchScreen/search_result.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import 'resultpage.dart';
import '../HistoryScreen/GlobalUrl.dart';


class SearchPage extends StatefulWidget {
  final token;

  const SearchPage({
    super.key,
    required this.token,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int? checkCallBack = 0;
  String? title;
  IconData? icon;
  Color customColor = Color.fromRGBO(250, 250, 250, 0.9);

  final GlobalKey<FormState> _formkeypublish = GlobalKey<FormState>();

  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  String? _passengerError;

  late String? username;
  late String? phone;
  final TextEditingController _leaving = TextEditingController();
  final TextEditingController _destination = TextEditingController();
  final TextEditingController _noOfpassengers = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    username = jwtDecodedToken['username'];
    phone = jwtDecodedToken['phone'];
  }

  void _submitSearch() async{
    final String url = Global.url;

    if(_formkeypublish.currentState?.validate()??false){
      String leaving= _leaving.text;
      String destination= _destination.text;
      String date= _dateController.text;
      String noOfpassengers= _noOfpassengers.text;

      Map<String, dynamic> data = {
        'username': username,
        'phone': phone,
        'leaving': leaving,
        'destination': destination,
        'date': date,
        'noOfpassengers': noOfpassengers,
      };

      try {
        final response = await http.post(
          Uri.parse('$url/search'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final results = responseData['results'];  // Extract results
          // Navigate to ResultsPage and pass the results
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPage(results: results, username: username, phone: phone, noOfpassengers: noOfpassengers,),
              // builder: (context) => SearchResultModel(results: results),
            ),
          );

        } else {
          print('Failed to search: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to search.')),
          );
        }
      }catch (error) {
        print('Error: $error');
      }
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

  final List<String> imgList = [
    'images/slider.JPG',
    'images/slidertwo.jpg',
    'images/sliderthree.jpg',
    // Add more images as needed
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              items: imgList.map((image) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5), // Optional: add margin for spacing between slides
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover, // Adjust the fit as needed
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: screenHeight * 0.2,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval: Duration(seconds: 3),
                pauseAutoPlayOnTouch: true,
              ),
            ),
            SizedBox(height: screenHeight * 0.0125),
            Form(
              key: _formkeypublish,
              child: Container(
                height: screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Color.fromRGBO(34, 207, 249, 1),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: _onSearchPressed,
                            child: TextFormField(
                              enabled: false,
                              controller: _leaving,
                              decoration: InputDecoration(
                                hintText: 'Leaving From',
                                hintStyle: TextStyle(fontFamily: 'Futura'),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(211, 211, 211, 1.0),
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: Color.fromRGBO(34, 207, 249, 1),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: _onSearchPressed2,
                            child: TextFormField(
                              enabled: false,
                              controller: _destination,
                              decoration: InputDecoration(
                                hintText: 'Going To',
                                hintStyle: TextStyle(fontFamily: 'Futura'),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(211, 211, 211, 1.0),
                                  ),
                                ),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          color: Color.fromRGBO(34, 207, 249, 1),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                            child: GestureDetector(
                          onTap: () => _selectDate(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                hintText: _selectedDate == null
                                    ? 'Set your Date'
                                    : null,
                                hintStyle: TextStyle(
                                  fontFamily: 'Futura',
                                  color: Colors
                                      .grey, // Set hint text color to grey
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(211, 211, 211, 1.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Futura',
                                color: Colors
                                    .black, // Set actual text color to black
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Color.fromRGBO(34, 207, 249, 1),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            onSaved: (value) {
                              // Save the value if needed
                            },
                            onChanged: (value) {
                              // Reset the error when the user types something new
                              if (_passengerError != null) {
                                setState(() {
                                  _passengerError = null;
                                });
                              }
                            },
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: false),
                            controller: _noOfpassengers,
                            decoration: InputDecoration(
                              hintText: 'No. of Passengers',
                              hintStyle: TextStyle(
                                  fontFamily: 'Futura', color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(211, 211, 211, 1.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.065),
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: (screenHeight * 0.54) * 0.13,
                        width: screenWidth * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formkeypublish.currentState?.validate() ?? false) {

                              _submitSearch();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Validation Error'),
                                    content: Text(
                                        'Please correct the input fields.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) {
                                // Optionally, you can reset the error state here if needed
                                setState(() {
                                  _passengerError = 'Validation error message';
                                });
                              });
                            }
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
