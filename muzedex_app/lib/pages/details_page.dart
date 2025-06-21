import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart' as model;
import 'package:muzedex_app/widgets/atoms/riddle_atom.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';
import 'package:muzedex_app/widgets/organisms/details_card_organism.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)?.settings.arguments as model.Item?;

    if (item == null) {
      return const Scaffold(
        body: Center(child: Text('Erreur : Aucun élément fourni.')),
      );
    }

    // Récupération de toutes les salles via le RoomCubit
    final rooms = context.read<RoomCubit>().state.rooms;

    // Trouver la salle associée à l'item
    final room = rooms.firstWhere(
      (room) => room.items.contains(item),
      orElse: () => throw Exception('Salle non trouvée'),
    );

    final itemNumber = context.read<RoomCubit>().getItemNumberById(item.id);

    return Scaffold(
      appBar: const HeaderMolecule(
        title: 'Carte',
        hasBackButton: true,
      ),
      body: Stack(
        children: [
          // Fond avec l'image de fond couvrant toute la page
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // L'image du cercle positionnée en haut
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/demi-cercle.svg',
              ),
            ),
          ),
          // La carte de détails (DetailsCard) placée en bas
          Positioned.fill(
            top: 180,
            child: Align(
              alignment: Alignment.topCenter,
              child: DetailsCard(
                item: item, 
                itemNumber:itemNumber,
                roomName: room.name,
              ),
            ),
          ),
          // Image principale placée en haut
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.topCenter,
              child: RiddleAtom(
                imageLink: item.imageLink,
                size: 220,
                type: '',
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
            bottom: -70,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/leavesBottomMap.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const FooterMolecule(currentIndex: 1),
    );
  }
}
 


 