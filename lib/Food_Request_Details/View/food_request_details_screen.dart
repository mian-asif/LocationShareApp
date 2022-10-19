import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:locate_family/Add_Your_LocationFood/View/add_your_food_location.dart';
import 'package:locate_family/FoodRequestScreen/View/food_request_screen.dart';import '../../CustomWidgets/constants.dart';
import 'package:intl/intl.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FoodRequestDetailsScreen extends StatefulWidget {
  const FoodRequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FoodRequestDetailsScreen> createState() => _FoodRequestDetailsScreenState();
}

class _FoodRequestDetailsScreenState extends State<FoodRequestDetailsScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tittleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference = FirebaseFirestore.instance.collection('foodRequest');
  var userlocation=Get.arguments[0];
  var userlocationlongitude=Get.arguments[1];
  var userlocationlatitude=Get.arguments[2];
  var address=Get.arguments[3];


  @override
  void initState() {
    super.initState();
    // _getAddressFromLatLng(userlocation);
    getCurrentUser();
    locationController.text=address;
  }

  var myPhone='';
  var myEmail='';
  var myUsername='';
  var userUid='';
  var photoURL='';
  late num viewNumber= 0;
  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('users')
        .where("user_uid", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          myUsername = userData['full_name'];
          myEmail = userData['email'];
          myPhone = userData['phone'];
          userUid = userData['user_uid'];
          photoURL = userData['photoURL'];
        });
      });
    });
  }
  void createRecord(){
    databaseReference.add({
      'seekerAddress': address.toString(),
      'Date': dateController.text,
      'tittle': tittleController.text,
      'description': descriptionController.text,
      'seekerName': myUsername ,
      'seekerUid': userUid,
      'photoURL': photoURL,
      'seekerPhone': myPhone,
      'seekerEmail': myEmail,
      'personView': viewNumber,
    });
  }
  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding:  EdgeInsets.only(
          left: cWidth*0.08,
          right: cWidth*0.08,
          top: cHeight*0.06,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back_ios,size: 30,color: Color(0xFF454F63),)),
               Text('Food Request Details',style: TextConstants.foodRequestTittle,),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.04 ),
                child: foodRequestTextField(hintText: 'Location',controller:locationController , suffixIcon: InkWell(
                  onTap: (){
                    Get.off(const AddYourFoodLocationScreen());
                  },
                    child: const Icon(Icons.my_location_outlined,color: Color(0xFFED1D24),)),),
              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.04 ),
                child: foodRequestTextField(
                    controller: dateController,
                    hintText: 'Date',suffixIcon:InkWell(
                  onTap: () async {
                    var datePicked = await DatePicker.showSimpleDatePicker(
                      context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2050),
                      dateFormat: "dd-MMMM-yyyy",
                      // locale: DateTimePickerLocale.th,
                      looping: true,
                      textColor: Colors.black

                    );
                    DateFormat.yMEd().add_jms().format(datePicked!);
                    // DateFormat.yMMMMEEEEd().format(datePicked!);
                    final snackBar = datePicked != null? SnackBar(content: Text("Date Picked $datePicked")):
                    const SnackBar(content: Text("No Date Picked"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    setState((){
                      dateController.text=DateFormat.yMMMMEEEEd().format(datePicked).toString();
                    });
                  },
                    child: const Icon(Icons.calendar_today,color: Color(0xFFED1D24),)) ),

              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.04 ),
                child: foodRequestTextField(hintText: 'Title',controller: tittleController ),
              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.04 ),
                child: foodRequestTextField(hintText: 'Description', controller: descriptionController),
              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.04 ),
                child:  Text('Photos',style: TextConstants.foodRequestPhotosText,),
              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.02 ),
                child: foodRequestAddPhotoButton(context,onTap: (){}),
              ),
              Padding(
                padding:  EdgeInsets.only(top:cHeight*0.06 ),
                child: Center(child: customButton(onPressed: (){
                   createRecord();
                 print(userlocation.toString());
                 print(userlocationlatitude.toString());
                 print(userlocationlongitude.toString());
                 print(address.toString());
                 Get.off(const FoodRequestScreen());
                },buttonTittle: 'Submit')),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
