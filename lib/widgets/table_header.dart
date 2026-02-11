import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TableHeader extends StatelessWidget {
  final String content;
  const TableHeader({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 16,
        color: Color(0xFF335C67),
      ),
    );
  }
}
