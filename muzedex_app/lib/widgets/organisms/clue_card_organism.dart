import 'package:flutter/material.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/widgets/molecules/clue_guess_molecule.dart';

import '../molecules/clue_type_molecule.dart';

class ClueCard extends StatelessWidget {
  final Clue clue;
  final String imageLink;
  final String whoAmI;

  const ClueCard({
    required this.clue,
    required this.imageLink,
    required this.whoAmI,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClueType(
          type: clue.type,
          label: clue.type,
        ),
        const SizedBox(height: 14),
        ClueGuess(
          imageLink: clue.type != 'Qui-suis-je ?' ? imageLink : null,
          type: clue.type,
          riddleText: clue.text,
          description: clue.type == 'Qui-suis-je ?' ? whoAmI : null,
        ),
      ],
    );
  }
}
