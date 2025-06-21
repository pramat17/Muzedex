import 'package:flutter/material.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';

class NotFoundItemPopupOrganism extends StatefulWidget {
  final Item item;
  final Room room;

  const NotFoundItemPopupOrganism(
      {super.key, required this.item, required this.room});

  @override
  State<NotFoundItemPopupOrganism> createState() =>
      _NotFoundItemPopupOrganismState();
}

class _NotFoundItemPopupOrganismState extends State<NotFoundItemPopupOrganism> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: lightSand,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Text(
        'Carte non trouvée',
        style: TextStyle(
            fontFamily: "Belanosima",
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textBrown),
      ),
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image "assets/ppzarafa.png"
            Image.asset(
              'assets/images/conseilzarafa.png',
              height: 50,
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                text: "Cette carte se trouve à ",
                style: const TextStyle(fontSize: 14, color: textBrown),
                children: <TextSpan>[
                  TextSpan(
                    text: "l'étage ${widget.room.floor}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const TextSpan(text: " dans la "),
                  TextSpan(
                    text: "salle ${widget.room.number} : ${widget.room.name}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            ButtonAtom(
              text: 'RETOUR',
              textColor: white,
              color: primaryOrange,
              onPressed: () => Navigator.of(context).pop(),
              isFixed: false,
            ),
          ],
        ),
      ],
    );
  }
}
