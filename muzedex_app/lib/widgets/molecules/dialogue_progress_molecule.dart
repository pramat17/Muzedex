import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/dialogue_progress_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';

class DialogueProgressIndicator extends StatelessWidget {
  const DialogueProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueProgressCubit, DialogueProgressState>(
      builder: (context, state) {
        final selectedDialogue = context.read<DialogueProgressCubit>().selectedDialogue;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            selectedDialogue.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getPointColor(index, state.index),
              ),
            ),
          ),
        );
      },
    );
  }

  //Méthode pour définir la couleur d'un point pour indiquer la progression
  Color _getPointColor(int index, int currentIndex) {
    if (index == currentIndex) {
      return darkBrown;
    } else if (index < currentIndex) {
      return lightBrown;
    } else {
      return primaryOrange;
    }
  }
}
