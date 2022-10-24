import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locate_family/Add_Your_LocationFood/View/add_your_food_location.dart';
import 'package:locate_family/CustomWidgets/constants.dart';
import 'package:locate_family/Home_Screen/View/home_screen.dart';
import 'package:locate_family/Location_Screen/View/locations_screen.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import '../../Food_Donation_Home/View/food_donaton_homeScreen.dart';
import '../../FriendListScreen/View/friend_list_screen.dart';
import '../../Notifications/notifications_screen.dart';



class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen( {Key? key,}) : super(key: key,);
  static String id = 'bottom';

  @override
  State<BottomNavBarScreen> createState() => _BottomNavBar();
}

class _BottomNavBar extends State<BottomNavBarScreen> with SingleTickerProviderStateMixin{
  int tabIndex = 2;
  late TabController tabController = TabController(length: 5, vsync: this, initialIndex: tabIndex);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CircleNavBar(
        iconDurationMillSec: 400,

        activeIcons: const [
          Icon(Icons.location_on, color: Colors.white,size: 37),
          Icon(Icons.person, color: Colors.white,size: 37),
          Icon(Icons.house_rounded, color: Colors.white,size: 37),
          Icon(Icons.fastfood_rounded, color: Colors.white,size: 37),
          Icon(Icons.notifications, color: Colors.white,size: 37),
        ],
        inactiveIcons: const [
       Icon(Icons.location_on,color:Color(0xFF90B9C8),size: 30),
       Icon(Icons.person,color:Color(0xFF90B9C8) ,size: 30),
       Icon(Icons.house_rounded,color:Color(0xFF90B9C8) ,size: 30),
       Icon(Icons.fastfood_rounded,color:Color(0xFF90B9C8) ,size: 30),
       Icon(Icons.notifications,color:Color(0xFF90B9C8) ,size: 30),

        ],
        color: const Color(0xFF0091C4),
        height: 60,
        circleWidth: 50,
        initIndex: tabIndex,
        onChanged: (v) {
          tabIndex = v;
          tabController.animateTo(v);
          setState(() {});
        },
        // tabCurve: ,
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(2),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        shadowColor: Colors.transparent,
        elevation: 10,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          LocationsScreen(),
          FriendListScreen(),
          HomeScreen(),
          FoodDonationHomeScreen(),
          NotificationsScreen()
          

        ],
      ),
    );
  }
    // return Scaffold(
    //   body: ,
    //   // body:Center(
    //   //     child: IndexedStack(
    //   //         index: selected,
    //   //         children: items
    //   //     )//_items.elementAt(_index),
    //   // ),
    //   // extendBody: true, //to make floating action button notch transparent
    //   // bottomNavigationBar: StylishBottomBar(
    //   //   backgroundColor: ColorConstants.bottomBarColor,
    //   //   items: [
    //   //     AnimatedBarItems(
    //   //         unSelectedColor: selected==0?Colors.white:Colors.white54,
    //   //         icon:  const Icon(
    //   //           Icons.location_on,size: 32,
    //   //         ),
    //   //         selectedIcon:  Icon(Icons.house_rounded,size: 35),
    //   //         selectedColor: Colors.white,
    //   //         backgroundColor: Colors.amber,
    //   //         title:  Text('Locations',style:GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w400),)
    //   //     ),
    //   //     AnimatedBarItems(
    //   //         unSelectedColor: selected==1?Colors.white:Colors.white54,
    //   //         icon:  Padding(
    //   //           padding:  EdgeInsets.only(right: MediaQuery.of(context).size.width*0.06),
    //   //           child: const Icon(Icons.person,size: 28,),
    //   //         ),
    //   //         selectedIcon:  const Icon(Icons.person,size: 30),
    //   //         selectedColor: Colors.white,
    //   //         backgroundColor: Colors.amber,
    //   //         title:  Padding(
    //   //           padding:  EdgeInsets.only(right:MediaQuery.of(context).size.width*0.06),
    //   //           child: Text('Friends',style:GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w400),),
    //   //         )),
    //   //     AnimatedBarItems(
    //   //       unSelectedColor: selected==2?Colors.white:Colors.white54,
    //   //       icon:  Padding(
    //   //         padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.06),
    //   //         child: Icon(Icons.fastfood_rounded,size: 28,),
    //   //       ),
    //   //       selectedIcon:  const Icon(
    //   //           Icons.fastfood_rounded,size: 30
    //   //       ),
    //   //       backgroundColor: Colors.amber,
    //   //       selectedColor: Colors.white,
    //   //       title:  Padding(
    //   //         padding:  EdgeInsets.only(left:MediaQuery.of(context).size.width*0.05),
    //   //         child: Text('Food',style:GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w400)),
    //   //       ),),
    //   //     AnimatedBarItems(
    //   //         unSelectedColor:selected==3?Colors.white:Colors.white54,
    //   //         selectedColor: Colors.white,
    //   //         icon:  const Icon(
    //   //             Icons.notifications,size: 28
    //   //         ),
    //   //
    //   //         selectedIcon:  const Icon(
    //   //             Icons.notifications,size: 30
    //   //         ),
    //   //         backgroundColor: Colors.amber,
    //   //
    //   //         title:  Text('Notifications',style:GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.w400))),
    //   //   ],
    //   //   iconSize: 32,
    //   //   barAnimation: BarAnimation.fade,
    //   //   iconStyle: IconStyle.animated,
    //   //   hasNotch: true,
    //   //   fabLocation: StylishBarFabLocation.center,
    //   //   opacity: 0.3,
    //   //   currentIndex: selected,
    //   //   onTap: (index) {
    //   //     setState(() {
    //   //       selected = index!;
    //   //     });
    //   //   },
    //   // ),
    //   // floatingActionButton: FloatingActionButton(
    //   //   onPressed: () {
    //   //     Get.to(const FriendListScreen());
    //   //   },
    //   //   backgroundColor:ColorConstants.bottomBarColor,
    //   //   child: const Icon(
    //   //     CupertinoIcons.house_fill,
    //   //     color: Colors.white,
    //   //
    //   //   ),
    //   // ),
    //   // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // );
  }