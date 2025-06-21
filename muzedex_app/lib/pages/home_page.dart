import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/molecules/home_molecule.dart';
import 'package:muzedex_app/widgets/organisms/home_content_organism.dart';

// Page d'accueil de l'application Muzédex
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              height: MediaQuery.of(context).size.height / 1.5,
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
                  child: HomeContentOrganism(),
                ),
              )),
          // Gradient Orange du bas
          Positioned(
            bottom: -20,
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
