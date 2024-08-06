import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as location;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'consts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/foundation.dart';
import '../HistoryScreen/GlobalUrl.dart';

class MapPage extends StatefulWidget {
  final token;
  final dynamic result;

  const MapPage({
    super.key,
    required this.token,
    required this.result,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(27.6953, 85.3549);
  static const LatLng _pApplePark = LatLng(28.2334, 83.6692);
  LatLng? _currentP = null;
  LatLng? _leavingP;
  LatLng? _destinationP;
  late Uint8List imageData = Uint8List(0);

  late StreamSubscription<location.LocationData> _locationSubscription;
  late int confirmRespose;

  location.Location _locationController = new location.Location();
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  Map<PolylineId, Polyline> polylines = {};

  //call the getLocation method and right then call the getPolyLinePoints
  void initState() {
    super.initState();
    _locationController = location.Location();
    getLocation();
    _geocodeAddresses();
    _initialize();
  }

  void _initialize() {
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    String imageBase64 = jwtDecodedToken['image'];

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      imageData = base64Decode(imageBase64);
    } else {}
  }

  void dispose() {
    _locationSubscription.cancel();
    _mapController.future.then((controller) => controller.dispose());
    super.dispose();
  }

  //asking permission to access users location and displaying it on the map
  Future<void> getLocation() async {
    bool serviceEnabled;
    location.PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _locationController.hasPermission();
    if (permissionGranted == location.PermissionStatus.denied) {
      permissionGranted = await _locationController.requestPermission();
      if (permissionGranted != location.PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((location.LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
            _cameraToPosition(_currentP!);
          });
        }
      }
    });
  }

  Future<void> _geocodeAddresses() async {
    try {
      // Extract leaving and destination addresses from the result
      String leavingAddress = widget.result['leaving'];
      String destinationAddress = widget.result['destination'];

      // Get LatLng from the addresses
      List<geocoding.Location> leavingLocation =
          await geocoding.locationFromAddress(leavingAddress);
      List<geocoding.Location> destinationLocation =
          await geocoding.locationFromAddress(destinationAddress);

      if (leavingLocation.isNotEmpty && destinationLocation.isNotEmpty) {
        setState(() {
          _leavingP =
              LatLng(leavingLocation[0].latitude, leavingLocation[0].longitude);
          _destinationP = LatLng(destinationLocation[0].latitude,
              destinationLocation[0].longitude);
        });
      }
    } catch (e) {
      print("Error during geocoding: $e");
    }
  }

  //direct the camera to where the user currently is
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 10);
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  //creating a polyline points between the two points in the map
  Future<List<LatLng>> _getPolyLinePoints() async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
        destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      });
    } else {
      print(result.errorMessage);
    }
    return polyLineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("polly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.1),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          leading: IconButton(
            padding: EdgeInsets.only(
                top: screenHeight * 0.043, left: screenWidth * 0.05),
            icon: const Icon(
              Icons.arrow_circle_left_rounded,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(
            margin: EdgeInsets.only(top: screenHeight * 0.045),
            child: Text(
              'Route',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _currentP == null
              ? const Center(
                  child: Text("Loading..."),
                )
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target: _currentP!,
                    zoom: 13,
                  ),
                  markers: {
                    if (_currentP != null)
                      Marker(
                        markerId: MarkerId("_current"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _currentP!,
                      ),
                    if (_leavingP != null)
                      Marker(
                        markerId: MarkerId("_source"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                        position: _leavingP!,
                      ),
                    if (_destinationP != null)
                      Marker(
                        markerId: MarkerId("_destination"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue),
                        position: _destinationP!,
                      ),
                  },
                  polylines: {},
                ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.1,
            maxChildSize: 0.56,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.1,
                  right: screenWidth * 0.1,
                  top: screenHeight * 0.03,
                  bottom: screenHeight * 0.03,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                // color: Colors.white,
                child: ListView(
                  controller: scrollController,
                  children: [
                    Container(
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
                                    widget.result['leaving'],
                                    // 'destination',
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
                                    widget.result['destination'],
                                    // 'destination',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Futura'),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 10),
                    Container(
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
                                  widget.result['date'],
                                  //'destination',
                                  style: TextStyle(fontFamily: 'Futura'),
                                ),
                                SizedBox(width: 100),
                                Icon(
                                  Icons.people,
                                  color: Color.fromRGBO(34, 207, 249, 1),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  widget.result['emptyseats'].toString(),
                                  //'destination',
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                SizedBox(width: 15),
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.result['username'],
                                        //'destination',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'Futura'),
                                      ),
                                      Text(
                                        widget.result['phone'],
                                        //'destination',
                                        style: TextStyle(fontFamily: 'Futura'),
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Center(
                      child: Container(
                        width: screenWidth * 0.5,
                        height: (screenHeight * 0.6) * 0.09,
                        child: ElevatedButton(
                          onPressed: () {
                            _confirmSchedule();
                          },
                          child: Text(
                            'Confirm Schedule',
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
              );
            },
          ),
        ],
      ),
    );
  }

  void _confirmSchedule() async {
    final String url = Global.url;

    try {
      final response = await http.post(
        Uri.parse('$url/schedule'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(widget.result),
      );

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async => false,
              child: AlertDialog(
                title: Text('Success'),
                content: Text('Your ride has been scheduled.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
                  ),
                ],
              ),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('A ride schedule is already pending'),
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
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
