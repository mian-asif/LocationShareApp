import 'package:locate_family/LogIn-Screen/View/login_screen.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locate_family/CustomWidgets/BottomNavigationBar/bottom_navigation_bar.dart';
import '../../CustomWidgets/constants.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController fullNameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  late bool passwordVisible;
   late bool loading=false;
  bool emailValidate = false;
  bool passwordValidate = false;
  bool phoneValidate = false;
  bool nameValidate = false;
  var phoneNumber;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    setState((){
      passwordVisible=false;
       phoneNumber= phoneController;
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
  userRegistration() async {
    try {
      UserCredential result  = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
    );
      getToken();
      Get.offAll(const BottomNavBarScreen());
      User? user = result.user;
      user?.updateDisplayName(fullNameController.text ); //added this line
      return user!;
      // await FirebaseAuth.instance.currentUser?.updateDisplayName(fullNameController.text);
      // await FirebaseAuth.instance.currentUser?.updatePhotoURL('');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
      MotionToast.error(
          position:MotionToastPosition.bottom,
          title:  const Text("Error"),
          description:  Text(e.message.toString())
      ).show(context);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

    }

  }
  addUser() async {
     FirebaseFirestore.instance.collection('users').add({
      'full_name': fullNameController.text, // John Doe
      'phone': phoneController.text, // Stokes and Sons
      'email': emailController.text, // Stokes and Sons
      'user_uid':auth.currentUser?.uid, // Stokes and Sons
      'photoURL':auth.currentUser?.photoURL, // Stokes and Sons
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  addUserPhone() async {
     FirebaseFirestore.instance.collection('phoneData').add({
      'phone': phoneController.text, // Stokes and Sons// Stokes and Sons
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  @override
  Widget build(BuildContext context) {

    var MediaWidth= MediaQuery.of(context).size.width;
    var MediaHeight= MediaQuery.of(context).size.height;
    var hPadding=MediaQuery.of(context).size.height;
    var wPadding=MediaQuery.of(context).size.width;

    var formKey;
    return Scaffold(
      backgroundColor:Colors.white,
      body:SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:  EdgeInsets.only(
                    top: MediaWidth*0.15
                ),
                child: Center(
                    child: Image.asset("assets/images/SignUp.png",
                        width:MediaWidth*0.7,height:MediaWidth*0.45,fit: BoxFit.contain)),
              ),
              //Full Name Text Field
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.02,
                    left: wPadding*0.1,
                    right: wPadding*0.1
                ),
                child: loginTextField(
                    controller: fullNameController,
                    hintText: "Full Name",
                    obscureText: false,
                     errorText: nameValidate? 'Name Can\'t Be Empty' : null,
                ),
              ),
              //Email Name Text Field
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
                  errorText: emailValidate? 'Email Can\'t Be Empty' : null,


                ),
              ),
              //Phone Name Text Field
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.04,
                    left: wPadding*0.1,
                    right: wPadding*0.1
                ),
                child: loginTextField(

                    controller: phoneController,
                    hintText: "Phone",
                    obscureText: false,
                  errorText: phoneValidate? 'Phone Can\'t Be Empty' : null,
                  keyboardType: TextInputType.number
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
                    obscureText: !passwordVisible,
                    errorText: passwordValidate? 'Password Can\'t Be Empty' : null,
                    suffixIcon: IconButton(onPressed: (){
                      setState((){
                        passwordVisible=!passwordVisible;
                      });
                    }, icon: Icon(passwordVisible? Icons.visibility:Icons.visibility_off))
                ),
              ),
              //Login Button
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.06
                ),
                child: Center(
                  child: loading? const CircularProgressIndicator():customButton(
                      onPressed: () async {
                        setState((){
                          emailController.text.isEmpty ? emailValidate = true : emailValidate = false;
                          passwordController.text.isEmpty ? passwordValidate = true : passwordValidate = false;
                          phoneController.text.isEmpty ? phoneValidate = true : phoneValidate = false;
                          fullNameController.text.isEmpty ? nameValidate = true : nameValidate = false;
                          loading=true;

                        });
                          await userRegistration();
                          await addUser();
                          await addUserPhone();
                        setState((){
                          loading=false;
                        });

                      },
                      buttonTittle:"SIGN UP"
                  ),
                ),
              ),
              Padding(
            padding:  EdgeInsets.only(top: hPadding*0.03),
            child: Center(
                child: Text("By continuing, you agree to accept our \n  "
                    "  Privacy Policy & Terms of Service.",style: TextConstants.signUpBrownText,)),
          ),
              //    Already have an account?? LogIn Up
              Padding(
                padding:  EdgeInsets.only(
                    top: hPadding*0.06

                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    Text("Already have an account?",style: TextConstants.brownText,),
                    TextButton(onPressed: (){
                      Get.off(LogInScreen());
                    }, child:Text("Log In",style: TextConstants.signupText,))
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
