import 'package:flutter/material.dart';

class TextLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign; // Permet de définir l'alignement du texte
  final TextOverflow? overflow; // Gère les débordements de texte
  final double? lineHeight;

  const TextLabel({
    required this.text,
    this.style,
    this.fontFamily,
    this.fontWeight,
    this.color,
    this.fontSize,
    this.textAlign,
    this.overflow,
    this.lineHeight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign, // Utilisation de l'alignement
      overflow: overflow, // Gestion des débordements
      style: style?.copyWith(
            fontFamily: fontFamily ?? 'Inter',
            fontWeight: fontWeight,
            color: color,
            fontSize: fontSize,
            height: lineHeight,
          ) ??
          TextStyle(
            fontFamily: fontFamily ?? 'Inter',
            fontWeight: fontWeight,
            color: color,
            fontSize: fontSize,
            height: lineHeight,
          ),
    );
  }
}
