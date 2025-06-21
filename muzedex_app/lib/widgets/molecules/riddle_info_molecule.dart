import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';

import '../atoms/text_atom.dart';

// CORRESPOND À L'EXPLICATION D'ÉNIGME
class RiddleInfo extends StatelessWidget {
  const RiddleInfo({super.key});

  @override
  Widget build(BuildContext context) {
    String? playerName = context.read<RoomCubit>().state.playerName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre "Énigme" en gras
        const TextLabel(
          // AFFICHE LE TEXTE "ÉNIGME"
          text: 'Énigme',
          color: textBrown, // Couleur du texte.
          fontWeight: FontWeight.w500, // Style du texte.
          fontFamily: 'Belanosima', // Police de caractères.
          fontSize: 24, // Taille de la police.
        ),
        const SizedBox(height: 16),

        // Texte descriptif
        TextLabel(
          // AFFICHE LE TEXTE DE DESCRIPTION
          text:
              '$playerName, résous l’énigme pour découvrir la carte mystère et l’ajouter à ton Muzédex !',
          fontWeight: FontWeight.normal, // Style du texte.
          fontSize: 14, // Taille de la police.
        ),
      ],
    );
  }
}
