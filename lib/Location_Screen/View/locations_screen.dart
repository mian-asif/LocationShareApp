import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locate_family/CustomWidgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locate_family/Deractions/directions.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class LocationsScreen extends StatefulWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    getCurrentUser();




  }

  Position? _position;
  var myPhone='000';
  var myEmail='';
  var myUsername='';
  getCurrentUser() async {
   await FirebaseFirestore.instance
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
  void _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
      cUserserlocationlatitude =_position?.latitude;
      cUserserlocationlongitude =_position?.longitude;
    });
  }
  var cUserserlocationlatitude;
  var cUserserlocationlongitude;
  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
// When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  @override
  final FirebaseAuth auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
   var cHeight=MediaQuery.of(context).size.height;
   var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
         backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.only(
          left: cWidth*0.08,
          right: cWidth*0.08,
          top: cHeight*0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xFF454F63),)),
             Padding(
               padding:  EdgeInsets.only(left:cWidth*0.03),
               child: Text('Locations',style: TextConstants.pageTittle,),
             ),
             //'A place to see any locations received'
             Padding(
               padding:  EdgeInsets.only(left:cWidth*0.03,top: cHeight*0.01),
               child: Text('A place to see any locations received',style: TextConstants.brownText,),
             ),
            SizedBox(
              height: cHeight*0.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('locations').where('friendEmail',isEqualTo: myEmail).snapshots(),
                builder: (context, snapshot) {
                  var snapm = snapshot.data?.docs.isNotEmpty;
                  var snapt = snapshot.data?.docs.isEmpty;
                  if (snapt == true) {
                    return EmptyWidget(

                      image: null,
                      packageImage: PackageImage.Image_4,
                      title: 'No Locations',
                      subTitle: 'You Have No Locations \n  yet',
                      titleTextStyle: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    );
                  }
                  else if(snapm == true) {
                    // got data from snapshot but it is empty

                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          var  receiverEmail = (doc['receiverEmail']);
                          var  receiverName = (doc['receiverName']);
                          var  receiverProfile = (doc['receiverProfile']);
                          var  receiverPhone = (doc['receiverPhone']);
                          var  receiverUid = (doc['receiverUid']);
                          var  senderEmail = (doc['senderEmail']);
                          var  senderName = (doc['senderName']);
                          var  senderPhone = (doc['senderPhone']);
                          var  senderPhoto = (doc['senderPhoto']);
                          var  senderUid = (doc['senderUid']);
                          var  locationTag = (doc['locationTag']);
                          var  userlocationlatitude = (doc['userlocationlatitude']);
                          var  userlocationlongitude = (doc['userlocationlongitude']);
                          var  docID = (doc.id);
                          return  InkWell(
                              onTap: (){
                                Get.to(const Directions(),arguments: [userlocationlatitude,userlocationlongitude,cUserserlocationlatitude,cUserserlocationlongitude,_position,locationTag],);
                              },
                              child: locationCard(context,locationTag: locationTag,senderName: senderName));
                        }) ;
                  }
                  else {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                    );
                  }
                },
              ),
            ),


          ],
        ),
      ),

    );
  }
}
