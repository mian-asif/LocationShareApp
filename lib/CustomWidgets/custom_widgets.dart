import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'constants.dart';


  // Login Text Field Widget
  Widget loginTextField({controller,hintText,errorText,suffixIcon,obscureText,validator,keyboardType}){
    return TextFormField(
      validator:validator ,
      controller: controller,
      obscureText:obscureText ,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(color: const Color(0XFF003E69),fontSize: 14,fontWeight: FontWeight.w600),
        focusColor:ColorConstants.buttonColor,
        errorText: errorText,


      ),
    );
  }

  Widget customButton({buttonTittle,onPressed}){
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(301, 48),
        maximumSize: const Size(301, 48),
      ),
      child: Text(buttonTittle,style: GoogleFonts.montserrat(
          color:ColorConstants.buttonTextColor,fontWeight: FontWeight.bold),
      ),
    );
  }


Widget bottomNavigationBar({selectedIndex,onItemTapped}){
  return BottomNavigationBar(

    backgroundColor: Color(0XFF0091C4),
    selectedItemColor: Colors.white,
    currentIndex: selectedIndex, //New
    onTap: onItemTapped,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled,size: 40),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.fastfood,size: 40),
        label: 'Food',
      ),

    ],
  );
}



Widget customDrawer(){
  return Drawer(
      backgroundColor: Colors.red,
      child: ListView(
        children: const [
          UserAccountsDrawerHeader(
            accountName: Text("Ashish Rawat"),
            accountEmail: Text("ashishrawat2911@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ));
}

Widget friendProfileCard(context,{FriendName}){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return Column(
    children: [
      Container(
        width: cWidth,
        height: cHeight*0.1,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: cHeight*0.01,
                    bottom: cHeight*0.01,
                    left: cWidth*0.06
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child:Image.asset('assets/images/profieImage.png',fit: BoxFit.fill,width: 70,height: 70,),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                    top:cHeight*0.0,
                    left: cWidth*0.04
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(FriendName,style:GoogleFonts.quicksand(fontSize: 15,fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Pakistan',style:GoogleFonts.quicksand(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xff707070)),),
                    ),
                  ],
                ),
              )

            ],
          ),
        ),

      ),
      Divider(height: 10,)
    ],
  );
}

Widget friendRequestCard(context, {name, onPressed,buttonName}){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return Column(
    children: [
      Container(
        width: cWidth,
        height: cHeight*0.1,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: cHeight*0.01,
                    bottom: cHeight*0.01,
                    left: cWidth*0.06
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child:Image.asset('assets/images/profieImage.png',fit: BoxFit.fill,width: 70,height: 70,),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                    top:cHeight*0.0,
                    left: cWidth*0.04
                ),
                child: Container(
                  width: cWidth*0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: cWidth*0.5,
                          child: Text(name,style:GoogleFonts.quicksand(fontSize: 15,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text('Pakistan',style:GoogleFonts.quicksand(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xff707070)),),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                   left: cWidth*0.01,
                ),
                child: ElevatedButton(

                    onPressed:onPressed,
                    child: Text(buttonName,style: GoogleFonts.quicksand(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0091C4),
                    onPrimary: Colors.white,
                    shadowColor: Color(0xFF0091C4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(85, 35), //////// HERE
                  ),

                ),
              )

            ],
          ),
        ),

      ),
      Divider(height: 10,)
    ],
  );
}

