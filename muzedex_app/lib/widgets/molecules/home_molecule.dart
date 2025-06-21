import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class HomeMolecule extends StatelessWidget {
  const HomeMolecule({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(24.0),
            // Panneau Muzédex avec fond en bois
            child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/woodtexture.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: darkBrown,
                    width: 4,
                  ),
                ),
                child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0),
                    child: TextLabel(
                      text: 'Muzédex',
                      fontFamily: "Belanosima",
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: white,
                    )))),
        // Images de la page d'accueil
        Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cartes du Muzédex
                  Flexible(
                    child: Image.asset(
                      'assets/images/itemCards.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Image de Zarafa
                  Flexible(
                    child: Image.asset(
                      'assets/images/zarafa.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
