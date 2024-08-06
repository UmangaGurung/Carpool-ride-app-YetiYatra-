// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'keys.dart';
// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:flutter/material.dart';
//
// class Esewa {
//   pay(){
//     try{
//       EsewaFlutterSdk.initPayment(
//         esewaConfig: EsewaConfig(
//           environment: Environment.test,
//           clientId: kEsewaCLientId,
//           secretId: kEsewaSecretKey,
//         ),
//         esewaPayment: EsewaPayment(
//           productId: "1d71jd81",
//           productName: "Product One",
//           productPrice: "20",
//         ),
//         onPaymentSuccess: (EsewaPaymentSuccessResult data) {
//           debugPrint(":::SUCCESS::: => $data");
//         },
//         onPaymentFailure: (data) {
//           debugPrint(":::FAILURE::: => $data");
//         },
//         onPaymentCancellation: (data) {
//           debugPrint(":::CANCELLATION::: => $data");
//         },
//       );
//     }catch(e){
//
//     }
//   }
// }