Widget contactsCard(context){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return Column(
    children: [
      Container(
        width: cWidth,
        height: cHeight*0.1,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: cHeight*0.01,
                    bottom: cHeight*0.01,
                    left: cWidth*0.06
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  child:Image.asset('assets/images/profieImage.png',fit: BoxFit.fill,width: 70,height: 70,),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                    top:cHeight*0.0,
                    left: cWidth*0.04
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Julian Dasilva',style:GoogleFonts.quicksand(fontSize: 15,fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text('Pakistan',style:GoogleFonts.quicksand(fontSize: 12,fontWeight: FontWeight.w500,color: Color(0xff707070)),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                   left: cWidth*0.15,
                ),
                child: ElevatedButton(

                    onPressed: (){},
                    child: Text('Accept',style: GoogleFonts.quicksand(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0091C4),
                    onPrimary: Colors.white,
                    shadowColor: Color(0xFF0091C4),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(85, 35), //////// HERE
                  ),

                ),
              )

            ],
          ),
        ),

      ),
      Divider(height: 10,)
    ],
  );
}

Widget donationButton(context, {backcolor, icon, iconColor,onTap,height}){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return InkWell(
    onTap: onTap,
    child: Container(
      height: cHeight*0.12,
      width: cWidth*0.24,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(65),
        border: Border.all(color: const Color(0XFF378C5C,),width: 3),
        color: backcolor,
      ),
      child: Center(child: Image.asset(icon,color: iconColor,width: 75,height: height,),),

    ),
  );
}

Widget locationCard(context,{locationTag,senderName}){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return  Padding(
    padding:  EdgeInsets.only(
      left:cWidth*0.0,right: cWidth*0.0,top: cHeight*0.05,
    ),
    child: Container(
      height: cHeight*0.15,
      width: cWidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            // BoxShadow(spreadRadius: 1,blurRadius:6, offset: const Offset(0, 4),color: Colors.grey.shade500,blurStyle: BlurStyle.normal)
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 3,
              blurRadius: 3,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft:Radius.circular(10),bottomLeft: Radius.circular(10))
            ),

            height: cHeight*0.15,
            width: cWidth*0.21,
            child: Image.asset('assets/images/cardMap.png',fit: BoxFit.cover,),
          ),
          Padding(
            padding:  EdgeInsets.only(left: cWidth*0.02),
            child: SizedBox(
              height: cHeight*0.15,
              width: cWidth*0.35,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Icon(Icons.location_on,color: Colors.black,),
                        SizedBox(
                            width: cWidth*0.28,
                            child: Text(locationTag,style:
                            GoogleFonts.montserrat(fontSize: 12,
                                fontWeight: FontWeight.w700,color:
                                const Color(0xff2A2E43)),overflow:
                            TextOverflow.ellipsis,softWrap:false,)),

                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only( left: cWidth*0.05 ),
                    child: Text(senderName,style: GoogleFonts.montserrat(
                        fontSize: 12,fontWeight: FontWeight.w400,color:
                    Color(0xff2A2E43)),),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(
                        top: cHeight*0.01,
                        left: cWidth*0.02
                    ),
                    child: Container(
                        height: cHeight*0.04,
                        width: cWidth*0.25,
                        child: Image.asset('assets/images/cardButton.png',)),
                  )
                ],
              ),

            ),
          ),
          Padding(
            padding:  EdgeInsets.only(right: 5.0,left: 8),
            child: CircleAvatar(

              backgroundColor: Colors.white,
              maxRadius: 35,
              minRadius: 35,
              child: Image.asset('assets/images/profieImage.png',fit: BoxFit.fill,height: 65,width: 65,),
            ),
          )
        ],
      ),

    ),
  );
}
Widget foodRequestCard(context){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return   Container(
    height: cHeight*0.117,width: cWidth,
    decoration:  BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0XFF378C5C),
    ),
    child: Row(
      children: [
        Padding(
          padding:  EdgeInsets.only(left: cWidth*0.05,bottom: cHeight*0.01),
          child: CircleAvatar(minRadius:30.0,maxRadius: 30,child: Image.asset('assets/images/profilerequest.png',fit: BoxFit.fill,),),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: cHeight*0.018,left: cWidth*0.04),
              child:Text('Robert L. Johnson',style:TextConstants.foodRequestCardText ,),
            ),
            Padding(
              padding: EdgeInsets.only(top: cHeight*0.00,left: cWidth*0.04),
              child:Text('20 May 2022',style:TextConstants.foodRequestCardSmallText ,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:  EdgeInsets.only(left: cWidth*0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(left:cWidth*0.03),
                        child:  Icon(Icons.remove_red_eye,color: Colors.white,size: 20,),
                      ),
                      const Text('12',style: TextStyle(color:Colors.white ,fontWeight: FontWeight.w700,fontSize: 12),)
                    ],

                  ),
                ),
                // SizedBox(width: 60,),
                Padding(
                  padding:  EdgeInsets.only(top: cHeight*0.001,left: cWidth*0.2),
                  child: TextButton(onPressed: (){}, child: Text('View Details',style:TextConstants.foodRequestCardViewDetails),),
                )
              ],
            )

          ],
        )
      ],
    ),
  );
}

