import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';import '../../CustomWidgets/constants.dart';
import 'package:intl/intl.dart';
import '../../CustomWidgets/custom_widgets.dart';
class AddYourFoodLocationScreen extends StatefulWidget {
  const AddYourFoodLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddYourFoodLocationScreen> createState() => _AddYourFoodLocationScreenState();
}

class _AddYourFoodLocationScreenState extends State<AddYourFoodLocationScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom:cHeight*0.26),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: const Color(0XFFFFFFFF),
            onPressed: (){},
          child: const Icon(Icons.my_location,color: Color(0XFF0091C4),size: 35),
        ),
      ),
      key: scaffoldKey,

      body: Padding(
        padding:  EdgeInsets.only(
          top: cHeight*0.06,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding:  EdgeInsets.only(
                  left: cWidth*0.08,
                ),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xFF454F63),)),
              ),
              Padding(padding:  EdgeInsets.only(left: cWidth*0.08,),
                child: Text('Add Your Location',style: TextConstants.foodRequestTittle,),
              ),
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.02),
                child: foodRequestSearchBar(context,onTap: (){scaffoldKey.currentState!.openDrawer();}),
              ),
              Padding(
                padding:  EdgeInsets.only(top: cHeight*0.00),
                child: Container(
                  height: cHeight*0.58,
                  width: cWidth,
                    decoration: BoxDecoration(border: Border.all(color: const Color(0xFF707070),width: 2)),
                  child: Image.asset('assets/images/mapImage.png',fit: BoxFit.cover),
                )
              ),


              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.03 ),
                child: Center(child: customButton(onPressed: (){},buttonTittle: 'Submit')),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
