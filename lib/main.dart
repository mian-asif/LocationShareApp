import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locate_family/CustomWidgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:locate_family/CustomWidgets/constants.dart';
import 'package:locate_family/LogIn-Screen/View/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Add_Your_LocationFood/View/add_your_food_location.dart';
import 'FoodRequestScreen/View/food_request_screen.dart';
import 'Food_Donation_Home/View/food_donaton_homeScreen.dart';
import 'Food_Request_Details/View/food_request_details_screen.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;
  @override
  initState(){
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    getPermission();
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute:
      FirebaseAuth.instance.currentUser == null ? LogInScreen.id : BottomNavBarScreen.id,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: ColorConstants.buttonColor,
        ),
      ),
      routes: {
        LogInScreen.id: (context) => const LogInScreen(),
        BottomNavBarScreen.id: (context) => BottomNavBarScreen(),
        // Registration.id: (context) => Registration(),
        // ChatApp.id: (context) => ChatApp(),
      },
      home:  const LogInScreen(),
    );
  }
}