Widget foodRequestFloatingButton(context,{onPressed}){
  var cWidth  =MediaQuery.of(context).size.width;
  var cHeight  =MediaQuery.of(context).size.height;
  return   FloatingActionButton(
    backgroundColor: const Color(0xFF378C5C),

    onPressed:onPressed,
    child: const Icon(Icons.add,size: 40,),
  );
}


Widget foodRequestTextField({hintText,suffixIcon,controller}){
  return   TextField(
controller:controller ,
    decoration: InputDecoration(
        hintText: hintText ,hintStyle:
    GoogleFonts.montserrat(fontSize: 14,color:const Color(0xFF003E69),fontWeight: FontWeight.w600 ),
        suffixIcon: suffixIcon ,
    ),

  );
}

Widget foodRequestAddPhotoButton(context,{onTap}){
  return DottedBorder(
    color: const Color(0xFF919191),
    dashPattern: const [6, 4],
    strokeWidth: 1.5,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: MediaQuery.of(context).size.height*0.08,
        width: MediaQuery.of(context).size.width*0.16,
        child: const Icon(Icons.add,color:Color(0xFF919191),size: 30),

      ),
    ),
  );
}
Widget foodRequestSearchBar(context,{onTap}){
  return  IntrinsicHeight(

    child:Container(
      // height: MediaQuery.of(context).size.width*0.2,
      color: Colors.white,
      child:  Row(
        children: [
          InkWell(
              onTap: onTap,
              // (){scaffoldKey.currentState!.openDrawer();},
              child: Padding(
                padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05,right: MediaQuery.of(context).size.width*0.03),
                child: SizedBox(
                    width: 30,
                    height: 35,
                    child: Image.asset("assets/images/burgericon.png",)),
              )),
          const VerticalDivider(
            indent: 5,
            endIndent: 5,
            color: Color(0xffF4F4F6),
            thickness: 3,
          ),
          Padding(
            padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.66,
              child: const TextField(
                decoration: InputDecoration(border: InputBorder.none,hintText: 'Search'),
              ),
            ),
          )
        ],
      ),
    )
  );
}


Widget notificationCard(context,{onTap,text,color}){
  return Container(
      height: MediaQuery.of(context).size.height*0.08,
      width: MediaQuery.of(context).size.width*0.04,
      decoration:  const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
          color: Color(0xffF1F1F1),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2,blurRadius: 3,offset: Offset(0, 3),)
        ]
      ),
      child: Padding(
        padding:  const EdgeInsets.only(left: 28.0,),
        child: Row(
          children: [
            Padding(
              padding:  const EdgeInsets.only(bottom: 0.0),
              child: DotsIndicator(
                onTap: onTap ,
                dotsCount: 1,
                position: 0,
                decorator:   DotsDecorator(
                  color: Colors.black87, // Inactive color
                  activeColor: color,

                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.83,
              child:  Padding(
                padding:  const EdgeInsets.only(left: 5.0),
                child: Text(text,style: const TextStyle(color: Color(0xff2A2E43)
                )),
              ),
            ),
          ],
        ),
      )
  );
}








