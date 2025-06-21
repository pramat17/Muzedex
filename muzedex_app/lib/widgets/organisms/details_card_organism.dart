import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/molecules/details_description_molecule.dart';
import 'package:muzedex_app/widgets/molecules/details_room_molecule.dart';
import 'package:muzedex_app/widgets/molecules/details_subject_molecule.dart';
import 'package:muzedex_app/widgets/molecules/details_tag_list_molecule.dart';

class DetailsCard extends StatelessWidget {
  final Item item;
  final int itemNumber;
  final String roomName;

  const DetailsCard({
    super.key,
    required this.item,
    required this.itemNumber,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: lightSand,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              DetailsSubjectMolecule(number: itemNumber.toString(), label: item.name),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DetailsTagListMolecule(tags: item.tags),
                      const SizedBox(height: 20),
                      DetailsRoomMolecule(label: roomName),
                      const SizedBox(height: 10),
                      DetailsDescriptionMolecule(
                        description: item.description,
                        isRevealed: item.isRevealed,
                        itemId: item.id,
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
