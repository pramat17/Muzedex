import 'package:flutter/material.dart';

class BadgeAtom extends StatelessWidget {
  final int count;
  final Color color;
  final Color textColor;
  final double size;

  const BadgeAtom({
    super.key,
    required this.count,
    this.color = Colors.red,
    this.textColor = Colors.white,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$count',
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}