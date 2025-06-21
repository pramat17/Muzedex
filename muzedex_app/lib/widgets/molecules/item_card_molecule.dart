import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/animated_badge_atom.dart';
import 'package:muzedex_app/widgets/atoms/riddle_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';
import 'package:muzedex_app/widgets/organisms/notfounditem_popup_organism.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.index});

  final Item item;
  final int index;

  void _onNotFoundItemPressed(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final room = context.read<RoomCubit>().getRoomByItemId(item.id);

        return NotFoundItemPopupOrganism(item: item, room: room);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.isFound) {
          Navigator.pushNamed(context, '/details', arguments: item);
        } else {
          _onNotFoundItemPressed(context, item);
        }
      },
      child: Stack(
        clipBehavior: Clip.none, // Permet au badge de dépasser le Card si besoin
        children: [
          Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            surfaceTintColor: item.isFound ? successGreen : greyBrown,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: item.isFound ? successGreen : greyBrown,
                width: 2,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Zone d'affichage du titre
                  Expanded(
                    flex: 3,
                    child: Container(
                      color: item.isFound ? successGreen : greyBrown,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: TextLabel(
                        overflow: TextOverflow.ellipsis,
                        text: item.isFound ? item.name : '???',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Zone d'affichage de l'image ou de l'indice
                  Expanded(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: item.isFound
                            ? RiddleAtom(
                                type: 'default',
                                imageLink: item.imageLink,
                                description: null,
                              )
                            : TextLabel(
                                text: '$index',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: greyBrown,
                                  fontSize: 32,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Ajout du badge si l'item est trouvé mais non révélé
          if (item.isFound && !item.isRevealed) const AnimatedBadgeAtom(text: '!')
        ],
      ),
    );
  }
}
