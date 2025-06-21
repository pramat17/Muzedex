import 'package:flutter/material.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../utils/colors.dart'; // Importez le fichier de couleurs

// CORRESPOND AU NUMÉRO + TITRE DE L'OBJET (DETAILS )
class DetailsSubjectMolecule extends StatelessWidget {
  final String number;
  final String label;

  const DetailsSubjectMolecule(
      {required this.number, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Ajoutez un peu de padding
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centre le texte horizontalement
        children: [
          TextLabel(
              text: number,
              fontFamily: 'Belanosima',
              color: textBrown,
              fontWeight: FontWeight.w900,
              fontSize: 24), // AFFICHE LE NUMÉRO DE L'OBJET
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
                fontSize: 24,
                fontFamily: 'Belanosima',
                fontWeight: FontWeight.normal,
                color: textBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
