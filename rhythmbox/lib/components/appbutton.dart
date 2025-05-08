import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  const AppButton({super.key, required this.text, required this.onPressed,this.width,this.backgroundColor,this.textColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? const Color.fromARGB(255, 46, 46, 46),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),

        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: textColor ??appTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
