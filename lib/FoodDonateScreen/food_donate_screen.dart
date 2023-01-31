import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_family/Food_Request_Details/View/food_request_details_screen.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../FoodRequestSenderDetails/food_request_sender_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FoodDonersDetailsScreen/View/food_doners_Details_Screen.dart';
class FoodDonateScreen extends StatefulWidget {
  const FoodDonateScreen({Key? key}) : super(key: key);

  @override
  State<FoodDonateScreen> createState() => _FoodDonateScreenState();
}

class _FoodDonateScreenState extends State<FoodDonateScreen> {
  // bool donateButtonPress= Get.arguments[0];
  // bool requestButtonPress=Get.arguments[1];
  final databaseReference = FirebaseFirestore.instance.collection('foodRequest');
  final FirebaseAuth auth = FirebaseAuth.instance;
  // var userlocation;
  // var userlocationlongitude;
  // var userlocationlatitude;
  // var address='';
  bool loaging = true;
  @override
  void initState() {
    super.initState();
    // getCurrentUser();
    getCurrentUserData();
    // print(donateButtonPress.toString());
    // print(requestButtonPress.toString());
  }

  // var documentsLenth;
  // var myEmail;
  // var myUsername;
  // var userUid;
  // var photoURL;
  var myUid;
  late num viewNumber= 0;
  // getCurrentUser()  async {
  //
  //   await FirebaseFirestore.instance
  //       .collection('foodDonate')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((userData) {
  //       setState(() {
  //         documentsLenth = querySnapshot.docs.length;
  //         // myEmail = userData['email'];
  //       });
  //     });
  //   });
  //   setState((){
  //     loaging = false;
  //   });
  // }


  getCurrentUserData() {
    FirebaseFirestore.instance
        .collection('users')
        .where("user_uid", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var userData in querySnapshot.docs) {
        setState(() {
          myUid = userData['user_uid'];
          // print(myPhone);
          loaging = false;
        });
      }
    });
  }

  createViewRecord(personView,foodRequestID){
    databaseReference.doc(foodRequestID).update(
        {
          "personView":personView + 1
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    var cWidth= MediaQuery.of(context).size.width;
    var cHeight= MediaQuery.of(context).size.height;
    return  Scaffold(
      // floatingActionButton: foodRequestFloatingButton(context,onPressed: (){
      //   Get.off(const AddDonersDetails(),arguments: []);
      // },
      //     backgroundColor:  const Color(0xFF378C5C)),
      body: Padding(
        padding:  EdgeInsets.only(top: cHeight*0.1),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Center(child: donationButton(context,iconColor: Colors.white,backcolor: const Color(0XFF378C5C),icon: 'assets/images/Donate.png',height: 60.0)),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.06,left: cWidth*0.11,bottom: cHeight*0.0),
              child: Text('Food Requests',style:TextConstants.foodRequestTittle),
            ),

            SizedBox(
              height: cHeight*0.68,
              width: cWidth,
              child: StreamBuilder<QuerySnapshot>(
                // stream: FirebaseFirestore.instance.collection('foodRequest').where('seekerUid',isNotEqualTo:myUid).snapshots(),
                stream: FirebaseFirestore.instance.collection('foodRequest').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          var  date = (doc['Date']);
                          var  description = (doc['description']);
                          var  personView = (doc['personView']);
                          var  photoURL = (doc['photoURL']);
                          var  seekerAddress = (doc['seekerAddress']);
                          var  seekerEmail = (doc['seekerEmail']);
                          var  seekerName = (doc['seekerName']);
                          var  seekerPhone = (doc['seekerPhone']);
                          var  seekerUid = (doc['seekerUid']);
                          var  tittle = (doc['tittle']);
                          var  foodRequestID = (doc.id);
                          DateTime dt = (doc['Time'] as Timestamp).toDate();
                          var dif = DateTime.now().difference(dt);
                          var deleteTime = dt.add(const Duration(days: 7));
                          if (kDebugMode) {
                            print('dif$dif');
                            print('dif$deleteTime');
                          }

                          return DateTime.now().isAfter(deleteTime)? Container() : Padding(
                            padding:  EdgeInsets.only(left: cWidth*0.08,right: cWidth*0.08,bottom: cHeight*0.03 ),
                            child: foodRequestCard(context,seekerName:seekerName,requestDate:date,viewPersons: personView,onPress: () async {
                              // await createViewRecord(personView,foodRequestID);
                              Get.to( const FoodRequestSenderDetailsScreen(),arguments: [
                                date,description,photoURL,seekerAddress,seekerName,tittle,seekerUid,foodRequestID
                              ]);
                            }),
                          );
                        });
                  } else {
                    return const Center(child: Text("No data"));
                  }
                },
              ),
            )









          ],
        ),
      ),
    );
  }
}
