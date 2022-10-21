import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../ContactsScreen/View/contacts_screen.dart';
import '../../CustomWidgets/custom_indecatior.dart';
import '../../FriendsScreen/View/firends_screen.dart';
import '../../Requests_Screen/View/requests_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FriendListScreen extends StatefulWidget {
  const FriendListScreen({Key? key}) : super(key: key);

  @override
  State<FriendListScreen> createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var friendTotal=0;
  var myPhone;
  var myEmail='';
  var myUsername='';
  late bool loading;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getCurrentUser();

  }
  getCurrentUser() async {
    User? user = firebaseAuth.currentUser;
     await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: user?.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((userData) {
        setState(() {
          myUsername = userData['full_name'];
          myEmail = userData['email'];
          myPhone = userData['phone'];
          print(myPhone);
        });
      });
    });
    getTotalFriends();
  }
  getTotalFriends() async {
    await FirebaseFirestore.instance
        .collection('users').doc(myPhone).collection('friends')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        friendTotal = querySnapshot.docs.length;
        print('friendTotal $friendTotal');
        loading=false;

      });
    });
  }
  @override
  Widget build(BuildContext context) {

var cWidth= MediaQuery.of(context).size.width;
var cHeight= MediaQuery.of(context).size.height;
      return DefaultTabController(
        
      length: 3,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          shadowColor: Colors.white,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding:  EdgeInsets.only(
                left: cWidth*0.0,
              ),
              child: SizedBox(
                width: cWidth*0.95,
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(
                  top: cHeight*0.02
              ),
              child: SizedBox(
                height: cHeight*0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(
                          left: cWidth*0.09
                      ),
                      child: Text('Your Friends',style: GoogleFonts.montserrat(fontSize:
                      24,color: Color(0XFF0091C4),fontWeight: FontWeight.bold),
                      ),
                    ),
                   loading ? Padding(
                     padding:  EdgeInsets.only(left: cWidth*0.15),
                     child: LoadingAnimationWidget.staggeredDotsWave(
                       color: Colors.greenAccent,
                       size: 20,
                     ),
                   ) : Padding(
                      padding:  EdgeInsets.only(
                          left: cWidth*0.11
                      ),
                      child: Text('$friendTotal Friends',style: GoogleFonts.montserrat(fontSize:
                      14,color: Color(0XFF707070),fontWeight: FontWeight.w700),
                      ),
                    ),

                  ],
                ),
              ),
            ),


            // the tab bar with two items
            SizedBox(
              height: 50,
              child: AppBar(
                backgroundColor: Colors.white,
                bottom: TabBar(
                  indicator: CustomTabIndicator(),
                  tabs: [
                    Tab(
                      child: Text('Friends',style:GoogleFonts.montserrat(color: const Color(0xff2A2E43),fontWeight: FontWeight.w600)),
                    ),
                    Tab(
                      child: Text('Contacts',style:GoogleFonts.montserrat(color: const Color(0xff2A2E43),fontWeight: FontWeight.w600)),
                    ),
                    Tab(
                      child: Text('Requests',style:GoogleFonts.montserrat(color: Color(0xff2A2E43),fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),

            // create widgets for each tab bar here
            const Expanded(
              child: TabBarView(
                children: [
                  // first tab bar view widget
                  FriendsScreen(),

                  // second tab bar viiew widget
                  ContactsScreen(),
                  RequestsScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
