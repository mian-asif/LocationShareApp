import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_family/Food_Request_Details/View/food_request_details_screen.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';

class FoodRequestScreen extends StatefulWidget {
  const FoodRequestScreen({Key? key}) : super(key: key);

  @override
  State<FoodRequestScreen> createState() => _FoodRequestScreenState();
}

class _FoodRequestScreenState extends State<FoodRequestScreen> {
  bool donateButtonPress=false;
  bool requestButtonPress=false;
  @override
  Widget build(BuildContext context) {
    var cWidth= MediaQuery.of(context).size.width;
    var cHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: foodRequestFloatingButton(context,onPressed: (){
        Get.to(const FoodRequestDetailsScreen());
      }),
      body: Padding(
        padding:  EdgeInsets.only(top: cHeight*0.1),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Center(child: donationButton(context,iconColor: Colors.white,backcolor: Color(0XFF378C5C),icon: 'assets/images/FoodRequestIcon.png',height: 45.0)),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.07,left: cWidth*0.11),
              child: Text('Food Requests',style:TextConstants.foodRequestTittle),
            ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.04,left: cWidth*0.1,right: cWidth*0.1 ),
              child:foodRequestCard(context),
            ),







          ],
        ),
      ),
    );
  }
}
