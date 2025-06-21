import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';
import 'package:muzedex_app/widgets/organisms/muzedex_organism.dart';

class MuzedexPage extends StatelessWidget {
  const MuzedexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomState>(
      builder: (context, state) {
        Widget bodyContent;

        // Cas où le state est en chargement
        if (state.isLoading) {
          bodyContent = const Center(
            child: CircularProgressIndicator(
              backgroundColor: white,
              color: primaryBlue,
            ),
          );
        } // Cas où on n'arrive pas à récupérer les salles
        else if (state.rooms.isEmpty) {
          bodyContent = const Center(child: Text('No items available'));
        } // On récupère les items et on appelle l'organisme du Muzedex
        else {
          List<Item> items = [];
          for (var room in state.rooms) {
            items.addAll(room.items);
          }
          bodyContent = MuzedexOrganism(
            items: items,
          );
        }

        return Scaffold(
          appBar: const HeaderMolecule(title: 'Muzédex'),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: bodyContent,
          ),
          bottomNavigationBar: const FooterMolecule(currentIndex: 1),
        );
      },
    );
  }
}
