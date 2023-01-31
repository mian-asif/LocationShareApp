import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_family/FoodDonateScreen/food_donate_screen.dart';
import 'package:locate_family/FoodRequestScreen/View/food_request_screen.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';
import '../../FoodDonersDetailsScreen/View/food_doners_Details_Screen.dart';

class FoodDonationHomeScreen extends StatefulWidget {
  const FoodDonationHomeScreen({Key? key}) : super(key: key);

  @override
  State<FoodDonationHomeScreen> createState() => _FoodDonationHomeScreenState();
}

class _FoodDonationHomeScreenState extends State<FoodDonationHomeScreen> {
  bool donateButtonPress=false;
  bool requestButtonPress=false;
  @override
  Widget build(BuildContext context) {
    var cWidth= MediaQuery.of(context).size.width;
    var cHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.only(top: cHeight*0.1),
        child:  Column(
          children: [
            Center(child: Image.asset('assets/images/applogo.png',height: cHeight*0.15)),
             Padding(
               padding:  EdgeInsets.only(top: cHeight*0.07),
               child: Text('Food Donation',style:TextConstants.pageTittle),
             ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.010),

              child: Text('You Wanna Donate or Request Food?',style: TextConstants.brownText,),
            ),
            Padding(
              padding:  EdgeInsets.only(left: cWidth*0.18,right:cWidth*0.18,top:cHeight*0.08 ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment:CrossAxisAlignment.center ,
                      children: [
                        donationButton(context,icon:'assets/images/DonateFoodIcon.png'
                            ,backcolor: donateButtonPress? const Color(0xFF378C5C):Colors.white,
                            iconColor: donateButtonPress?Colors.white : const Color(0XFFACB1BB),height: 70.0,
                            onTap: (){
                          setState((){
                            donateButtonPress = true;
                            requestButtonPress = false;
                          });
                        } ),
                        Padding(
                          padding:  EdgeInsets.only(top: cHeight*0.015),
                          child: Text('Donate',style: TextConstants.brownTextFoodDonation,),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        donationButton(context,icon:'assets/images/FoodRequestIcon.png'
                            ,backcolor: requestButtonPress?const Color(0xFF378C5C): Colors.white,
                            iconColor: requestButtonPress?Colors.white: const Color(0XFFACB1BB),height: 45.0,
                            onTap: (){
                              setState((){
                                donateButtonPress = false;
                                requestButtonPress= true;
                                // requestButtonPress =!requestButtonPress;
                              });
                            } ),
                        Padding(
                          padding:  EdgeInsets.only(top: cHeight*0.015),
                          child: Text('Request',style: TextConstants.brownTextFoodDonation,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.08),
              child: Center(child: customButton(onPressed: (){
                // Get.to(const FoodRequestScreen(), arguments: [donateButtonPress,requestButtonPress]);
                if(donateButtonPress == true){
                  Get.to(const FoodDonateScreen(), arguments: [donateButtonPress,requestButtonPress]);
                }
                else if(requestButtonPress == true){
                  Get.to(const FoodRequestScreen(), arguments: [donateButtonPress,requestButtonPress]);
                }else{
                  //todo: Talha- I commented it
                  // return
                  //   showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     // return foodAlertDialog(context);
                  //     return foodAlertDialogRequestComplete(context,content: 'Your food request has been submitted',image: 'assets/images/FoodRequestIcon.png',width: 40,height: 40);
                  //   },
                  // );
                }
                // Get.to( donateButtonPress == true? const FoodDonateScreen():const FoodRequestScreen(), arguments: [donateButtonPress,requestButtonPress]);
              },buttonTittle: 'Continue')),
            ),
          ],
        ),
      ),
    );
  }
}
