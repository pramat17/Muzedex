import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class AnimatedBadgeAtom extends StatelessWidget {
  final String text;

  const AnimatedBadgeAtom({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: AvatarGlow(
        animate: true,
        glowCount: 2,
        glowColor: Colors.red,
        glowRadiusFactor: 1.2,
        duration: const Duration(milliseconds: 1000),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
