import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/dialogue_progress_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';
import 'package:muzedex_app/widgets/molecules/dialogue_progress_molecule.dart';
import 'package:muzedex_app/widgets/molecules/home_molecule.dart';

// Page de l'introduction de l'application Muzédex
class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialise le Provider nécessaire à la gestion de la progression de l'introduction
    return BlocProvider(
      create: (_) => DialogueProgressCubit(dialogueType: 'intro'),
      child: const _IntroView(), // Crée la vue de l'introduction
    );
  }
}

// Vue de l'introduction
class _IntroView extends StatelessWidget {
  const _IntroView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DialogueProgressCubit, DialogueProgressState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              // Image de fond
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Contenu de la page d'introduction
              Align(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Column(
                    children: [
                      HomeMolecule(),
                    ],
                  ),
                ),
              ),
              // Gradient Orange du haut
              Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/orangeGradient.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Feuilles du haut
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/leavestop.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Container en bas de la page
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    decoration: const BoxDecoration(
                      color: lightSand,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height / 8),
                              child: SingleChildScrollView(
                                clipBehavior: Clip.antiAlias,
                                child: TextLabel(
                                  text: state.text,
                                  fontFamily: "Belanosima",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: textBrown,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Bouton de retour en arrière
                                // Si l'on n'est pas à la première étape, on affiche le bouton
                                state.index != 0
                                    ? ButtonAtom(
                                        iconSize: 35,
                                        color: Colors.transparent,
                                        iconPath:
                                            'assets/icons/arrow_button_left.svg',
                                        onPressed: () {
                                          context
                                              .read<DialogueProgressCubit>()
                                              .previousIntro();
                                        },
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(width: 16),
                                const DialogueProgressIndicator(),
                                const SizedBox(width: 16),
                                // Bouton d'avancement de l'intro
                                // Si l'on n'est pas à la dernière étape, on affiche le bouton.
                                state.index !=
                                        context
                                            .read<DialogueProgressCubit>()
                                            .getMaxIndex()
                                    ? ButtonAtom(
                                        iconSize: 35,
                                        color: Colors.transparent,
                                        iconPath:
                                            'assets/icons/arrow_button_right.svg',
                                        onPressed: () {
                                          context
                                              .read<DialogueProgressCubit>()
                                              .nextIntro();
                                        },
                                      )
                                    // Sinon, on affiche le bouton pour passer au tutoriel
                                    : ButtonAtom(
                                        text: 'TUTO',
                                        textStyle: const TextStyle(
                                          fontFamily: "Belanosima",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        color: primaryOrange,
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/tuto');
                                        },
                                        border: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(32),
                                          side: const BorderSide(
                                            color: lightBrown,
                                            width: 3,
                                          ),
                                        ),
                                        textPadding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 10,
                            )
                          ],
                        )),
                  )),
              // Gradient Orange du bas
              Positioned(
                bottom: -10,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/orangeGradientBottom.png',
                  fit: BoxFit.contain,
                ),
              ),
              // Feuilles du haut
              Positioned(
                bottom: -30,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/leavesBottomMap.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
