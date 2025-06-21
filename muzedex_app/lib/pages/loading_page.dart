import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:restart_app/restart_app.dart';

class LoadingPage extends StatelessWidget {
  final bool hasConnectivity;

  const LoadingPage({super.key, this.hasConnectivity = true});

  @override
  Widget build(BuildContext context) {
    final roomCubit = context.read<RoomCubit>();

    return Scaffold(
      body: Center(
        child: Stack(
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
            StreamBuilder<double>(
              stream: roomCubit.loadingProgressStream,
              builder: (context, snapshot) {
                final progress = snapshot.data ?? 0.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/ppzarafa.png',
                      fit: BoxFit.contain,
                      height: 150,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Center(
                        child: Text(
                          // Change text if hasConnectivity
                          hasConnectivity
                              ? 'Restez connecté au wifi, chargement des données...'
                              : 'Pas de connexion ! Connectez-vous puis réessayez.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              primaryOrange),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // RETRY BUTTON THAT RELAUNCHES THE APP IF THERE IS NO CONNECTIVITY
                    if (!hasConnectivity) ...[
                      const SizedBox(height: 20),
                      ButtonAtom(
                          color: primaryOrange,
                          text: 'Réessayer',
                          onPressed: () => {
                                Restart.restartApp(
                                  notificationTitle: "Redémarrage",
                                  notificationBody:
                                      "Cliquez ici pour relancer l'application",
                                )
                              })
                    ]
                  ],
                );
              },
            ),
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
      ),
    );
  }
}
