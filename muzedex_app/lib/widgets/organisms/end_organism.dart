import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/data/pdf_manager.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class EndOrganism extends StatefulWidget {
  const EndOrganism({super.key});

  @override
  EndScreenContentState createState() => EndScreenContentState();
}

class EndScreenContentState extends State<EndOrganism> {
  late ConfettiController _controller;
  final PdfManager pdfManager = PdfManager();
  final FileManager fileManager = FileManager();

  @override
  void initState() {
    super.initState();
    pdfManager.modifyDiploma();
    _controller = ConfettiController(duration: const Duration(seconds: 7));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? playerName = context.read<RoomCubit>().state.playerName;
    return Stack(
      children: [
        // Image en haut de la page (orangeGradient.png)
        Positioned(
          top: -50,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/orangeGradient.png',
            fit: BoxFit.fitWidth,
            height: 200.0,
          ),
        ),
        // Image en haut de la page (leavestop.png)
        Positioned(
          top: -40,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/leavestop.png',
            fit: BoxFit.fitWidth,
            height: 200.0,
          ),
        ),
        // Contenu principal centré horizontalement
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                const SizedBox(height: 25),
                const TextLabel(
                  text: 'Félicitations !',
                  fontFamily: 'Belanosima',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: textBrown,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Zone de texte avec un fond blanc et un border radius
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextLabel(
                              text:
                                  'Tu as trouvé toutes les cartes de la collection ! Bravo $playerName !'
                                  'Tu peux les retrouver dans le Muzédex ! Et tu fais maintenant partie de ma super équipe d\'aventuriers !'
                                  '\n\nTu peux télécharger ton diplôme d\'aventurier depuis la page Muzédex.',
                              textAlign: TextAlign.center,
                              fontFamily: 'InterVariable',
                              color: textBrown,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ButtonAtom(
                  text: 'Retour au Muzédex',
                  color: primaryOrange,
                  textColor: white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/muzedex');
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
        // Image en bas à droite de la page (zarafa.png)
        Positioned(
          bottom: 30,
          right: 0,
          child: Image.asset(
            'assets/images/zarafa.png',
            height: MediaQuery.of(context).size.height * 0.35,
          ),
        ),
        // Image en bas de la page (orangeGradientBottom.png)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/orangeGradientBottom.png',
            fit: BoxFit.fitWidth,
            height: 200.0,
          ),
        ),
        // Image en bas de la page (leavesBottomMap.png)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/leavesBottomMap.png',
            fit: BoxFit.fitWidth,
          ),
        ),
        // Confettis alignés au centre de l'écran
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 100,
            ),
          ),
        ),
      ],
    );
  }
}
