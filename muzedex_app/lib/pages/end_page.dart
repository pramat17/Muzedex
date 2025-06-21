import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/organisms/end_organism.dart';

class EndPage extends StatelessWidget {
  const EndPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue, // Set the background color to primaryBlue
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover, // Ajuste l'image pour couvrir tout l'écran
          ),
        ),
        child: const Center(
          child: EndOrganism(),
        ),
      ),
    );
  }
}
