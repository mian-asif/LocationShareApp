// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() => runApp(MaterialApp(
//   debugShowCheckedModeBanner: false,
//   home: MapPage(),
// ));
//
//
// class MapPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => MapPageState();
// }
//
// class MapPageState extends State<MapPage> {
//   var userlocationlatitude=Get.arguments[0];
//   var userlocationlongitude=Get.arguments[1];
//
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GoogleMap(
//         myLocationEnabled: true,
//         compassEnabled: true,
//         tiltGesturesEnabled: false,
//         markers: _markers,
//         polylines: _polylines,
//         mapType: MapType.normal,
//         initialCameraPosition: initialLocation,
//         onMapCreated: onMapCreated);
//   }
//
//
// }
