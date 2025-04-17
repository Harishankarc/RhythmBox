import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/auth/Authentication.dart';
import 'package:rhythmbox/auth/signup.dart';
import 'package:rhythmbox/components/appbutton.dart';
import 'package:rhythmbox/components/inputbox.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:rhythmbox/utils/constants.dart';

class Login extends StatefulWidget {
  
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  Authentication userAuth = new Authentication();
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
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/images/profile.jpg'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WELCOME TO RHYTHMBOX',
                          style: TextStyle(
                            fontFamily: appFont,
                            color: appTextColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'login to see the magic!',
                          style: TextStyle(
                            fontFamily: appFont,
                            color: appTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'LOGIN',
                style: TextStyle(
                  fontFamily: appFont,
                  color: appTextColor,
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
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
                  text: "login",
                  onPressed: () async {
                    final status = await userAuth.loginUser(emailcontroller.text, passwordcontroller.text);
                    if(status == 200){
                       await Get.to(()=>const HomePage(),transition: Transition.cupertino,duration: const Duration(milliseconds: 500));
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