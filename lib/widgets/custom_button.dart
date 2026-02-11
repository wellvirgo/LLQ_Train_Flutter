import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Color? color;
  final TextStyle? textStyle;
  final OutlinedBorder? shape;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.label,
    this.color,
    this.textStyle,
    this.shape,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: shape,
      ),
      child: Text(label, style: textStyle),
    );
  }
}
