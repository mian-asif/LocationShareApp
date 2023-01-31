import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locate_family/Home_Screen/View/home_screen.dart';
import 'package:locate_family/LogIn-Screen/View/login_screen.dart';
import '../../CustomWidgets/custom_widgets.dart';

import 'package:motion_toast/motion_toast.dart';
class FoodDonationHistory extends StatefulWidget {
  const FoodDonationHistory({Key? key}) : super(key: key);

  @override
  State<FoodDonationHistory> createState() => _FoodDonationHistoryState();
}

class _FoodDonationHistoryState extends State<FoodDonationHistory> {
  TextEditingController passwordController =TextEditingController();
  TextEditingController newPasswordController =TextEditingController();
  final donations = FirebaseFirestore.instance;
  bool _validate = false;
  late bool loading=false;
  late bool passwordVisible;
  late bool newPasswordVisible;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0XFF378C5C),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.08,left: cWidth*0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,)),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.03,left: cWidth*0.1),
              child: Text('Donation History',style: GoogleFonts.montserrat(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('foodDonate').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          return donationCard(context,address:doc['seekerAddress'],discription: doc['description'],imgurl:doc['photoURL'],name: doc['SenderName'],text: doc['Date']);
                        }),
                  );
                } else {
                  return Text("No data");
                }
              },
            )




          ],
        ),
      ),
    );
  }
}
