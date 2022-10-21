import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:locate_family/CustomWidgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:locate_family/Deractions/directions.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:animated_shimmer/animated_shimmer.dart';
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }
  var myUsername='';
  var myEmail = '';
  var myPhone = '';
  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('users')
        .where("user_uid", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var userData in querySnapshot.docs) {
        setState(() {
          myUsername = userData['full_name'];
          myEmail = userData['email'];
          myPhone = userData['phone'];
          loading=false;
          // print(myPhone);
        });
      }
    });
  }
  Position? _position;

  var colorsChange=Colors.green;
  var cUserserlocationlongitude;
  bool loading=true;
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

    return loading?  Scaffold(
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child:   LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.greenAccent,
              size: 50,
            ),
          ),
        ],
      )
    ):
    Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.only(
          left: cWidth*0.0,
          right: cWidth*0.0,
          top: cHeight*0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.06),
              child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xFF454F63),)),
            ),
            Padding(
              padding:  EdgeInsets.only(left:cWidth*0.09),
              child: Text('Notifications',style: TextConstants.pageTittle,),
            ),
            //'A place to see any locations received'
            Padding(
              padding:  EdgeInsets.only(left:cWidth*0.09,top: cHeight*0.01),
              child: Text('A place to see any activity and notifications',style: TextConstants.brownText,),
            ),
            SizedBox(
              height: cHeight*0.7,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('notifications').where("receiverNumber", isEqualTo: myPhone,).snapshots(),
                builder: (context, snapshot) {
                  var snapm = snapshot.data?.docs.isNotEmpty;
                  var snapt = snapshot.data?.docs.isEmpty;
                  if (snapt == true) {
                    return EmptyWidget(

                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'No notification',
                      subTitle: 'No notification \n available yet',
                      titleTextStyle: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ) ;
                  }
                  else if(snapm == true ) {
                    // got data from snapshot but it is empty

                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          var senderName = doc['senderName'];
                          var  senderUid = doc['senderUid'];
                          var senderPhone = doc['senderPhone'];
                          var  senderImage = doc['senderImage'];
                          var status = doc['status'];
                          var msg = doc['msg'];
                          var receiverNumber = doc['receiverNumber'];
                          var  docID = (doc.id);
                          return  notificationCard(context,color: Colors.green,text: '$senderName$msg');
                        }) ;
                  }
                  else {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.greenAccent,
                        size: 50,
                      ),
                    ) ;
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
