import 'package:flutter/material.dart';

class SecondTitle extends StatelessWidget {
  final String title;
  final Color? color;
  const SecondTitle({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? Colors.black,
      ),
    );
  }
}
