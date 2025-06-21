import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class TextLabel extends StatelessWidget {
  final String text;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;

  const TextLabel({
    required this.text,
    this.fontFamily,
    this.fontWeight,
    this.color,
    this.fontSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: successGreen,
        borderRadius: BorderRadius.circular(10.0), // Réduit le border radius
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical:
              2.0), // Ajuste le padding pour rendre le conteneur plus long et moins haut
      child: Text(
        text,
        style: TextStyle(
          fontFamily: fontFamily ?? 'Inter',
          fontWeight: fontWeight,
          color: white,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
