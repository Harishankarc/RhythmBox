import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Conectivityservice {

  Future<bool> hasInternetConnection() async {
    return await InternetConnection().hasInternetAccess;
  }
  void checkInternet(BuildContext context) async {
    bool isConnected = await hasInternetConnection();

    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("No internet connection"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      print('Connected to internet');
    }
  }
}