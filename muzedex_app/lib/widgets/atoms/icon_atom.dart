import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconAtom extends StatelessWidget {
  final String imageLink;
  final double? size;
  final Color? color;

  const IconAtom({
    required this.imageLink,
    this.size,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? 30, // Taille par défaut 30 si non spécifié.
      height: size ?? 30,
      child: SvgPicture.asset(
        imageLink,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        width: size ?? 30,
        height: size ?? 30,
        fit: BoxFit.contain,
      ),
    );
  }
}
