import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/data/pdf_manager.dart';
import 'package:muzedex_app/utils/colors.dart';

class DiplomaOrganism extends StatelessWidget {
  final PdfManager pdfManager;
  const DiplomaOrganism({super.key, required this.pdfManager});

  @override
  Widget build(BuildContext context) {
    String? playerName = context.read<RoomCubit>().state.playerName;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 10),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: lightSand,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Tu as réussi à trouver tous les objets, félicitation $playerName !\n"
                        "Tu peux maintenant télécharger ton diplôme d'aventurier !",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: textBrown,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Image.asset(
                      'assets/images/ppzarafa.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: FutureBuilder<String>(
                future: pdfManager.getDiplomaPath(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      height: 200,
                      width: 500,
                      child: PDFView(
                        filePath: snapshot.data,
                      ),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await pdfManager.downloadDiploma();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryOrange,
                side: const BorderSide(
                  color: lightBrown,
                  width: 3.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Télécharger",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/orangeGradientBottom.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -60,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/leavesBottomMap.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
