import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contacts_service/contacts_service.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  var myPhone='000';
  var myEmail='';
  var myUsername='';
  getCurrentUser() async {
  await  FirebaseFirestore.instance
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
              stream: FirebaseFirestore.instance.collection('users').doc(myPhone).collection('friends').snapshots(),
              builder: (context, snapshot) {
                var snapm = snapshot.data?.docs.isNotEmpty;
                var snapt = snapshot.data?.docs.isEmpty;
                if (snapt == true ) {

                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: EmptyWidget(

                      image: null,
                      packageImage: PackageImage.Image_3,
                      title: 'No Friends',
                      subTitle: 'You Have No Friends \n  yet',
                      titleTextStyle: const TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  ) ;
                }
                else if(snapm == true ) {
                  // got data from snapshot but it is empty

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
                        var  friendName = (doc['friendName']);
                        var  senderUid = (doc['senderUid']);
                        var  senderProfile = (doc['sender_Profile']);
                        var  friendEmail = (doc['friendEmail']);
                        var  totalFriends  = (snapshot.data?.docs.length);
                        return friendProfileCard(context,FriendName:friendName, );
                      }) ;
                }
                else {

                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.greenAccent,
                      size: 50,
                    ),
                  ) ;
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
