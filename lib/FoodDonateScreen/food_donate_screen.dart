import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_family/Food_Request_Details/View/food_request_details_screen.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../FoodRequestSenderDetails/food_request_sender_details.dart';
import '../FoodDonersDetailsScreen/View/food_doners_Details_Screen.dart';

class FoodDonateScreen extends StatefulWidget {
  const FoodDonateScreen({Key? key}) : super(key: key);

  @override
  State<FoodDonateScreen> createState() => _FoodDonateScreenState();
}

class _FoodDonateScreenState extends State<FoodDonateScreen> {
  // bool donateButtonPress= Get.arguments[0];
  // bool requestButtonPress=Get.arguments[1];
  final databaseReference = FirebaseFirestore.instance.collection('foodDonate');
  var userlocation;
  var userlocationlongitude;
  var userlocationlatitude;
  var address='';
  bool loaging = true;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    // print(donateButtonPress.toString());
    // print(requestButtonPress.toString());
  }

  var documentsLenth=3;
  var myEmail='';
  var myUsername='';
  var userUid='';
  var photoURL='';
  late num viewNumber= 0;
  getCurrentUser()  {

    FirebaseFirestore.instance
        .collection('foodDonate')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          documentsLenth = querySnapshot.docs.length;
          // myEmail = userData['email'];
        });
      });
    });
    setState((){
      loaging = false;
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
    return loaging? const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.blue,)),
    ): Scaffold(
      floatingActionButton: foodRequestFloatingButton(context,onPressed: (){
        Get.off(const AddDonersDetails(),arguments: [userlocation,userlocationlongitude,userlocationlatitude,address]);
      }, backgroundColor: documentsLenth == null ||  documentsLenth < 4 ? const Color(0xFF378C5C) : Colors.white,iconColor:  documentsLenth<4? Colors.white : const Color(0xFF378C5C)),
      body: Padding(
        padding:  EdgeInsets.only(top: cHeight*0.1),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Center(child: donationButton(context,iconColor: Colors.white,backcolor: Color(0XFF378C5C),icon: 'assets/images/Donate.png',height: 60.0)),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.06,left: cWidth*0.11,bottom: cHeight*0.0),
              child: Text('Food Requests',style:TextConstants.foodRequestTittle),
            ),

            SizedBox(
              height: cHeight*0.68,
              width: cWidth,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('foodDonate').snapshots(),
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
                          var  SenderEmail = (doc['SenderEmail']);
                          var  SenderName = (doc['SenderName']);
                          var  SenderPhone = (doc['SenderPhone']);
                          var  senderUid = (doc['SenderUid']);
                          var  foodValue = (doc['foodValue']);
                          var  tittle = (doc['tittle']);
                          var  foodRequestID = (doc.id);
                          return  Padding(
                            padding:  EdgeInsets.only(left: cWidth*0.08,right: cWidth*0.08,bottom: cHeight*0.03 ),
                            child: foodRequestCard(context,seekerName:SenderName,requestDate:date,viewPersons: personView.toString(),onPress: () async {
                              await createViewRecord(personView,foodRequestID);
                              Get.to( const FoodRequestSenderDetailsScreen(),arguments: [
                                date,description,photoURL,SenderName,tittle
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
