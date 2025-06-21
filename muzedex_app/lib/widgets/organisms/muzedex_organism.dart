import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';
import 'package:muzedex_app/widgets/molecules/item_card_molecule.dart';
import 'package:muzedex_app/widgets/molecules/progress_bar_molecule.dart';

class MuzedexOrganism extends StatelessWidget {
  const MuzedexOrganism({super.key, required this.items});
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    int totalItems = items.length;
    int discoveredItems = items.where((item) => item.isFound).length;
    int itemsLeft = totalItems - discoveredItems;
    String? playerName = context.read<RoomCubit>().state.playerName;

    return Stack(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(
                    top: 16.0, left: 8.0, right: 8.0, bottom: 8.0),
                child: TextLabel(
                  text: 'Collection de cartes',
                  color: textBrown,
                  fontFamily: 'Belanosima',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextLabel(
                  color: textBrown,
                  text: itemsLeft == 0
                      ? '$playerName ! Tu as trouvé tous les objets !'
                      : '$playerName, il te reste ${totalItems - discoveredItems} objets à découvrir pour compléter ton Muzédex !',
                  fontFamily: 'Inter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProgressBarMolecule(
                  totalItems: totalItems,
                  discoveredItems: discoveredItems,
                ),
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Nombre d'éléments par ligne
                  crossAxisSpacing: 5, // Espacement horizontal
                  mainAxisSpacing: 10, // Espacement vertical
                  childAspectRatio: 1, // Ratio hauteur/largeur des widgets
                ),
                itemCount: items.length,
                clipBehavior: Clip.antiAlias,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final Item item = items[index];
                  return ItemCard(
                    item: item,
                    index: index + 1,
                  );
                },
              ),
              // Div vide de 80 de haut pour éviter que le bouton ne soit caché par le clavier
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Image.asset(
          'assets/images/orangeGradientBottom.png',
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        bottom: -60,
        left: 0,
        right: 0,
        child: Image.asset(
          'assets/images/leavesBottomMap.png',
          fit: BoxFit.cover,
        ),
      ),
    ]);
  }
}
