// import 'dart:async';
//
// import 'package:flutter/material.dart';
//
//
// class SplashScreen extends StatefulWidget {
//
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//
//     super.initState();
//     Timer(Duration(seconds: 3), ()
//     {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => startWidget,));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Colors.white,
//       body:Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children:
//           [
//             Image.asset('Assets/Images/news.jpg', height: 200.0,),
//             const SizedBox(height: 20.0,),
//             CircularProgressIndicator(
//               valueColor:AlwaysStoppedAnimation<Color>(Colors.deepOrange) ,),
//           ],
//         ),
//       ) ,
//     );
//   }
// }