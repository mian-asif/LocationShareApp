import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../CustomWidgets/custom_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../FoodDonateScreen/food_donate_screen.dart';
import '../FoodDonersDetailsScreen/View/food_doners_Details_Screen.dart';
class FoodRequestSenderDetailsScreen extends StatefulWidget {
  const FoodRequestSenderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FoodRequestSenderDetailsScreen> createState() => _FoodRequestSenderDetailsScreenState();
}

class _FoodRequestSenderDetailsScreenState extends State<FoodRequestSenderDetailsScreen> {
  var date = Get.arguments[0];
  var description = Get.arguments[1];
  var photoURL = Get.arguments[2];
  var seekerAddress = Get.arguments[3];
  var seekerName = Get.arguments[4];
  var tittle = Get.arguments[5];
  var seekerUid = Get.arguments[6];
  var foodRequestID = Get.arguments[7];
  var myUid = '';
  bool loaging =true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }
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

  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return loaging? Scaffold(body: Shimmer.fromColors(
      baseColor: Color(0XFFe0e0e0),
      highlightColor: Colors.white38 ,
      child: Padding(
        padding:  EdgeInsets.only(left: cWidth*0.09,right: cWidth*0.09,top: cHeight*0.02),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ],
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(top: 0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CircleAvatar(
                    maxRadius: 40,
                    child: ClipOval(

                      child: CachedNetworkImage(
                        width: 80,height: 80,
                        imageUrl: '',fit: BoxFit.cover,
                        placeholder: (context, url) => Image.asset(''),
                      ),
                    ),
                  ),
                ),
              ),),

            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.02),
              child: simiarWidget(context),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
              child: foodRequestViewDetailsCard(context,text: '' ,sizeHeight: cHeight*0.05),
            ),

            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
              child: simiarWidget(context),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0XFFF1F1F1),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0XFF707070),
                        blurRadius: 6.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          1.0,
                          3.0,
                        )
                    ),
                  ],
                ),
                child: Padding(
                  padding:  const EdgeInsets.only(top: 0,left: 10),
                  child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Text('',style: GoogleFonts.montserrat(fontWeight: FontWeight.w400))),
                ),
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
              child: simiarWidget(context),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
              child: foodRequestViewDetailsCard(context,text: '',sizeHeight: cHeight*0.05),
            ),

            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
              child: simiarWidget(context),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
              child: foodRequestViewDetailsCard(context,text: tittle,sizeHeight: cHeight*0.05),
            ),

            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
              child: simiarWidget(context),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
              child: foodRequestViewDetailsCard(context,text: '',sizeHeight: cHeight*0.2),
            ),





          ],
        ),
      ),
    ),) :
    Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding:  EdgeInsets.only(left: cWidth*0.09,right: cWidth*0.09,top: cHeight*0.02 ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      Get.back();
                    }, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                    seekerUid == myUid?Container(): TextButton(onPressed: (){
                      Get.to(()=>const AddDonersDetails(),arguments: [seekerName,seekerUid,seekerAddress,foodRequestID]);
                    }, child: const Text('Donate')),
                  ],
                ),
              ),

               Padding(
                padding:  EdgeInsets.only(top: 0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CircleAvatar(
                      maxRadius: 40,
                      child: ClipOval(

                        child: CachedNetworkImage(
                          width: 80,height: 80,
                          imageUrl: photoURL,fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset('assets/images/login.gif'),
                          // errorWidget: (context, url, error) => Container(
                          //
                          //   height: 64,
                          //   width: 64,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white54,
                          //     borderRadius: BorderRadius.circular(10),
                          //   ),
                          //   child:  ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child:Image.asset('assets/images/applogo.png'),
                          //   ),
                          // ),
                        ),
                    ),
                  ),
                  ),
                ),),

              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.02),
                child: foodRequestViewDetailsText(context,text: 'Name'),
              ),
              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
                child: foodRequestViewDetailsCard(context,text: seekerName ,sizeHeight: cHeight*0.05),
              ),

              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
                child: foodRequestViewDetailsText(context,text: 'Location'),
              ),
              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
                // child: foodRequestViewDetailsCard(context,text: seekerAddress,sizeHeight: cHeight*0.05),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0XFFF1F1F1),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0XFF707070),
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                          offset: Offset(
                            1.0,
                            3.0,
                          )
                      ),
                    ],
                  ),
                  child: Padding(
                    padding:  const EdgeInsets.only(top: 0,left: 10),
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(seekerAddress,style: GoogleFonts.montserrat(fontWeight: FontWeight.w400))),
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
                child: foodRequestViewDetailsText(context,text: 'Date'),
              ),
              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
                child: foodRequestViewDetailsCard(context,text: date,sizeHeight: cHeight*0.05),
              ),

              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
                child: foodRequestViewDetailsText(context,text: 'Title'),
              ),
              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
                child: foodRequestViewDetailsCard(context,text: tittle,sizeHeight: cHeight*0.05),
              ),

              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.027,top: cHeight*0.03),
                child: foodRequestViewDetailsText(context,text: 'Description'),
              ),
              Padding(
                padding:  EdgeInsets.only(left: cWidth*0.0,top: cHeight*0.01),
                child: foodRequestViewDetailsCard(context,text: description,sizeHeight: cHeight*0.2),
              ),





               ],
          ),
        ),
      ),
    );
  }
}
