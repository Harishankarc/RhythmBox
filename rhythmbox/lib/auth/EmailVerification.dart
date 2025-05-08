import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rhythmbox/auth/login.dart';
import 'package:rhythmbox/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';


class Emailverification extends StatelessWidget {
  const Emailverification({super.key});

  void _EmailUrlLaunchWeb() async{
    const url = 'https://www.gmail.com';
    if (await canLaunchUrl(Uri(userInfo: url))) {
      await launchUrl(Uri(userInfo: url));
    } else {
      throw 'Could not launch $url';
    }
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
              const Text(
                'Email Verification',
                style: TextStyle(
                  color: appTextColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Check your email for verification link',
                style: TextStyle(
                  color: appTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Text(
                'Press the button to verify the email',
                style: TextStyle(
                  color: appTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    _EmailUrlLaunchWeb();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: appTextColor4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  child: const Text(
                    'Verify Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextButton(
                  onPressed: () async {
                    await Get.to(() => const Login(), transition: Transition.cupertino, duration: const Duration(milliseconds: 500));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: appTextColor4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  child: const Text(
                    'Go to Login Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
