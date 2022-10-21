import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class RequestsScreen extends StatefulWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var myPhone;
  var myEmail;
  var myUsername;

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
        });
      });
    });
  }
addFriend() {

     FirebaseFirestore.instance.collection('friends')
        .add({
      'name': auth.currentUser?.displayName,
      'email': auth.currentUser?.email,
      'uid': auth.currentUser?.uid,
      'photoURL': auth.currentUser?.photoURL,
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
      'msg': ' just accepted your friend request. Now you can share location with them. ',
      'receiverNumber': receiverNumber.replaceAll(RegExp(' '), ''),
    })
        .then((value) => debugPrint("User Added"))
        .catchError((error) => debugPrint("Failed to add user: $error"));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    var cWidth  =MediaQuery.of(context).size.width;
    var cHeight  =MediaQuery.of(context).size.height;
    return  SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(
             height: cHeight*0.5,
            width: cWidth,
            child:  StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('requests').
              where('userid',isNotEqualTo: auth.currentUser?.uid ).
              where('receiver_numberWithoutSpace',isEqualTo: myPhone ).where('request_status',isEqualTo: false).snapshots(),
              builder: (context, snapshot) {
                var snapm = snapshot.data?.docs.isNotEmpty;
                var snapt = snapshot.data?.docs.isEmpty;
                if (snapt == true ) {

                  return  EmptyWidget(

                    image: null,
                    packageImage: PackageImage.Image_2,
                    title: 'No Requests',
                    subTitle: 'You Have No Requests \n  yet',
                    titleTextStyle: const TextStyle(
                      fontSize: 22,
                      color: Color(0xff9da9c7),
                      fontWeight: FontWeight.w500,
                    ),
                    subtitleTextStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xffabb8d6),
                    ),
                  ) ;
                }
                else if(snapm == true ) {
                  // got data from snapshot but it is empty

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot doc = snapshot.data!.docs[index];
                        var  receiverNumber = (doc['receiver_number']);
                        var  senderEmail = (doc['sender_Email']);
                        var  senderName = (doc['sender_Name']);
                        var  senderPhone = (doc['sender_Phone']);
                        var  senderProfile = (doc['sender_Profile']);
                        var  requestStatus = (doc['request_status']);
                        var  userid = (doc['userid']);
                        var  docID = (doc.id);
                        return
                          requestStatus== false?  friendRequestCard(context,buttonName: 'Accept',name: senderName,onPressed: (){
                            var collections = FirebaseFirestore.instance.collection('requests');
                            collections
                                .doc(docID)
                                .update({'request_status' : true,'friend_status' : true,}) // <-- Updated data
                                .then((_) => print('Success'))
                                .catchError((error) => print('Failed: $error'));


                            FirebaseFirestore.instance.collection('users').doc(myPhone).collection('friends')
                                .add({
                              'myName': auth.currentUser?.displayName,
                              'myEmail': auth.currentUser?.email,
                              'myUid': auth.currentUser?.uid,
                              'combNumbers': [myPhone,senderPhone],
                              'acceptUid': auth.currentUser?.uid,
                              'myPhotoURL': auth.currentUser?.photoURL,
                              'friend_status': true,
                              'myNumber': myPhone,
                              'sender_Phone': senderPhone,
                              'friendName': senderName,
                              'senderEmail': senderEmail,
                              'sender_Profile': senderProfile,
                              'friendEmail': senderEmail,
                              'senderUid': userid,
                            })
                                .then((value) => print("User Added"))
                                .catchError((error) => print("Failed to add user: $error"));
                            addNotification(senderPhone);



                            FirebaseFirestore.instance.collection('users').doc(senderPhone).collection('friends')
                                .add({
                              'myName': auth.currentUser?.displayName,
                              'myEmail': auth.currentUser?.email,
                              'myUid': auth.currentUser?.uid,
                              'combNumbers': [myPhone,senderPhone],
                              'acceptUid': auth.currentUser?.uid,
                              'myPhotoURL': auth.currentUser?.photoURL,
                              'friend_status': true,
                              'myNumber': myPhone,
                              'sender_Phone': senderPhone,
                              'friendName': myUsername,
                              'senderEmail': senderEmail,
                              'friendEmail': auth.currentUser?.email,
                              'sender_Profile': senderProfile,
                              'senderUid': userid,
                            })
                                .then((value) => print("User Added"))
                                .catchError((error) => print("Failed to add user: $error"));
                            addNotification(senderPhone);

                          }):Container();
                      }) ;
                }
                else {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.greenAccent,
                      size: 50,
                    ),
                  );
                }
              },
            ),
          )


        ],
      ),
    );
  }
}
