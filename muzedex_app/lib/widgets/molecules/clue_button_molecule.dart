import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/badge_atom.dart';

class ClueButtonMolecule extends StatelessWidget {
  final int remainingCluesCount;
  final VoidCallback? onPressed;

  const ClueButtonMolecule({
    super.key,
    required this.remainingCluesCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ButtonAtom avec fond blanc / texte marron
        ButtonAtom(
          iconPath: 'assets/icons/lightbulb_icon.svg',
          text: 'INDICE',
          color: white,
          textColor: darkBrown,
          
          // On passe la callback ou null => in-cliquable.
          onPressed: onPressed,
          isFixed: true,
        ),

        // La bulle, positionnée dans le coin du bouton
        Positioned(
          top: -6,
          right: -6,
          child: BadgeAtom(
            count: remainingCluesCount,
            color: Colors.red,
            textColor: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }
}