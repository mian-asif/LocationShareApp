import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:locate_family/Food_Request_Details/View/food_request_details_screen.dart';import '../../CustomWidgets/constants.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
class AddYourFoodLocationScreen extends StatefulWidget {
  const AddYourFoodLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddYourFoodLocationScreen> createState() => _AddYourFoodLocationScreenState();
}

class _AddYourFoodLocationScreenState extends State<AddYourFoodLocationScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dateController = TextEditingController();
  CameraPosition initialPosition = const CameraPosition(target: LatLng(26.8206, 30.8025));
  GoogleMapController? mapController;
  LatLng startLocation = const LatLng(27.6602292, 85.308027);
  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  var userlocation;
  var userlocationlongitude;
  var userlocationlatitude;
  String? currentAddress;

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        userlocation!.latitude, userlocation!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress = '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom:cHeight*0.26),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: const Color(0XFFFFFFFF),
            onPressed: () async {
              Position currentPosition = await getGeoLocationPosition();
              setState((){
                userlocation =  currentPosition;
                userlocationlatitude =  currentPosition.latitude;
                userlocationlongitude =  currentPosition.longitude;
              });
              if (kDebugMode) {
                // print(currentPosition.latitude);
              }
              LatLng newlatlang = LatLng(31.4542945,74.3656344);
              mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 20)
                    //17 is new zoom level
                  )
              );
              //move position of map camera to new location
              // determinePosition();

            },
          child: const Icon(Icons.my_location,color: Color(0XFF0091C4),size: 35),
        ),
      ),
      key: scaffoldKey,

      body: Padding(
        padding:  EdgeInsets.only(
          top: cHeight*0.06,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:  EdgeInsets.only(
                  left: cWidth*0.08,
                ),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xFF454F63),)),
              ),
              Padding(padding:  EdgeInsets.only(left: cWidth*0.08,),
                child: Text('Add Your Location',style: TextConstants.foodRequestTittle,),
              ),
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.02),
                child: foodRequestSearchBar(context,onTap: (){scaffoldKey.currentState!.openDrawer();}),
              ),
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.00),
                child: Container(
                  height: cHeight*0.58,
                  width: cWidth,
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF707070),width: 2)),
                  child:GoogleMap(
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,

                    initialCameraPosition: CameraPosition( //innital position in map
                      target: startLocation, //initial position
                      zoom: 14.0, //initial zoom level
                    ),
                    mapType: MapType.normal, //map type
                    onMapCreated: (controller) { //method called when map is created
                      setState(() {
                        mapController = controller;
                      });
                    },
                  ),
                )
              ),


              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.03 ),
                child: Center(child: customButton(onPressed: () async {
                 await _getAddressFromLatLng(userlocation);
                  Get.off(const FoodRequestDetailsScreen(),arguments: [userlocation,userlocationlongitude,userlocationlatitude,currentAddress]);
                },buttonTittle: 'Submit')),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
