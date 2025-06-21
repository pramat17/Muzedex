import 'package:flutter/material.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';

// Affiche un objet d'une salle dans la liste des objets restants à trouver avec redirection vers la page de détails ou de l'énigme
class RemainingItemMolecule extends StatelessWidget {
  final Item item;

  const RemainingItemMolecule({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.isFound) {
          Navigator.pushNamed(context, '/details', arguments: item);
        } else {
          Navigator.pushNamed(context, '/riddle', arguments: item);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.isFound ? successGreen : primaryOrange,
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(
                item.isFound ? Icons.check : Icons.question_mark,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                item.isFound ? item.name : "???",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textBrown,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryOrange,
                border: Border.all(color: lightBrown, width: 3),
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.arrow_outward_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
