import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'SearchScreen/search_page.dart';
import 'publish/publishtwo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profiletwo.dart';
import 'package:yeti_yatra_project/HistoryScreen/history_page.dart';
import 'Notification_new/notification.dart';
import 'welcome.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  runApp(YetiApp(token: token));
}

class YetiApp extends StatelessWidget {
  final token;
  const YetiApp({@required this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != null && !JwtDecoder.isExpired(token!)
          ? MainScaffold(token: token!) // Use token! to assert non-nullability
          : CardWidget(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  final token;
  const MainScaffold({@required this.token, Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  int? checkCallBack = 0;
  String? title;
  IconData? icon;
  Color customColor = Color.fromRGBO(250, 250, 250, 0.9);

  TextEditingController _leavingFrom = TextEditingController();
  String _originalText = '';

  @override
  void dispose() {
    super.dispose();
  }

  void _onSearchPressed() async {
    final TextEditingController _modalController = TextEditingController();

    setState(() {
      checkCallBack = 1;
      customColor = Colors.blue;
      title = 'Leaving From';
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
                    Expanded(
                      child: GestureDetector(
                        child: TextFormField(
                          // enabled: false,
                          controller: _leavingFrom,
                          decoration: InputDecoration(
                            hintText: 'Leaving From',
                            labelStyle: TextStyle(fontFamily: 'Futura'),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _originalText = _leavingFrom.text;
                          Navigator.pop(context); // Close the slide-up window
                        });
                      },
                      child: Text('Submit'),
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
                      child: GestureDetector(
                        child: TextFormField(
                          // enabled: false,
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
    final List<PreferredSizeWidget> appBars = [
      PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.15),
        child: AppBar(
          toolbarHeight: 200,
          elevation: checkCallBack == 1 ? 10 : 0,
          backgroundColor: Color.fromRGBO(248, 248, 251, 1),
          leadingWidth: 140,
          title: checkCallBack == 1
              ? Text(
                  'Leaving From',
                  style: TextStyle(fontFamily: 'Futura'),
                )
              : checkCallBack == 2
                  ? Text(
                      'Going To',
                      style: TextStyle(fontFamily: 'Futura'),
                    )
                  : null,
          leading: customColor == Colors.blue
              ? Icon(icon)
              : Container(
                  width: screenWidth,
                  height: screenHeight * 0.31,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: screenWidth * 0.6,
                    backgroundColor: Color.fromRGBO(248, 248, 251, 1),
                    child: ClipOval(
                      child: Image.asset(
                        'images/yeticon.png',
                        fit: BoxFit.cover,
                        height: screenHeight * 1.2,
                        width: screenWidth * 1.2,
                      ),
                    ),
                  ),
                ),
        ),
      ),
      PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.045, left: screenWidth * 0.03),
            child: Text(
              'Schedule a Ride',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.045, left: screenWidth * 0.03),
            child: Text(
              'History',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.045, left: screenWidth * 0.03),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
      PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.12),
        child: AppBar(
          backgroundColor: Color.fromRGBO(34, 207, 249, 1),
          automaticallyImplyLeading: false,
          title: Container(
            margin: EdgeInsets.only(
                top: screenHeight * 0.045, left: screenWidth * 0.03),
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color.fromRGBO(255, 255, 255, 1),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    ];

    List<Widget> screens = [
      SearchPage(token: widget.token),
      PublishPage(token: widget.token),
      HistoryPage(token: widget.token),
      NotificationsPage(token: widget.token),
      ProfileState(token: widget.token),
    ];

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 251, 1),
        resizeToAvoidBottomInset: true,
        appBar: appBars[_selectedIndex],
        body: screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          currentIndex: _selectedIndex,
          elevation: 0,
          backgroundColor: Colors.white38,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Color.fromRGBO(34, 207, 249, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Search',
              icon: Icon(
                Icons.search,
                color: Color.fromRGBO(34, 207, 249, 1),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Publish',
              icon: Icon(Icons.add_box_outlined),
            ),
            BottomNavigationBarItem(
              label: 'History',
              icon: Icon(Icons.history),
            ),
            BottomNavigationBarItem(
              label: 'Notification',
              icon: Icon(Icons.notifications),
            ),
            BottomNavigationBarItem(
              label: 'Profile',
              icon: Icon(Icons.person_outline), // Add Profile icon here
            ),
          ],
        ),
      ),
    );
  }
}

// class HistoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('History Page'),
//     );
//   }
// }
