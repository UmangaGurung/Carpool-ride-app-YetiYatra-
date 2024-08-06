import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../RideDetails/ride_details_page.dart';

class SearchResultModel extends StatelessWidget {
  String profilePicture;
  String driver;
  String phoneNumber;
  bool isHistoryPage;
  bool? isCompleted;
  SearchResultModel(
      {super.key,
      required this.profilePicture,
      required this.driver,
      required this.phoneNumber,
      required this.isCompleted,
      required this.isHistoryPage});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
      height: 310,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            child: Row(children: [
              Container(
                  child: Column(children: [
                CircleAvatar(
                    backgroundColor: Color.fromRGBO(34, 207, 249, 1),
                    child: Icon(Icons.home, color: Colors.white, size: 30)),
                Container(
                  height: 30,
                  width: 3,
                  color: Color.fromRGBO(34, 207, 249, 1),
                ),
                CircleAvatar(
                    backgroundColor: Color.fromRGBO(34, 207, 249, 1),
                    child: Icon(Icons.place, color: Colors.white, size: 30))
              ])),
              SizedBox(
                width: 30,
              ),
              Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Leaving From'),
                      Text("New Baneshwor, Kathmandu",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Going To'),
                      Text("Lakeside-7, Pokhara",
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ]),
              ),
            ]),
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
                  Text("21st June 2024"),
                  SizedBox(width: 30),
                  Icon(
                    Icons.people,
                    color: Color.fromRGBO(34, 207, 249, 1),
                  ),
                  SizedBox(width: 8),
                  Text('3'),
                ],
              )),
              SizedBox(
                height: 20,
              ),
              Container(
                  child: Row(children: [
                Container(
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage(profilePicture),
                              fit: BoxFit.cover),
                        ))),
                SizedBox(width: 20),
                Container(
                    child: Column(
                  children: [
                    Text(driver,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text(phoneNumber),
                    SizedBox(height: 10)
                  ],
                ))
              ])),
              Padding(
                padding: const EdgeInsets.only(left: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ratings"),
                    Container(
                      child: isHistoryPage
                          ? Container(
                              decoration: isCompleted!
                                  ? BoxDecoration(
                                      color: Colors.green,
                                    )
                                  : BoxDecoration(color: Colors.red),
                              child: isCompleted!
                                  ? Text(
                                      'Completed',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text('Cancelled,',
                                      style: TextStyle(color: Colors.white)))
                          : null,
                    ),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}

// class SearchResultModel extends StatelessWidget {
//   final List<dynamic> results;
//   SearchResultModel({super.key, required this.results});
//
//   @override
//   Widget build(BuildContext context) {
//     List<dynamic> sortedResults = List.from(results);
//     sortedResults.sort((a, b) => a['emptyseats'].compareTo(b['emptyseats']));
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SafeArea(
//       child: ListView.builder(
//         padding: EdgeInsets.only(left: screenWidth*0.01, right: screenWidth*0.01, top: screenHeight*0.01, bottom: screenHeight*0.01),
//         itemCount: sortedResults.length,
//         itemBuilder: (context, index) {
//           final result = sortedResults[index];
//           return Container(
//             padding: EdgeInsets.all(10),
//             height: screenHeight*0.5,
//             width: screenWidth*0.5,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Color.fromRGBO(34, 207, 249, 1),
//                       child: Icon(Icons.home, color: Colors.white, size: 30),
//                     ),
//                     SizedBox(width: 30),
//                     CircleAvatar(
//                       backgroundColor: Color.fromRGBO(34, 207, 249, 1),
//                       child: Icon(Icons.place, color: Colors.white, size: 30),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10),
//                 Divider(),
//                 SizedBox(height: 10),
//                 Text(
//                   'Leaving From',
//                   style: TextStyle(fontFamily: 'Futura'),
//                 ),
//                 Text(
//                   result['leaving'],
//                   style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura'),
//                 ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Going To',
//                   style: TextStyle(fontFamily: 'Futura'),
//                 ),
//                 Text(
//                   result['destination'],
//                   style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Futura'),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_month, color: Color.fromRGBO(34, 207, 249, 1)),
//                     SizedBox(width: 8),
//                     Text(
//                       result['date'],
//                       style: TextStyle(fontFamily: 'Futura'),
//                     ),
//                     SizedBox(width: 30),
//                     Icon(Icons.people, color: Color.fromRGBO(34, 207, 249, 1)),
//                     SizedBox(width: 8),
//                     Text(
//                       '${result['emptyseats']}',
//                       style: TextStyle(fontFamily: 'Futura'),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Container(
//                       height: 60,
//                       width: 60,
//                       decoration: BoxDecoration(
//                         color: Color.fromRGBO(34, 207, 249, 1),
//                         borderRadius: BorderRadius.circular(50),
//                         image: DecorationImage(
//                           image: AssetImage('path_to_image'), // Replace with dynamic image if available
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           result['username'], // Driver's name
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 20, fontFamily: 'Futura'),
//                         ),
//                         Text(
//                           result['phone'], // Driver's phone number
//                           style: TextStyle(fontFamily: 'Futura'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Spacer(),
//                 Text(
//                   'Ratings',
//                   style: TextStyle(fontFamily: 'Futura'),
//                 ),
//                 // Add conditional logic for 'isHistoryPage' and 'isCompleted' if applicable
//                 // For demonstration, this part is omitted
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
