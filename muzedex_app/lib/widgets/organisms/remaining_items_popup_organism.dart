import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/molecules/remaining_item_molecule.dart';

class RemainingItemsPopupOrganism extends StatelessWidget {
  final List<Item> items;
  final int roomNumber;

  const RemainingItemsPopupOrganism({
    required this.items,
    required this.roomNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int totalItems = items.length;
    int foundItems = items.where((item) => item.isFound).length;
    String? playerName = context.read<RoomCubit>().state.playerName;

    String message = totalItems == 0
        ? "$playerName, il n'y a pas d'objets à trouver dans cette salle, mais prends le temps de l'explorer ! Il y'a pleins de choses intéressantes à y découvrir !"
        : totalItems == foundItems
            ? "$playerName, tu as trouvé tous les objets de la salle $roomNumber, bravo !"
            : totalItems - foundItems == 1
                ? "Tu y es presque $playerName ! Plus qu'un objet à trouver dans la salle $roomNumber !"
                : "$playerName, il te reste ${totalItems - foundItems} objets à trouver dans la salle $roomNumber, bon courage !";

    return AlertDialog(
      backgroundColor: lightSand,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: const Text(
        'Progression des objets',
        style: TextStyle(
          fontFamily: "Belanosima",
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: textBrown,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/images/zarafa_image.png',
                  height: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 14, color: textBrown),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Column(
            children: items.asMap().entries.map((entry) {
              Item item = entry.value;
              return RemainingItemMolecule(item: item);
            }).toList(),
          ),
        ],
      ),
      actions: [
        Center(
          child: ButtonAtom(
            text: 'RETOUR',
            textColor: white,
            color: primaryOrange,
            onPressed: () => Navigator.of(context).pop(),
            isFixed: false,
          ),
        ),
      ],
    );
  }
}
