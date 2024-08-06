import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

void main(){
  runApp(PlacesApiGoogle());
}

class PlacesApiGoogle extends StatelessWidget {
  const PlacesApiGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PlacesApiGoogleMap(),
    );
  }
}

class PlacesApiGoogleMap extends StatefulWidget {
  const PlacesApiGoogleMap({super.key});

  @override
  State<PlacesApiGoogleMap> createState() => _PlacesApiGoogleMapState();
}

class _PlacesApiGoogleMapState extends State<PlacesApiGoogleMap> {
  final TextEditingController _startpoint = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              TextFormField(
                controller: _startpoint,
                decoration: InputDecoration(
                  hintText: 'Search Here'
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
      ),
    );
  }
}

