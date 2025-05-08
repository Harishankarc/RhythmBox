import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';

class InputBox extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final double? width;
  final bool? textalign;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textColor;

  const InputBox({
    super.key,
    this.hintText,
    required this.controller,
    this.obscureText,
    this.width,
    this.textalign,
    this.fillColor,
    this.borderColor,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        textAlign: textalign == null ? TextAlign.left : TextAlign.center,
         style: TextStyle(color: textColor ?? Colors.black),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: appTextColor, width: 0.1), // Adjusted width
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: fillColor ?? Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: borderColor ??
                  appBackground, // Default to appBackground if null
              width: 1, // Adjusted width
            ),
          ),
        ),
      ),
    );
  }
}
