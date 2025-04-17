import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String? hintText;
  final bool? obscureText;
  final TextEditingController controller;
  const InputBox({super.key, this.hintText, required this.controller, this.obscureText});

  @override

  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
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

    );
  }
}