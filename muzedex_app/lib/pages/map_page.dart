import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';
import 'package:muzedex_app/widgets/organisms/map_organism.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Récupération des arguments passés à la page
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final itemJustFound = arguments?['itemJustFound'] as Item?;

    final floorAssets = [
      {
        'floorImage': 'assets/images/mapfloor0.png',
        'floorSvg': 'assets/images/mapfloor0.svg',
      },
      {
        'floorImage': 'assets/images/mapfloor1.png',
        'floorSvg': 'assets/images/mapfloor1.svg',
      },
      {
        'floorImage': 'assets/images/mapfloor2.png',
        'floorSvg': 'assets/images/mapfloor2.svg',
      },
      {
        'floorImage': 'assets/images/mapfloor3.png',
        'floorSvg': 'assets/images/mapfloor3.svg',
      }
    ];

    return BlocBuilder<RoomCubit, RoomState>(
      builder: (context, state) {
        Widget bodyContent;

        // LOADING STATE QUAND ON FETCH LES SALLES DE L'ÉTAGE
        if (state.isLoading) {
          bodyContent = const Center(
            child: CircularProgressIndicator(
              backgroundColor: white,
              color: primaryOrange,
            ),
          );
        } // MESSAGE D'ERREUR SI ON A UN PROBLÈME DE CONNEXION
        else if (state.rooms.isEmpty) {
          bodyContent = const Center(child: Text('No rooms available '));
        } // MAP ORGANISM AVEC LE PLAN 2D DE L'ÉTAGE
        else {
          bodyContent = MapOrganism(
              key: ValueKey(state.currentFloor),
              floorImage:
                  floorAssets[state.currentFloor]['floorImage'] as String,
              floorSvg: floorAssets[state.currentFloor]['floorSvg'] as String,
              currentFloor: state.currentFloor,
              initialRoom: state.currentRoom as Room,
              setCurrentFloor: (int floor) =>
                  {context.read<RoomCubit>().selectFloor(floor)},
              floorsCount: floorAssets.length,
              rooms: context
                  .read<RoomCubit>()
                  .getRoomsByFloor(state.currentFloor));
        }

        // SCAFFOLD
        return Scaffold(
          appBar: const HeaderMolecule(title: 'Plan'),
          body: Stack(
            children: [
              // Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit
                        .cover,
                  ),
                ),
              ),
              // Main Content
              Column(
                children: [
                  Expanded(child: bodyContent),
                  FooterMolecule(currentIndex: 0, itemJustFound: itemJustFound),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
