import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home2(),
    );
  }
}

class home2 extends StatefulWidget {
  const home2({super.key});

  @override
  State<home2> createState() => _home2State();
}

class _home2State extends State<home2> {
  LatLng? mylatlong;
  String address = 'Unknown';
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where permissions are denied.
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Handle the case where permissions are permanently denied.
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    LatLng userLatLng = LatLng(position.latitude, position.longitude);
    setMarker(userLatLng);
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(userLatLng, 14));
  }

  Future<void> setMarker(LatLng value) async {
    mylatlong = value;

    List<Placemark> result =
    await placemarkFromCoordinates(value.latitude, value.longitude);

    if (result.isNotEmpty) {
      address =
      '${result[0].name}, ${result[0].locality} ${result[0].administrativeArea}';
    }

    setState(() {});
  }

  Future<void> _searchAndNavigate(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        LatLng newLatLng =
        LatLng(locations[0].latitude, locations[0].longitude);
        setMarker(newLatLng);
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 14));
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Set your tasks',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.notifications,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                  hintText: 'Search location',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // Removes the default border
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF5F33E2), // Outline color when focused
                      width: 5.0, // Outline width when focused
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Outline color when enabled
                      width: 4, // Outline width when enabled
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onSubmitted: (value) {
                  _searchAndNavigate(value);
                },
              ),
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition:
                CameraPosition(target: LatLng(0, 0), zoom: 2),
                markers: mylatlong != null
                    ? {
                  Marker(
                    infoWindow: InfoWindow(title: address),
                    position: mylatlong!,
                    draggable: true,
                    markerId: const MarkerId('1'),
                    onDragEnd: (value) {
                      setMarker(value);
                    },
                  ),
                }
                    : {},
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  if (mylatlong != null) {
                    _mapController.animateCamera(
                        CameraUpdate.newLatLngZoom(mylatlong!, 14));
                  }
                },
                onTap: (value) {
                  setMarker(value);
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}