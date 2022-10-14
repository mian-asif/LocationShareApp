import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:locate_family/FoodRequestScreen/View/food_request_screen.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';

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
        child: Column(
          children: [
            Center(child: Image.asset('assets/images/applogo.png',height: cHeight*0.15)),
             Padding(
               padding:  EdgeInsets.only(top: cHeight*0.07),
               child: Text('Food Donation',style:TextConstants.pageTittle),
             ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.015),
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
                            requestButtonPress= false;
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
                Get.to(const FoodRequestScreen());
              },buttonTittle: 'Continue')),
            )



            
          ],
        ),
      ),
    );
  }
}
