import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:locate_family/Add_Your_LocationFood/View/add_your_food_location.dart';
import 'package:locate_family/FoodRequestScreen/View/food_request_screen.dart';
import 'package:locate_family/Home_Screen/View/home_screen.dart';
import '../../CustomWidgets/constants.dart';
import 'package:intl/intl.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FoodRequestDetailsScreen extends StatefulWidget {
  const FoodRequestDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FoodRequestDetailsScreen> createState() =>
      _FoodRequestDetailsScreenState();
}

class _FoodRequestDetailsScreenState extends State<FoodRequestDetailsScreen> {
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController tittleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final databaseReference =
      FirebaseFirestore.instance.collection('foodRequest');
  var userlocation = Get.arguments[0];
  var userlocationlongitude = Get.arguments[1];
  var userlocationlatitude = Get.arguments[2];
  var address = Get.arguments[3];

  @override
  void initState() {
    super.initState();
    // _getAddressFromLatLng(userlocation);
    getCurrentUser();
    locationController.text = address;
  }

  var myPhone = '';
  var myEmail = '';
  var myUsername = '';
  var userUid = '';
  var photoURL = '';
  late num viewNumber = 0;

  List<Asset> images = <Asset>[];
  List<String> imagesUrls = [];
  File? imageFile;

  List localFilePath = [];

  Future<List<Asset>> loadAssets2() async {
    List<Asset> resultList = <Asset>[];
    List<Asset> images = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: const CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: const MaterialOptions(
          statusBarColor: '#9E8664',
          actionBarColor: '#9E8664',
          actionBarTitle: ' "Pick Images"',
          allViewTitle: 'All Photos',
          useDetailsView: true,
          selectCircleStrokeColor: "#FFFFFF",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    images = resultList;
    return images;
  }

  Future imageGetFromDevice(images) async {
    localFilePath.clear();
    for (var i = 0; i < images.length; i++) {
      setState(() async {
        imageFile = await convertAssetToFile(images[i]);
        localFilePath.add(imageFile);
      });
    }
  }

  Future<File> convertAssetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File(("${(await getTemporaryDirectory()).path}/${asset.name}"));
    final file = await tempFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future uploadPic(File imageFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.ref().child("chatImages").child(basename(imageFile.path));
    await ref.putFile(imageFile);
    String imageUrl = await ref.getDownloadURL();
    setState(() {
      imagesUrls.add(imageUrl);
    });
  }

  getCurrentUser() async {
    await FirebaseFirestore.instance
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

  createRecord() async {
    await databaseReference.add({
      'seekerAddress': address.toString(),
      'Date': dateController.text,
      'tittle': tittleController.text,
      'description': descriptionController.text,
      'seekerName': myUsername,
      'seekerUid': userUid,
      'photoURL': photoURL,
      "selectedPhoto" : imagesUrls,
      // uploaded image url : imagesUrls
      'seekerPhone': myPhone,
      'seekerEmail': myEmail,
      'personView': viewNumber,
      'Time': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    var cHeight = MediaQuery.of(context).size.height;
    var cWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          left: cWidth * 0.08,
          right: cWidth * 0.08,
          top: cHeight * 0.06,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                    color: Color(0xFF454F63),
                  )),
              Text(
                'Food Request Details',
                style: TextConstants.foodRequestTittle,
              ),
              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.04),
                child: foodRequestTextField(
                  hintText: 'Location',
                  controller: locationController,
                  suffixIcon: InkWell(
                      onTap: () {
                        Get.off(const AddYourFoodLocationScreen());
                      },
                      child: const Icon(
                        Icons.my_location_outlined,
                        color: Color(0xFFED1D24),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.04),
                child: foodRequestTextField(
                    controller: dateController,
                    hintText: 'Date',
                    suffixIcon: InkWell(
                        onTap: () async {
                          var datePicked =
                              await DatePicker.showSimpleDatePicker(context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2050),
                                  dateFormat: "dd-MMMM-yyyy",
                                  // locale: DateTimePickerLocale.th,
                                  looping: false,
                                  textColor: Colors.black);
                          DateFormat.yMEd().add_jms().format(datePicked!);
                          // DateFormat.yMMMMEEEEd().format(datePicked!);
                          final snackBar = datePicked != null
                              ? SnackBar(
                                  content: Text("Date Picked $datePicked"))
                              : const SnackBar(content: Text("No Date Picked"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          setState(() {
                            dateController.text = DateFormat.yMMMMEEEEd()
                                .format(datePicked)
                                .toString();
                          });
                        },
                        child: const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFED1D24),
                        ))),
              ),
              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.04),
                child: foodRequestTextField(
                    hintText: 'Title', controller: tittleController),
              ),
              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.04),
                child: foodRequestTextField(
                    hintText: 'Description',
                    controller: descriptionController,
                    maxLength: 3),
              ),
              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.04),
                child: Text(
                  'Photos',
                  style: TextConstants.foodRequestPhotosText,
                ),
              ),
              SizedBox(
                height: 130,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: cHeight * 0.02),
                      child: foodRequestAddPhotoButton(context, onTap: () async {
                        setState((){
                          imagesUrls.clear();
                        });
                        List<Asset> images = <Asset>[];
                        images = await loadAssets2();
                        await imageGetFromDevice(images);
                      }),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 0.0,
                            ),
                            itemCount: localFilePath.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 100,
                                width: 100,
                                child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.file(
                                        File(localFilePath[index].path))),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: cHeight * 0.06),
                child: Center(
                    child: customButton(
                        onPressed: () async {
                          //todo: Talha
                          if (userlocation.toString().isNotEmpty &&
                              dateController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              tittleController.text.isNotEmpty) {
                            await uploadPic(imageFile!);
                            await createRecord();
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return foodAlertDialog(context);
                                return foodAlertDialogRequestComplete(context,
                                    content:
                                        'Your food request has been submitted',
                                    image: 'assets/images/FoodRequestIcon.png',
                                    width: 40.0,
                                    height: 40.0, onPressed: () {
                                  Get.back();
                                  Get.back();
                                });
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please enter the Data")));
                          }
                        },
                        buttonTittle: 'Submit')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
