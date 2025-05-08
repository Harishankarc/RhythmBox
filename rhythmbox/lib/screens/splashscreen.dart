import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rhythmbox/screens/HomePage.dart';
import 'package:rhythmbox/utils/MainNavigation.dart';
import 'package:rhythmbox/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MainNavigation()));
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
