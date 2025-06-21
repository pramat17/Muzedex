import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class ItemButtonAtom extends StatelessWidget {
  final double x;
  final double y;
  final bool isFound;
  final VoidCallback onPressed;

  const ItemButtonAtom({
    required this.x,
    required this.y,
    required this.isFound,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: x,
        top: y,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: isFound ? successGreen : primaryOrange,
            padding: const EdgeInsets.all(2.0),
            minimumSize: const Size(24, 24),
          ),
          child: AvatarGlow(
            animate: !isFound,
            glowCount: isFound ? 0 : 3,
            glowColor: primaryOrange,
            glowRadiusFactor: 1.6,
            child: Icon(
              isFound ? Icons.check : Icons.question_mark,
              color: Colors.white,
              size: 16,
            ),
          ),
        ));
  }
}
