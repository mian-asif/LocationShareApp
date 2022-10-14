import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../CustomWidgets/custom_widgets.dart';
import '../../LogIn-Screen/View/login_screen.dart';
import '../../ShareLocationWithFriends/share_location_with_friends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationTextFieldController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  var myPhone='';
  var myEmail='';
  var myUsername='';
  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('users')
        .where("user_uid", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          myUsername = userData['full_name'];
          myEmail = userData['email'];
          myPhone = userData['phone'];
        });
      });
    });
  }
  var userlocation;
  var userlocationlongitude;
  var userlocationlatitude;
  static const LatLng _kMapCenter =
  LatLng(31.4661398, 74.3704655);

  static const CameraPosition _kInitialPosition = CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);

  CameraPosition initialPosition = const CameraPosition(target: LatLng(26.8206, 30.8025));
  // Completer<GoogleMapController> controller = Completer();
  GoogleMapController? mapController;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    print('Hello:$position');
    setState((){

    });
    return position;

  }
  // Current Location
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
  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Share your location with a tag to hide your identity'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  // valueText = value;
                });
              },
              controller: locationTextFieldController,
              decoration: const InputDecoration(hintText: "tag name"),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL',style: TextStyle(color: Color(0xff0091C4))),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('Add',style: TextStyle(color: Color(0xff0091C4))),
                onPressed: () {

                  setState(() {
                    // codeDialog = valueText;
                    Navigator.pop(context);
                  });
                  displayTextInputDialogShareLocation(context);
                },

              ),

            ],
          );
        });
  }
  Future<void> displayTextInputDialogShareLocation(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Location tag has been added you can share now'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL',style: TextStyle(color: Color(0xff0091C4))),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('Share',style: TextStyle(color: Color(0xff0091C4))),
                onPressed: () {
                  setState(() {
                    // codeDialog = valueText;
                   Get.to(const ShareLocationWithFriends(),arguments: [locationTextFieldController.text,userlocationlongitude,userlocationlatitude]);
                  });
                },
              ),

            ],
          );
        });
  }
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(const LogInScreen());
  }


  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer:  Drawer(
          backgroundColor: Color(0XFF2A2E43),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/drawerBack.png"),
                  fit: BoxFit.cover,
                )
              ),
              height: cHeight*0.3,
              child: Row(
                 children: [
                   Stack(
                     children: [
                       Padding(
                         padding:  EdgeInsets.only(
                             top: cHeight*0.07,
                             left: cWidth*0.08
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(

                               height: 64,
                               width: 64,
                               decoration: BoxDecoration(
                                   color: Colors.blue,
                                   borderRadius: BorderRadius.circular(10)
                               ),
                             ),
                             Padding(
                               padding: const EdgeInsets.only(top: 8.0),
                               child:  Text(myUsername,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.white),),
                             ),
                             Padding(
                               padding: const EdgeInsets.only(top: 3.0),
                               child:  Text(myEmail,style: const TextStyle(color: Colors.white)),
                             )

                           ],
                         ),
                       ),
                       Padding(
                         padding:  EdgeInsets.only(left: cWidth*0.6,bottom: 0),
                         child: IconButton(onPressed: (){
                           Get.back();
                         }, icon: Icon(Icons.backspace,color: Colors.white,)),
                       ),
                     ],
                   ),


                 ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 18.0,top: 10),
              child: TextButton(onPressed: (){}, child: Text('Profile',style: const TextStyle(
                fontWeight: FontWeight.w400,color: Colors.white,
                fontSize: 20
              ),)),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 18.0,top: 10),
              child: TextButton(onPressed: (){
                logout();
              }, child: Text('Logout',style: const TextStyle(
                fontWeight: FontWeight.w400,color: Colors.white,
                fontSize: 20
              ),)),
            ),

          ]),
        ),
        floatingActionButton:Padding(
          padding:  EdgeInsets.only(bottom: cHeight*0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [


          PullDownButton(
            backgroundColor: Color(0xff5A5E64),
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: 'Share Location Inside App',
                 textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                onTap: () {
                  displayTextInputDialog(context);
                },
              ),
              const PullDownMenuDivider(),
              PullDownMenuItem(

                title: 'Share Location Outside App',
                textStyle: const TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                onTap: () {},
              ),
            ],
            position: PullDownMenuPosition.above,
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: Padding(
                padding:  EdgeInsets.only(bottom:cHeight*0.035),
                child:Container(height: 55,width: 57,decoration: BoxDecoration
                  (borderRadius: BorderRadius.circular(10),color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      offset: Offset(1, 2), // Shadow position
                    ),
                  ],
                ),
                  child: const Icon(Icons.share,color: Color(0XFFFF5566),size: 35),),
              ),
            ),
          ),
              Padding(
                padding:  EdgeInsets.only(bottom:cHeight*0.045),
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
            ],
          ),
        ),
        key: scaffoldKey,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.0),
                child: foodRequestSearchBar(context,onTap: (){scaffoldKey.currentState!.openDrawer();}),
              ),
              Padding(
                  padding:  EdgeInsets.only(top: cHeight*0.00),
                  child: SizedBox(
                    height: cHeight*0.82,
                    width: cWidth,
                    // decoration: BoxDecoration(border: Border.all(color: const Color(0xFF707070),width: 2)),
                    child:   GoogleMap(
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

              )],
          ),
        )
      ),
    );
  }
}
