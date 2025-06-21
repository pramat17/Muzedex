import 'package:flutter/material.dart';
import 'package:muzedex_app/widgets/atoms/riddle_atom.dart';
import '../../utils/colors.dart';
import '../atoms/text_atom.dart';

class ClueGuess extends StatelessWidget {
  final String? imageLink;
  final String riddleText;
  final String type;
  final String? description;

  const ClueGuess({
    this.imageLink,
    required this.riddleText,
    required this.type,
    this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          if (type != 'Qui-suis-je') ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: RiddleAtom(
                  type: type,
                  imageLink: imageLink,
                  description: description,
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextLabel(
              text: riddleText,
              color: textBrown,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}