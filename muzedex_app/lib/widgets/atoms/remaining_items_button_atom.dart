import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/organisms/remaining_items_popup_organism.dart';

// Bouton de toggle de la popup affichant les objets restants à trouver dans une salle
class RemainingItemsButtonAtom extends StatelessWidget {
  final double x;
  final double y;
  final int roomNumber;
  final List items;

  const RemainingItemsButtonAtom({
    required this.x,
    required this.y,
    required this.roomNumber,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int totalItems = items.length;
    int foundItems = items.where((item) => item.isFound).length;
    bool hasItems = totalItems > 0;
    bool allFound = foundItems == totalItems;

    return Positioned(
      left: x,
      top: y,
      child: TextButton(
        onPressed: () {
          // if (hasItems) {
          showDialog(
            context: context,
            builder: (context) => RemainingItemsPopupOrganism(
              items: [...items],
              roomNumber: roomNumber,
            ),
          );
          // }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          backgroundColor:
              hasItems ? (allFound ? successGreen : primaryOrange) : greyBrown,
          minimumSize: const Size(50, 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AvatarGlow(
          animate: totalItems != 0,
          glowCount: totalItems == 0 ? 0 : 3,
          glowColor: allFound ? successGreen : primaryOrange,
          glowRadiusFactor: 1.1,
          child: totalItems == 0
              ?
              // Icon SVG eye_icon
              SvgPicture.asset(
                  'assets/icons/eye_icon.svg',
                  width: 20,
                  height: 20,
                )
              : Text(
                  "$foundItems/$totalItems",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Belanosima",
                    color: white,
                  ),
                ),
        ),
      ),
    );
  }
}
