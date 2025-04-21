import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController controller;
  final double? width;
  final bool? textalign ;
  const InputBox({super.key, this.hintText, required this.controller, this.obscureText, this.width, this.textalign});

  @override

  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        textAlign:  textalign == null ? TextAlign.left : TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
          ),
        )
      
      ),
    );
  }
}