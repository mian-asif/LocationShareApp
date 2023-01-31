import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Directions extends StatefulWidget {
  const Directions({Key? key}) : super(key: key);

  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final Geolocator geolocator = Geolocator();
  TextEditingController location = TextEditingController();
  late Position currentPosition;
  String? currentAddress;
  var userlocation;
  late bool loading=false;
  var placemarks = placemarkFromCoordinates(52.2165157, 6.9437819);
  var cUserserlocationlatitude;
  var cUserserlocationlongitude;
  var cUserposition;
  var userlocationlatitude=Get.arguments[0];
  var userlocationlongitude=Get.arguments[1];
  var lati=Get.arguments[2];
  var longi=Get.arguments[3];
  var _position=Get.arguments[4];
  var locationTag =Get.arguments[5];
  static const double CAMERA_ZOOM = 13;
  static const double CAMERA_TILT = 0;
  static const double CAMERA_BEARING = 30;
  static const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
  static const LatLng DEST_LOCATION = LatLng(42.6871386, -71.2143403);
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyD9uEMmV8BnVSJorDB0ZXrZDGYykE1JEFE";
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;


  @override
  void initState() {
    super.initState();
    loading=true;

    _getAddressFromLatLng(_position);
    setSourceAndDestinationIcons();


  }


  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _position!.latitude, _position!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress = '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
        loading=false;
      });
    }).catchError((e) {
      debugPrint(e);
    });

  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/locationicon.png',);
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/images/locationicon2.png');
  }

  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    CameraPosition initialLocation = CameraPosition(
        zoom: CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
        target: LatLng(lati, longi)
    );
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        toolbarHeight: 140,
        leading: Padding(
          padding:  EdgeInsets.only(bottom: cHeight*0.15),
          child: IconButton(
            onPressed: (){ Get.back();},icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Color(0xFF454F63),size: 30,),
          ),
        ),
        title: Stack(
          children: [
            Column(

              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        // print('hello asif  1$cUserserlocationlongitude');
                        // print('hello asif$cUserserlocationlatitude');
                        // print(cUserserlocationlongitude);
                        // print(cUserserlocationlatitude);
                        print(currentAddress);
                      },
                        child: const Icon(Icons.location_searching,color: Colors.blue,)),
                    Padding(
                        padding:  EdgeInsets.only(left: 10.0,),
                        child:Container(
                          width: MediaQuery.of(context).size.width*0.6,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),

                          ),
                          child:loading ? LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.greenAccent,
                            size: 20,
                          ): Center(child: Text('$currentAddress',style: const TextStyle(color: Colors.black,fontSize: 12))),
                        )
                    )
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_sharp,color: Colors.blue,),
                      Padding(
                          padding:  EdgeInsets.only(left: 10.0,),
                          child:Container(
                            width: MediaQuery.of(context).size.width*0.6,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey),


                            ),
                            child: Center(child: Text('$locationTag',style: const TextStyle(color: Colors.black,fontSize: 12))),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
        floatingActionButton:Padding(
          padding:  EdgeInsets.only(bottom: cHeight*0.1),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //
          //
          //     PullDownButton(
          //       backgroundColor: Color(0xff5A5E64),
          //       itemBuilder: (context) => [
          //         PullDownMenuItem(
          //           title: 'Share Location Inside App',
          //           textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
          //           onTap: () {
          //             displayTextInputDialog(context);
          //           },
          //         ),
          //         const PullDownMenuDivider(),
          //         PullDownMenuItem(
          //
          //           title: 'Share Location Outside App',
          //           textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
          //           onTap: () {},
          //         ),
          //       ],
          //       position: PullDownMenuPosition.above,
          //       buttonBuilder: (context, showMenu) => CupertinoButton(
          //         onPressed: showMenu,
          //         padding: EdgeInsets.zero,
          //         child: Padding(
          //           padding:  EdgeInsets.only(bottom:cHeight*0.035),
          //           child:Container(height: 55,width: 57,decoration: BoxDecoration
          //             (borderRadius: BorderRadius.circular(10),color: Colors.white,
          //             boxShadow: const [
          //               BoxShadow(
          //                 color: Colors.grey,
          //                 blurRadius: 4,
          //                 offset: Offset(1, 2), // Shadow position
          //               ),
          //             ],
          //           ),
          //             child: const Icon(Icons.share,color: Color(0XFFFF5566),size: 35),),
          //         ),
          //       ),
          //     ),
          //     Padding(
          //       padding:  EdgeInsets.only(bottom:cHeight*0.045),
          //       child: FloatingActionButton(
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10)
          //         ),
          //         backgroundColor: const Color(0XFFFFFFFF),
          //         onPressed: () async {
          //           Position currentPosition = await getGeoLocationPosition();
          //           setState((){
          //             userlocation =  currentPosition;
          //             userlocationlatitude =  currentPosition.latitude;
          //             userlocationlongitude =  currentPosition.longitude;
          //           });
          //           if (kDebugMode) {
          //             // print(currentPosition.latitude);
          //           }
          //           LatLng newlatlang = LatLng(31.4542945,74.3656344);
          //           mapController.animateCamera(
          //               CameraUpdate.newCameraPosition(
          //                   CameraPosition(target: newlatlang, zoom: 20)
          //                 //17 is new zoom level
          //               )
          //           );
          //           //move position of map camera to new location
          //           // determinePosition();
          //
          //
          //         },
          //         child: const Icon(Icons.my_location,color: Color(0XFF0091C4),size: 35),
          //       ),
          //     ),
          //   ],
          // ),
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding:  EdgeInsets.only(top: cHeight*0.00),
                  child: SizedBox(
                    height: cHeight*0.82,
                    width: cWidth,
                    // decoration: BoxDecoration(border: Border.all(color: const Color(0xFF707070),width: 2)),
                    child:GoogleMap(
                      zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: false,
                        markers: _markers,
                        polylines: _polylines,
                        mapType: MapType.normal,
                        initialCameraPosition: initialLocation,
                        onMapCreated: onMapCreated),
                  )

              )],
          ),
        )
    );
  }
  void onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(norml.mapStyles);
    _controller.complete(controller);
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position:  LatLng(lati, longi),
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(userlocationlatitude, userlocationlongitude),
          icon: destinationIcon));
    });
  }

  setPolylines() async {

    PolylineResult result = (await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,


       PointLatLng(lati,longi),
        PointLatLng(userlocationlatitude, userlocationlongitude),
      travelMode: TravelMode.driving


    ));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: const PolylineId("poly"),
          color: const Color.fromARGB(255, 40, 122, 198),
          points: polylineCoordinates);
      _polylines.add(polyline);
    });
  }

}

