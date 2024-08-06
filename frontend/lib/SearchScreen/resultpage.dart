// import 'package:flutter/material.dart';
//
// class ResultsPage extends StatelessWidget {
//   final List<dynamic> results;
//
//   ResultsPage({required this.results});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Search Results'),
//       ),
//       body: ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           final result = results[index];
//           return ListTile(
//             title: Text('Leaving: ${result['leaving']}'),
//             subtitle: Text(
//                 'Destination: ${result['destination']} - Date: ${result['date']} - Empty Seats: ${result['emptyseats']}'),
//             // Add any other UI elements as needed
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import '../MAPS/map_page.dart';
import 'package:yeti_yatra_project/MAPS/map_page_two.dart';

class ResultsPage extends StatelessWidget {
  final List<dynamic> results;
  final username;
  final phone;
  final noOfpassengers;

  // Create a GlobalKey for the Scaffold
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  ResultsPage({required this.results, required this.username, required this.phone, required this.noOfpassengers});


  @override
  Widget build(BuildContext context) {
    List<dynamic> sortedResults = List.from(results);
    sortedResults.sort((a, b) => a['emptyseats'].compareTo(b['emptyseats']));

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(243, 243, 238, 1),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.12),
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
                'Search Results',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: sortedResults.length,
          itemBuilder: (context, index) {
            final result = sortedResults[index];
            return GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(result: result, username: username, phone: phone, noOfpassengers: noOfpassengers),
                  ),
                );

              },
              child: Card(
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                    top: screenHeight * 0.03,
                    bottom: screenHeight * 0.03,
                  ),
                  height: screenHeight * 0.39,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
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
                                      result['leaving'],
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
                                      result['destination'],
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
                                    result['date'],
                                    style: TextStyle(fontFamily: 'Futura'),
                                  ),
                                  SizedBox(width: 100),
                                  Icon(
                                    Icons.people,
                                    color: Color.fromRGBO(34, 207, 249, 1),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    result['emptyseats'].toString(),
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
                                  SizedBox(width: 15),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(result['username'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20, fontFamily: 'Futura'),),
                                        Text(result['phone'], style: TextStyle(fontFamily: 'Futura'),),
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // void _showBookingDialog(BuildContext context, dynamic result) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Confirm Booking'),
  //         content: Text('Are you sure you want to book this ride?'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //               _bookRide(context, result); // Pass context to _bookRide
  //             },
  //             child: Text('Yes'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: Text('No'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  // void _bookRide(BuildContext context, dynamic result) async {
  //   try {
  //     await KhaltiScope.of(context).pay(
  //       config: PaymentConfig(
  //         amount: 10000, // Example amount in paisa (100 paisa = 1 unit)
  //         productIdentity:
  //             "ProductId_${result['id']}", // Unique product identity
  //         productName: "ProductName_${result['destination']}",
  //       ),
  //       onSuccess: (PaymentSuccessModel success) {
  //         // Use the scaffoldMessengerKey to get the ScaffoldMessenger context
  //         if (scaffoldMessengerKey.currentContext != null) {
  //           _showPaymentResultDialog(scaffoldMessengerKey.currentContext!,
  //               true); // Show success dialog
  //         }
  //         print('Payment successful: ${success.toString()}');
  //         print(
  //             'Ride booked: ${result['leaving']} to ${result['destination']}');
  //       },
  //       onFailure: (PaymentFailureModel failure) {
  //         if (scaffoldMessengerKey.currentContext != null) {
  //           _showPaymentResultDialog(scaffoldMessengerKey.currentContext!,
  //               false); // Show failure dialog
  //         }
  //         print('Payment failed: ${failure.toString()}');
  //       },
  //       onCancel: () {
  //         if (scaffoldMessengerKey.currentContext != null) {
  //           _showPaymentResultDialog(scaffoldMessengerKey.currentContext!,
  //               false); // Show cancel dialog
  //         }
  //         print('Payment cancelled');
  //       },
  //     );
  //   } catch (e) {
  //     // Handle any exceptions that might occur
  //     print('Exception occurred: $e');
  //   }
  // }
  //
  // void _showPaymentResultDialog(BuildContext context, bool success) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(success ? "Payment Successful" : "Payment Failed"),
  //         content: Text(success
  //             ? "Your payment was successful. Thank you for booking!"
  //             : "Your payment failed. Please try again."),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
