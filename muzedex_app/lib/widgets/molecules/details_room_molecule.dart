import 'package:flutter/material.dart';
import 'package:muzedex_app/widgets/atoms/icon_atom.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../utils/colors.dart'; // Importez le fichier de couleurs

// CORRESPOND AU TYPE DE L'ÉNIGME
class DetailsRoomMolecule extends StatelessWidget {
  final String label;

  const DetailsRoomMolecule({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Ajoutez un peu de padding
      decoration: BoxDecoration(
        color: primaryOrange, // Utilisez la couleur blanche comme arrière-plan
        borderRadius: BorderRadius.circular(12.0), // Ajoutez un rayon de coin
        border: Border.all(
          color: lightBrown, // Couleur de la bordure
          width: 3.0, // Épaisseur de la bordure
        ),
      ),
      child: Row(
        children: [
          const IconAtom(color: white, imageLink: 'assets/icons/map_point.svg'),
          const SizedBox(width: 8), // Espacement.
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            child: TextScroll(
              label,
              mode: TextScrollMode.bouncing,
              velocity: const Velocity(pixelsPerSecond: Offset(100, 0)),
              delayBefore: const Duration(milliseconds: 500),
              pauseBetween: const Duration(milliseconds: 2000),
              pauseOnBounce: const Duration(milliseconds: 1000),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Belanosima",
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
