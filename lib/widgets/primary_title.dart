import 'package:flutter/material.dart';

class PrimaryTitle extends StatelessWidget {
  final String title;

  const PrimaryTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
