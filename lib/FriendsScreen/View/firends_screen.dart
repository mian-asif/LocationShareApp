import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contacts_service/contacts_service.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  var myPhone='';
  var myEmail='';
  var myUsername='';
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
  // getFriendsA() {
  //   User? user = firebaseAuth.currentUser;
  //   FirebaseFirestore.instance
  //       .collection('friends')
  //       .where("myUid", isEqualTo: auth.currentUser?.uid)
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((userData) {
  //       setState(() {
  //         friendStatus = userData['friend_status'];
  //         myEmaildata = userData['myEmail'];
  //         myName = userData['myName'];
  //         myNumber = userData['myNumber'];
  //         myPhotoURL = userData['myPhotoURL'];
  //         myUid = userData['myUid'];
  //         senderEmail = userData['senderEmail'];
  //         senderName = userData['senderName'];
  //         senderUid = userData['senderUid'];
  //         senderPhone = userData['sender_Phone'];
  //         senderProfile = userData['sender_Profile'];
  //       });
  //     });
  //   });
  // }
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
            height: cHeight*0.5,
            width: cWidth,
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('friends').where('combNumbers',arrayContainsAny: [myPhone]).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        var  myEmail = (doc['myEmail']);
                        var  myName = (doc['myName']);
                        var  myNumber = (doc['myNumber']);
                        var  myPhotoURL = (doc['myPhotoURL']);
                        var  myUid = (doc['myUid']);
                        var  senderEmail = (doc['senderEmail']);
                        var  senderName = (doc['senderName']);
                        var  senderUid = (doc['senderUid']);
                        var  senderProfile = (doc['sender_Profile']);
                        var  totalFriends  = (snapshot.data?.docs.length);
                        return friendProfileCard(context,FriendName:senderName, );
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
      // ListView.builder(
      // physics: const BouncingScrollPhysics(),
      //
      //   itemCount: 15,
      //   itemBuilder: (context,index) {
      //     return friendProfileCard(context);
      //   });
  }
}
