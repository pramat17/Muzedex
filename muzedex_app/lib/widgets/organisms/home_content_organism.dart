import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class HomeContentOrganism extends StatelessWidget {
  HomeContentOrganism({super.key});

  final FileManager fileManager = FileManager();
  final TextEditingController _nameInputController = TextEditingController();

  // Fonction asynchrone choisissant la page vers laquelle rediriger l'utilisateur
  Future<String> getRedirectionUrl() async {
    // L'utilisateur utilise l'application web
    if (kIsWeb) {
      return "/intro";
    } else {
      // L'utilisateur utilise l'application mobile et à déjà commencé une partie
      if (await fileManager.hasAlreadyPlayed()) {
        return "/plan";
      } else {
        // L'utilisateur utilise l'application mobile et n'a pas lancé de partie
        fileManager.setHasAlreadyPlayed(true);
        return "/intro";
      }
    }
  }

  Future<bool> alreadyHasName() async {
    return await fileManager.hasPlayerName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: alreadyHasName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        }

        bool hasName = snapshot.data ?? false;

        return Column(
          children: [
            const SingleChildScrollView(
                child: TextLabel(
              text:
                  "Bonjour, bienvenue au Museum d'Histoires Naturelles de La Rochelle, jeune aventurier !",
              fontFamily: "Belanosima",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: textBrown,
              textAlign: TextAlign.center,
            )),
            const SizedBox(height: 32),
            if (!hasName) ...[
              TextField(
                controller: _nameInputController,
                decoration: const InputDecoration(
                  labelText: 'Entres ton nom',
                  border: OutlineInputBorder(),
                  focusColor: textBrown,
                  hoverColor: textBrown,
                ),
                cursorColor: textBrown,
              ),
              const SizedBox(height: 8),
            ],
            ValueListenableBuilder(
                valueListenable: _nameInputController,
                builder: (context, value, child) {
                  bool isButtonEnabled =
                      hasName || value.text.trim().isNotEmpty;
                  return ButtonAtom(
                    text: 'JOUER',
                    textStyle: const TextStyle(
                      fontFamily: "Belanosima",
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    color:
                        isButtonEnabled ? primaryOrange : itemButtonBackground,
                    onPressed: isButtonEnabled
                        ? () async {
                            if (_nameInputController.text.trim().isNotEmpty) {
                              await fileManager.setPlayerName(
                                  _nameInputController.text.trim());
                            }

                            await fileManager.setStartTimestamp();
                            getRedirectionUrl().then((url) {
                              if (context.mounted) {
                                Navigator.pushNamed(context, url);
                              }
                            });
                          }
                        : null,
                    border: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: BorderSide(
                        color:
                            isButtonEnabled ? lightBrown : itemButtonForeground,
                        width: 3,
                      ),
                    ),
                    textPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  );
                })
          ],
        );
      },
    );
  }
}
