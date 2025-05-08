import 'package:flutter/material.dart';
import 'package:rhythmbox/utils/constants.dart';

class AppButtonWithIcon extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  const AppButtonWithIcon({super.key, required this.text, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 46, 46, 46),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),

        ),
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(
              color: appTextColor,
              fontSize: 15,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
