import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:locate_family/Home_Screen/View/home_screen.dart';
import 'package:locate_family/LogIn-Screen/View/login_screen.dart';
import '../../CustomWidgets/custom_widgets.dart';
import 'package:motion_toast/motion_toast.dart';
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController =TextEditingController();
  TextEditingController newPasswordController =TextEditingController();
  var myEmail = Get.arguments[0];
  bool _validate = false;
  late bool loading=false;
   late bool passwordVisible;
   late bool newPasswordVisible;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    setState(() {
      passwordVisible = false;
      newPasswordVisible = false;
    });
  }

   changePassword(String password) async {
     final FirebaseAuth user = FirebaseAuth.instance;
    String? email = user.currentUser?.email;

    //Create field for user to input old password

    //pass the password here
    String password = passwordController.text;
    String newPassword = newPasswordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: myEmail,
        password: passwordController.text,
      );

   await user.currentUser?.updatePassword(newPassword).then((_){
        print("Successfully changed password");
        MotionToast.success(
          // title:  Text("Error"),
            description:  const Text('Successfully changed password'),
        ).show(context);
      }).catchError((error){
        print("Password can't be changed$error");
        MotionToast.error(
          // title:  Text("Error"),
            description:   Text("Password can't be changed$error")
        ).show(context);

        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        MotionToast.error(
          // title:  Text("Error"),
            description:  Text(e.message.toString())
        ).show(context);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        MotionToast.error(

          // title:  Text("Error"),
            description:  Text(e.message.toString())
        ).show(context);
      }
    }
  }

  Future<void> validateUser() async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: passwordController.text.trim(),
          password: passwordController.text.trim());
      if (userCredential != null) {

      }

    } on FirebaseAuthException catch  (e) {
      if (kDebugMode) {
        print('Failed with error code: ${e.code}');
      }
      if (kDebugMode) {
        print(e.message);
      }
      MotionToast.error(
          // title:  Text("Error"),
          description:  Text(e.message.toString())
      ).show(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    var cHeight=MediaQuery.of(context).size.height;
    var cWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.08,left: cWidth*0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(top: cHeight*0.04,left: cWidth*0.1),
              child: Text('Change Password',style: GoogleFonts.montserrat(color: Color(0XFF2A2E43),fontSize: 20,fontWeight: FontWeight.w600),),
            ),

            Padding(
              padding:  EdgeInsets.only(
                  top: cHeight*0.08,left: cWidth*0.1,right: cWidth*0.1
              ),
              child: loginTextField(
                  controller: passwordController,
                  hintText: "Old Password",
                  errorText: _validate ? 'Password Can\'t Be Empty' : null,
                  obscureText: !passwordVisible,
                  suffixIcon: IconButton(onPressed: (){
                    setState((){
                      passwordVisible=!passwordVisible;
                    });
                  }, icon: Icon(passwordVisible? Icons.visibility:Icons.visibility_off))
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  top: cHeight*0.07,left: cWidth*0.1,right: cWidth*0.1
              ),
              child: loginTextField(
                  controller: newPasswordController,
                  hintText: "New Password",
                  errorText: _validate ? 'Password Can\'t Be Empty' : null,
                  obscureText: !newPasswordVisible,
                  suffixIcon: IconButton(onPressed: (){
                    setState((){
                      newPasswordVisible=!newPasswordVisible;
                    });
                  }, icon: Icon(newPasswordVisible? Icons.visibility:Icons.visibility_off))
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  top: cHeight*0.1
              ),
              child: Center(
                child:loading? const CircularProgressIndicator(): customButton(
                    onPressed: () async {
                      // changePassword();
                      setState((){
                        passwordController.text.isEmpty ? _validate = true : _validate = false;
                        loading=true;
                      });
                      passwordController.text.isNotEmpty ||  passwordController.text.isNotEmpty ? await changePassword(newPasswordController.text):null;
                      setState((){
                        loading=false;
                      });

                    },
                    buttonTittle: "save"
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
