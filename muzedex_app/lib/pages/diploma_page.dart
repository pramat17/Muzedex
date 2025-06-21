import 'package:flutter/material.dart';
import 'package:muzedex_app/logics/data/pdf_manager.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';
import 'package:muzedex_app/widgets/organisms/diploma_organism.dart';

class DiplomaPage extends StatelessWidget {
  DiplomaPage({super.key});

  final PdfManager pdfManager = PdfManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderMolecule(
        title: "Diplôme d'aventurier",
        hasBackButton: true,
      ),
      body: DiplomaOrganism(pdfManager: pdfManager),
      bottomNavigationBar: const FooterMolecule(currentIndex: 1),
    );
  }
}
