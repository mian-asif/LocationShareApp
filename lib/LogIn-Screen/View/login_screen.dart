import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_family/SignUp_Screen/View/sign_up_screen.dart';
import '../../CustomWidgets/BottomNavigationBar/bottom_navigation_bar.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';
class LogInScreen extends StatefulWidget {
  static String id = 'login';
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  late bool passwordVisible;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
   bool _validate = false;
   bool passwordValidate = false;
  late bool loading=false;

  @override
  void initState() {
   setState((){
     passwordVisible=false;
      });
  }

   getToken() async {
     await FirebaseMessaging.instance.getToken().then((token) async {
       print('token: $token');
       await FirebaseFirestore.instance
           .collection("users")
           .where("email", isEqualTo: emailController.text.trim())
           .get()
           .then(
             (QuerySnapshot snapshot) => {
           snapshot.docs.forEach((docRef) {
             FirebaseFirestore.instance
                 .collection("users")
                 .doc(docRef.reference.id)
                 .update({"pushToken": token});
           }),
         },
       );
     }).catchError((err) {
       print("err $err");
     });

   }
  Future<void> validateUser() async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (userCredential != null) {

      }
      getToken();
      Get.off(const BottomNavBarScreen());
    } on FirebaseAuthException catch  (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
      }
      if (kDebugMode) {
        print(e.message);
      }
      MotionToast.error(
        position:MotionToastPosition.bottom,
          // title:  Text("Error"),
          description:  Text(e.message.toString())
      ).show(context);
    }
  }
  @override
  Widget build(BuildContext context) {
   var MediaWidth= MediaQuery.of(context).size.width;
   var MediaHeight= MediaQuery.of(context).size.height;
   var hPadding=MediaQuery.of(context).size.height;
   var wPadding=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Colors.white,
      body:SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
         key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: MediaWidth*0.13
                ),
                child: Center(
                    child: Image.asset("assets/images/loginScreenImage.png",
                    width:MediaWidth*0.7,height:MediaWidth*0.7,fit: BoxFit.contain)),
              ),
              //Email Text Field
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.04,
                    left: wPadding*0.1,
                    right: wPadding*0.1
                ),
                child: loginTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  errorText: _validate ? 'Email Can\'t Be Empty' : null,

                ),
              ),
              //Password Text Field
              Padding(
                padding:  EdgeInsets.only(
                  top: hPadding*0.04,
                    left: wPadding*0.1,
                    right: wPadding*0.1
                ),
                child: loginTextField(
                  controller: passwordController,
                  hintText: "Password",
                   errorText: _validate ? 'Password Can\'t Be Empty' : null,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(onPressed: (){
                    setState((){
                      passwordVisible=!passwordVisible;
                    });
                  }, icon: Icon(passwordVisible? Icons.visibility:Icons.visibility_off))
                ),
              ),
              //Forgot Password
              Padding(
                padding:  EdgeInsets.only(
                    left: wPadding*0.1,
                    right: wPadding*0.08,
                ),
                child: TextButton(
                  onPressed: (){},
                  style: ButtonConstants.forgotPassword,
                  child: const Text("Forgot Password?"),),
              ),
              //Login Button
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.02
                ),
                child: Center(
                    child:loading? const CircularProgressIndicator(): customButton(
                      onPressed: () async {
                       setState((){
                          emailController.text.isEmpty ? _validate = true : _validate = false;
                          passwordController.text.isEmpty ? passwordValidate = true : passwordValidate = false;
                          loading=true;
                        });
                       emailController.text.isNotEmpty ||  passwordController.text.isNotEmpty ? await validateUser():null;
                       setState((){
                         loading=false;
                       });

                      },
                      buttonTittle: "LOG IN"
                    ),
                ),
              ),
              // Don't have an account? Sign Up
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.15

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("Don't have an account?",style: TextConstants.brownText,),
                    TextButton(onPressed: (){
                     Get.to(const SignUpScreen());

                    }, child:Text("Sign Up",style: TextConstants.signupText,))
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
