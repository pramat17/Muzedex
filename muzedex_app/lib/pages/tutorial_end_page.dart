import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class TutorialEndPage extends StatelessWidget {
  const TutorialEndPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Contenu de la page d'accueil
          Align(
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 7), // Décale vers le bas de 50 pixels
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/itemCards.png',
                          fit: BoxFit.contain,
                          height: 120,
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          'assets/images/zarafa.png',
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                      ],
                    ),
                  )
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
                height: MediaQuery.of(context).size.height / 1.8,
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
                        const TextLabel(
                          text:
                              "Je t'ai appris tout ce dont tu as besoin pour passer mon épreuve et rejoindre mon équipe.\n\nMaintenant, à toi de jouer !",
                          fontFamily: "Belanosima",
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: textBrown,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonAtom(
                              iconPath: 'assets/icons/arrow_button_left.svg',
                              iconSize: 35,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.transparent,
                            ),
                            ButtonAtom(
                              text: 'JOUER',
                              textStyle: const TextStyle(
                                fontFamily: "Belanosima",
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              color: primaryOrange,
                              onPressed: () {
                                Navigator.pushNamed(context, '/plan');
                              },
                              border: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                                side: const BorderSide(
                                  color: lightBrown,
                                  width: 3,
                                ),
                              ),
                              textPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            )
                          ],
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
  }
}
