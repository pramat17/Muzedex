import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/riddle_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart' as model;
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/molecules/clue_button_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';
import 'package:muzedex_app/widgets/molecules/riddle_info_molecule.dart';
import 'package:muzedex_app/widgets/organisms/answer_popup_organism.dart';
import 'package:muzedex_app/widgets/organisms/clue_card_organism.dart'
    as widget;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class RiddlePage extends StatelessWidget {
  const RiddlePage({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)?.settings.arguments as model.Item?;

    if (item == null) {
      return const Scaffold(
        body: Center(child: Text('Erreur : Aucun élément fourni.')),
      );
    }

    return BlocProvider(
      create: (_) => RiddleCubit(item: item),
      child: const _RiddleView(),
    );
  }
}

class _RiddleView extends StatefulWidget {
  const _RiddleView();

  @override
  State<_RiddleView> createState() => _RiddleViewState();
}

class _RiddleViewState extends State<_RiddleView> {
  final ItemScrollController _itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RiddleCubit, RiddleState>(
      builder: (context, state) {
        final item = state.item;
        final revealedCluesCount = state.revealedCluesCount;
        final remainingClues = state.remainingClues;
        final cluesToShow = item.clues.take(revealedCluesCount).toList();

        return Scaffold(
          appBar: const HeaderMolecule(
            title: "Muzédex",
            hasBackButton: true,
          ),
          backgroundColor: sand,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (item.clues.isEmpty)
                const Center(child: Text('Aucun indice trouvé.'))
              else
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RiddleInfo(),
                        const SizedBox(height: 16.0),
                        Expanded(
                          // Utilisation de ScrollablePositionedList pour pouvoir scroller jusqu'à l'indice suivant
                          child: ScrollablePositionedList.builder(
                            itemCount: cluesToShow.length,
                            itemScrollController: _itemScrollController,
                            itemBuilder: (context, index) {
                              final clue = cluesToShow[index];
                              return Column(
                                children: [
                                  widget.ClueCard(
                                    clue: clue,
                                    imageLink: item.imageLink,
                                    whoAmI: item.whoAmI,
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 60.0),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/orangeGradientBottom.png',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -40,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/leavesBottomMap.png',
                  fit: BoxFit.cover,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ClueButtonMolecule(
                        remainingCluesCount: remainingClues,
                        onPressed: remainingClues > 0
                            ? () {
                                context.read<RiddleCubit>().revealNextClue();
                                _scrollToNextClue(revealedCluesCount);
                              }
                            : null,
                      ),
                      ButtonAtom(
                        iconPath: 'assets/icons/pencil_icon.svg',
                        text: 'RÉPONDRE',
                        color: darkBrown,
                        onPressed: () => _onAnswerPressed(context, item),
                        isFixed: true,
                      ),
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

  void _onAnswerPressed(BuildContext context, model.Item item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnswerPopupOrganism(item: item);
      },
    );
  }

  void _scrollToNextClue(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 50), () {
        _itemScrollController.scrollTo(
          index: index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });
  }
}
