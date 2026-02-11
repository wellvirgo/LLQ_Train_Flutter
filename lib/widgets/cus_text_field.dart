import 'package:flutter/material.dart';

class CusTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconButton? suffixIcon;
  final bool obscureText;

  const CusTextField({
    super.key,
    this.controller,
    this.labelText,
    this.suffixIcon,
    this.obscureText = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}
