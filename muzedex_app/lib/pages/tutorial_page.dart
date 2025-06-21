import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzedex_app/logics/cubits/dialogue_progress_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';
import 'package:muzedex_app/widgets/molecules/dialogue_progress_molecule.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';

class TutorialPage extends StatelessWidget {
  final bool isFirstTime;

  const TutorialPage({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DialogueProgressCubit(dialogueType: 'tuto'),
      child: _TutorialView(isFirstTime: isFirstTime),
    );
  }
}

class _TutorialView extends StatelessWidget {
  final bool isFirstTime;

  const _TutorialView({required this.isFirstTime});

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
              // Contenu de la page du tutoriel
              Align(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextLabel(
                        text: state.title as String,
                        fontFamily: "Belanosima",
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: textBrown,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Image.asset(
                        state.imageUrl as String,
                        fit: BoxFit.contain,
                        height: MediaQuery.of(context).size.height / 2.5,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.index != 0
                              ? ButtonAtom(
                                  iconSize: 35,
                                  color: Colors.transparent,
                                  iconPath: 'assets/icons/arrow_button_left.svg',
                                  onPressed: () {
                                    context
                                        .read<DialogueProgressCubit>()
                                        .previousTutorial();
                                  },
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(width: 16),
                          const DialogueProgressIndicator(),
                          const SizedBox(width: 16),
                          state.index !=
                                  context
                                      .read<DialogueProgressCubit>()
                                      .getMaxIndex()
                              ? ButtonAtom(
                                  iconSize: 35,
                                  color: Colors.transparent,
                                  iconPath: 'assets/icons/arrow_button_right.svg',
                                  onPressed: () {
                                    context
                                        .read<DialogueProgressCubit>()
                                        .nextTutorial();
                                  },
                                )
                              : ButtonAtom(
                                  iconSize: 35,
                                  color: Colors.transparent,
                                  iconPath: 'assets/icons/arrow_button_right.svg',
                                  onPressed: () {
                                    isFirstTime? Navigator.pushNamed(context, '/tutoEnd') : Navigator.pushNamed(context, '/plan');
                                  },
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ), // Espacement minimal entre l'image et les boutons
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
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: const BoxDecoration(
                    color: lightSand,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 8,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height / 7,
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                // Define text style
                                const textStyle = TextStyle(
                                  fontFamily: "Belanosima",
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: textBrown,
                                );
                                // Create a TextSpan to measure text size
                                final textSpan = TextSpan(
                                  text: state.text,
                                  style: textStyle,
                                );
                                final textPainter = TextPainter(
                                  text: textSpan,
                                  textDirection: TextDirection.ltr,
                                  maxLines: null,
                                );
                                textPainter.layout(maxWidth: constraints.maxWidth);
                                final bool overflows =
                                    textPainter.height > constraints.maxHeight;

                                return Stack(
                                  children: [
                                    SingleChildScrollView(
                                      clipBehavior: Clip.antiAlias,
                                      child: TextLabel(
                                        text: state.text,
                                        fontFamily: "Belanosima",
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: textBrown,
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    if (overflows)
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: SvgPicture.asset(
                                          'assets/images/textgradient.svg',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            'assets/images/ppzarafa.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
              // Feuilles du bas
              isFirstTime
                ? Positioned(
                    bottom: -30,
                    left: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/leavesBottomMap.png',
                      fit: BoxFit.contain,
                    ),
                  )
                :
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: FooterMolecule(currentIndex: 2),
                  ),
            ],
          ),
        );
      },
    );
  }
}