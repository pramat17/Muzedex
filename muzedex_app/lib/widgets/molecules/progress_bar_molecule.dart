import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class ProgressBarMolecule extends StatelessWidget {
  const ProgressBarMolecule(
      {super.key, required this.totalItems, required this.discoveredItems});
  final int totalItems; // Nombre d'objets à trouver pour finir la partie
  final int discoveredItems; // Nombre d'objets déjà trouvés

  @override
  Widget build(BuildContext context) {
    bool showButton = totalItems == discoveredItems;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: primaryOrange,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: lightBrown,
                width: 3.0,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: LinearProgressIndicator(
                      value: discoveredItems / totalItems,
                      color: lightBrown,
                      backgroundColor: background,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: TextLabel(
                    color: white,
                    text: '$discoveredItems/$totalItems',
                    fontFamily: 'Inter',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showButton) ...[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/diploma"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                side: const BorderSide(
                  color: lightBrown,
                  width: 3.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: SvgPicture.asset(
                'assets/icons/diploma_icon.svg',
                height: 25,
                width: 25,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
