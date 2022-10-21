import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Model/userModel.dart';

import 'package:flutter/foundation.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  late bool loading;
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getRequestData();
    getFriendData();
    getCurrentUser();
    getUsers();
    getContact();
    getFirebaseNumbers();
    if (kDebugMode) {
      print(myPhone);
    }
  }

  List? mobileContacts = [];
  late List users = [];
  late List firebasePhoneNumber = [];
  late List docData = [];
  var reqSenderNumber = '';
  var singleNumber;
  var pushToken;
  var msg = '';
  var title = '';
  String myId = '';
  var myUsername;
  var myEmail;
  var myPhone = '';
  var myUrlAvatar = '';
  List allPhonesData = [];


  var friendStatus;
  var friendStatusp;
  var requestStatus;
  var receiverNumber;
  var senderPhone;
  var senderNumber;

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      mobileContacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      // print(mobileContacts);
      for(int i=0; i<mobileContacts!.length; i++){
        setState(() {
          allPhonesData.add(mobileContacts![i].phones.first.normalizedNumber);
          allPhonesData.add(mobileContacts![i].phones.first.number.replaceAll(RegExp(' +'), ''));
          loading=false;
        });
      }

    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  getUsers() {
    FirebaseFirestore.instance
        .collection('users')
        .where("phone", isEqualTo: singleNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        pushToken = doc['pushToken'];
        if (kDebugMode) {
          print('hello:$pushToken');
        }
      });
    });
  }

  getRequestData() {
    FirebaseFirestore.instance
        .collection('requests')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          friendStatus = userData['friend_status'];
          requestStatus = userData['request_status'];
          receiverNumber = userData['receiver_number'];
          senderPhone = userData['sender_Phone'];
        });
      });
    });
  }
  getFriendData() {
    FirebaseFirestore.instance
    .collection('friends').where('combNumbers',arrayContainsAny: [myPhone])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          friendStatusp = userData['friend_status'];
        });
      });
    });
  }

  // Send Notification

  getCurrentUser() {
    FirebaseFirestore.instance
        .collection('users')
        .where("user_uid", isEqualTo: auth.currentUser?.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var userData in querySnapshot.docs) {
        setState(() {
          myUsername = userData['full_name'];
          myEmail = userData['email'];
          myPhone = userData['phone'];
          // print(myPhone);
        });
      }
    });
  }

  getFirebaseNumbers() {
    FirebaseFirestore.instance
        .collection('phoneData').where('phone',isNotEqualTo: myPhone)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        final docData = querySnapshot.docs.map((doc) => doc['phone']).toList();
        setState(() {
          firebasePhoneNumber = docData;
          // print(firebasePhoneNumber.toString());
        });
      }
    });
  }



  Future<void> sendPushMessageFirebaseFunction(pushToken, msg, title) async {
    if (pushToken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
// This is the Server key from the firebase messaging settings
              'key=AAAAL4X7W9o:APA91bFc6eWmVO3FIlo_9z8VUH_XZ4LrGQ_l-GtJ_oXOow-brlA6Mg6LRkBVPYOXixZekdTIHsisnzFvuOaZpgbLr1KgDMM5EBl0t9ogRV5vLuUvNuz4NKthbv03h214yfV9l1cnVdjF',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '${auth.currentUser?.displayName}Send You Friend Request',
              'title': 'New Request'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to': pushToken,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  userData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          // for( int i = 0; i<phoneNumber.length; i++ ){
          //   phoneNumber2.add(doc["phone"]) ;
          // }
          // phoneNumber.add(doc["phone"]) ;
        });
      }
    });
  }

  Future<void> addNotification(receiverNumber) async {
    //creates a new doc with unique doc ID
    return FirebaseFirestore.instance.collection('notifications')
        .add({
      'senderName': auth.currentUser?.displayName,
      'senderUid': auth.currentUser?.uid,
      'senderImage': auth.currentUser?.photoURL,
      'senderPhone': myPhone,
      'status': false,
      'msg': ' sent you a friend request',
      'receiverNumber': receiverNumber.replaceAll(RegExp(' '), ''),
    })
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }
  @override
  Widget build(BuildContext context) {
    var cWidth = MediaQuery.of(context).size.width;
    var cHeight = MediaQuery.of(context).size.height;
    return loading?Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.greenAccent,
              size: 50,
            ),
          )
        ],
      ),
     ): Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: (mobileContacts) == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: mobileContacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  Uint8List? image = mobileContacts![index].photo;
                  String num = (mobileContacts![index].phones.isNotEmpty)
                      ? (mobileContacts![index].phones.first.number) : "--";
                  bool numberExist = firebasePhoneNumber.contains(num.replaceAll(RegExp(' '), ''));
                  // bool result = allPhonesData.where((item) => firebasePhoneNumber.contains(item)) as bool;
                  // bool numberExist2 = allPhonesData.every((element) => firebasePhoneNumber.;

                  // List result = allPhonesData.where((item) => firebasePhoneNumber.contains(item)).toList();

                  return numberExist && num.replaceAll(RegExp(' '), '')!=myPhone  ?
                  Column(
                    children: [

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: cHeight * 0.01,
                                bottom: cHeight * 0.01,
                                left: cWidth * 0.06),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey,
                              child: (mobileContacts![index].photo == null)
                                  ? const CircleAvatar(
                                      child: Icon(Icons.person))
                                  : CircleAvatar(
                                      backgroundImage: MemoryImage(image!),
                                      maxRadius: 40),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: cHeight * 0.0, left: cWidth * 0.08),
                            child: SizedBox(
                              // color: Colors.red,
                              height: cHeight * 0.08,
                              width: cWidth * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${mobileContacts![index].name.first} ${mobileContacts![index].name.last}",
                                    style: GoogleFonts.quicksand(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      num,
                                      style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff707070)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: cWidth * 0.04,
                              ),
                              child:
                              ElevatedButton(
                                  onPressed: () async {
                                    print(myUsername);
                                    getCurrentUser();
                                    getUsers();
                                    addNotification(num,);

                                    await FirebaseFirestore.instance
                                        .collection('requests')
                                        .add({
                                          'userid': auth.currentUser?.uid,
                                          'sender_Email':
                                              auth.currentUser?.email,
                                          'sender_Name':
                                              auth.currentUser?.displayName,
                                          'sender_Phone': myPhone,
                                          'sender_Profile':
                                              auth.currentUser?.photoURL,
                                          'request_status': false,
                                          'friend_status': false,
                                          'receiver_number': num,
                                          'dateTime': DateTime.now(),
                                      'receiver_numberWithoutSpace': num.replaceAll(RegExp(' '), ''),
                                        })
                                        .then((value) => print("User Added"))
                                        .catchError((error) => print(
                                            "Failed to add user: $error"));
                                    sendPushMessageFirebaseFunction(pushToken, msg, title);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF0091C4),
                                    onPrimary: Colors.white,
                                    shadowColor: Color(0xFF0091C4),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    minimumSize: Size(85, 35), //////// HERE
                                  ),


                                  child:

                                Text( requestStatus == false ?  'Pending': friendStatus == null || false ?'Add':'Friends',
                                      style: GoogleFonts.quicksand(
                                          color: Colors.white))

                              )
                          )
                        ],
                      ),
                      // :Container(),
                      Divider(
                        height: 10,
                      ),
                    ],
                  ):Container();
                },
              ));
  }
}
