import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../utils/colors.dart';

class ConfettiAtom extends StatelessWidget {
  final ConfettiController controller;

  const ConfettiAtom({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: controller,
      blastDirectionality: BlastDirectionality.explosive,
      shouldLoop: false,
      colors: const [redConfetti, blueConfetti , cyanConfetti, pinkConfetti, 
        purpleConfetti, yellowConfetti, orangeConfetti],
    );
  }
}