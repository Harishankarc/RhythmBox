import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/auth/Authentication.dart';
import 'package:rhythmbox/auth/EmailVerification.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:rhythmbox/components/appbutton.dart';
import 'package:rhythmbox/components/appbuttonwithicon.dart';
import 'package:rhythmbox/components/inputbox.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:rhythmbox/utils/conectivityservice.dart';
import 'package:rhythmbox/utils/constants.dart';

class SignUp extends StatefulWidget {

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
            crossAxisAlignment: CrossAxisAlignment.center, 
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
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'sign up to see the magic!',
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
                child: InputBox(hintText: 'Name',controller: nameController,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: InputBox(hintText: 'Username',controller: emailController,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: InputBox(hintText: 'Password',controller: passwordController,obscureText: true,),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                child: AppButton(
                  text: "Sign Up",
                  onPressed: () async {
                    int status = await userAuth.signUpUser(emailController.text, passwordController.text, nameController.text);
                    if(status == 200){
                      await Get.to(()=>const Emailverification(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: AppButtonWithIcon(
                  // icon: FontAwesomeIcons.facebook,
                  text: "SignUp with Google",
                  onPressed: () async {
                    //change to google one

                    int status = await userAuth.SignInWithGoogle();
                    if(status == 200){
                      Get.showSnackbar(
                        const GetSnackBar(
                          title: 'Email Verification',
                          message: 'An email has been sent to this email address, please verify',
                          backgroundColor: Colors.yellow,
                          duration: Duration(seconds: 4),
                          snackPosition: SnackPosition.TOP,
                        ),
                      );
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
              GestureDetector(
                onTap: () async {
                  await Get.to(()=>const Login(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
                },
                child: Text('Already have an account? Login',style: TextStyle(fontSize: 15, color: Colors.blue),)
              )

            ],
          ),
        ),
      ),
    );
  }
}
