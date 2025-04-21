import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rhythmbox/auth/Authentication.dart';
import 'package:rhythmbox/auth/signup.dart';
import 'package:rhythmbox/components/appbutton.dart';
import 'package:rhythmbox/components/appbuttonwithicon.dart';
import 'package:rhythmbox/components/inputbox.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:rhythmbox/screens/splashscreen.dart';
import 'package:rhythmbox/utils/conectivityservice.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Login extends StatefulWidget {
  
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  Authentication userAuth = new Authentication();
  Conectivityservice _conectivityservice = Conectivityservice();
  @override
  void initState() {
    super.initState();
    _conectivityservice.checkInternet(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'WELCOME TO',
                          style: TextStyle(
                            fontFamily: appFont,
                            color: appTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'RHYTHMBOX',
                          style: TextStyle(
                            fontFamily: appFont,
                            color: appTextColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'login to see the magic!',
                          style: TextStyle(
                            fontFamily: appFont,
                            color: appTextColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: InputBox(hintText: 'Username',controller: emailcontroller,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: InputBox(hintText: 'Password',controller: passwordcontroller,obscureText: true,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: AppButton(
                  text: "Login",
                  onPressed: () async {
                    final status = await userAuth.loginUser(emailcontroller.text, passwordcontroller.text);
                    if(status == 200){
                       await Get.to(()=>const HomePage(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                    }else if (status == 500) {
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Error',
                          message: 'Invalid Credentials',
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        ),
                      );
                    } else {
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Error',
                          message: 'Something went wrong',
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        ),
                      );
                    }
                  },
                ),
              ),

              //google
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AppButtonWithIcon(
                  // icon: FontAwesomeIcons.facebook,
                  text: "Login with Google",
                  onPressed: () async {
                    final status = await userAuth.SignInWithGoogle();
                    if(status == 200){
                       await Get.to(()=>const SplashScreen(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                    }else if (status == 500) {
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Error',
                          message: 'Invalid Credentials',
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        ),
                      );
                    } else {
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Error',
                          message: 'Something went wrong',
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          snackPosition: SnackPosition.TOP,
                        ),
                      );
                    }
                  },
                ),
              ),

              GestureDetector(
                onTap: () async {
                   await Get.to(()=>const SignUp(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                },
                child: Text('Dont have an account? Sign Up',style: TextStyle(fontSize: 15, color: Colors.blue),),
              )
            ]
        )
      )
      ),
    );
  }
}
