
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class ShareLocationWithFriends extends StatefulWidget {
  const ShareLocationWithFriends({Key? key}) : super(key: key);

  @override
  State<ShareLocationWithFriends> createState() => _ShareLocationWithFriendsState();
}

class _ShareLocationWithFriendsState extends State<ShareLocationWithFriends> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUsers();
  }
  var locationTag = Get.arguments[0];
  var userlocationlongitude = Get.arguments[1];
  var userlocationlatitude = Get.arguments[2];
  var myPhone='';
  var myEmail='';
  var myUsername='';
  var pushToken;
  var msg = '';
  var title = '';
  var singleNumber = '';

  getCurrentUser() {
    User? user = firebaseAuth.currentUser;
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
        });
      });
    });
  }
  CollectionReference location = FirebaseFirestore.instance.collection('locations');
  Future<void> addLocation(receiverEmail,receiverName,receiverUid,receiverProfile,senderPhone) {
    // Call the user's CollectionReference to add a new user
    return location
        .add({
      'userlocationlatitude': userlocationlatitude,
      'userlocationlongitude': userlocationlongitude,
      'senderName': myUsername,
      'senderEmail': myEmail,
      'senderPhone': myPhone,
      'senderUid': auth.currentUser?.uid,
      'senderPhoto': auth.currentUser?.photoURL,
      'receiverProfile': receiverProfile,
      'receiverUid': receiverUid,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'receiverPhone': senderPhone,
      'locationTag': locationTag.toString(),
      // 'locationTag': locationTag,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
      'msg': ' just shared a new location with you with the name of $locationTag ',
      'receiverNumber': receiverNumber.replaceAll(RegExp(' '), ''),
    },

    )

        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));


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
              'body': '${auth.currentUser?.displayName}Send You New Location',
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    var cWidth= MediaQuery.of(context).size.width;
    var cHeight= MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        },icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,)),
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        actions: [

          Padding(
            padding:  EdgeInsets.only(
              left: cWidth*0.09,
            ),
            child: SizedBox(
              width: cWidth*0.85,
              child: const Center(
                child: TextField(

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search',),
                ),
              ),
            ),
          ),

        ],

      ),
      body:Column(
        children: [
          SizedBox(
            height: cHeight*0.5,
            width: cWidth,
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('friends').where('myUid',isEqualTo: auth.currentUser?.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        var  receiverEmail = (doc['senderEmail']);
                        var  receiverName = (doc['senderName']);
                        var  receiverUid = (doc['senderUid']);
                        var  receiverProfile = (doc['sender_Profile']);
                        var  senderPhone = (doc['sender_Phone']);
                        return friendRequestCard(context,onPressed: (){
                          addLocation(receiverEmail,receiverName,receiverUid,receiverProfile,senderPhone);
                          addNotification(senderPhone);
                          print('location');
                          sendPushMessageFirebaseFunction(pushToken, msg, title);
                        },name: receiverName,buttonName: 'Send' );
                      });
                } else {
                  return Text("No data");
                }
              },
            ),
          )


        ],
      ),
    );
  }
}
