import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../SearchScreen/Model/search_result_model.dart';

class RideDetailsPage extends StatefulWidget {
  SearchResultModel searchResultPerson;
  RideDetailsPage({super.key, required this.searchResultPerson});

  @override
  State<RideDetailsPage> createState() => _RideDetailsPageState();
}

class _RideDetailsPageState extends State<RideDetailsPage> {
  late GoogleMapController mapController; //built-in controller
  final String _apiKey =
      "AIzaSyCG_MvXuH22_YH2pRZEeopBxzpoLHStb4M"; //accessing maps
  final LatLng _center = const LatLng(
    27.7172,
    85.3240,
  ); //setting up latitude and longitude for map

  final Set<Marker> _marker = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  } //this functions brings controller from package and assigns it to mapController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0,
            leading: Icon(Icons.arrow_back, color: Colors.white),
            title: Text(
              "Ride Details",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white54,
            ),
            child: Column(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 20,
                    ),
                    markers: _marker,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  child: widget
                      .searchResultPerson, //SHOW THE SEARCH RESULT PERSON AS CONTAINER
                )
              ],
            ),
          ),
        ));
  }
}
