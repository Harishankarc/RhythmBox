import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AppButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 46, 46, 46),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontFamily: appFont,
              color: appTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
