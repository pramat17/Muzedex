import 'package:flutter/material.dart';
import 'package:muzedex_app/widgets/atoms/icon_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

import '../../utils/colors.dart';

// CORRESPOND AU TYPE DE L'ÉNIGME
class ClueType extends StatelessWidget {
  final String type;
  final String label;

  const ClueType({required this.type, required this.label, super.key});

  String _getIconPath(String type) {
    switch (type) {
      case 'Shadobject':
        return 'assets/icons/shadobject_icon.svg';
      case 'FlouFou':
        return 'assets/icons/floufou_icon.svg';
      case 'Qui-suis-je ?':
        return 'assets/icons/quisuisje_icon.svg';
      // Ajoutez d'autres cas ici pour différents types
      default:
        return 'assets/icons/default.svg'; // Icône par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: primaryOrange, 
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: lightBrown,
          width: 3.0,
        ),
      ),
      child: Row(
        children: [
          IconAtom(
              color: white,
              imageLink: _getIconPath(
                  type)), // AFFICHE L'ICÔNE EN FONCTION DU TYPE D'ENIGME
          const SizedBox(width: 8), // Espacement.
          TextLabel(
            // AFFICHE LE TEXTE DU TYPE D'ENIGME
            text: label,
            fontFamily: 'Belanosima',
            fontSize: 15,
            fontWeight: FontWeight.bold, // Utilise la version bold de la police
            color: white, // Utilisez la couleur primaire
          ),
        ],
      ),
    );
  }
}
