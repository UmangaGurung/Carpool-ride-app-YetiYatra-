// import 'package:flutter/material.dart';
// import 'package:yeti_yatra_project/esewa/esewa.dart';
//
// void main(){
//   runApp(EsewaScreen());
// }
//
// class EsewaScreen extends StatelessWidget {
//   const EsewaScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: EsewaApp(),
//     );
//   }
// }
//
// class EsewaApp extends StatefulWidget {
//   const EsewaApp({super.key});
//
//   @override
//   State<EsewaApp> createState() => _EsewaAppState();
// }
//
// class _EsewaAppState extends State<EsewaApp> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Esewa Integration'),
//       ),
//       body:
//         ElevatedButton(
//           child: Text('Pay with e-sewa'),
//           onPressed: (){
//             Esewa esewa= Esewa();
//             esewa.pay();
//           },
//         )
//     );
//   }
// }
//
