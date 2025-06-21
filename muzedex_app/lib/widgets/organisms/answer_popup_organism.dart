import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/button_atom.dart';

class AnswerPopupOrganism extends StatefulWidget {
  final Item item;

  const AnswerPopupOrganism({super.key, required this.item});

  @override
  State<AnswerPopupOrganism> createState() => _AnswerPopupOrganismState();
}

class _AnswerPopupOrganismState extends State<AnswerPopupOrganism> {
  final TextEditingController _textController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  isGameFinished() {
    final state = context.read<RoomCubit>().state;
    List<Item> items = [];
    for (var room in state.rooms) {
      items.addAll(room.items);
    }
    int totalItems = items.length;
    int discoveredItems = items.where((item) => item.isFound).length;
    int itemsLeft = totalItems - discoveredItems;

    if (itemsLeft == 0) {
      context.read<RoomCubit>().finishGame();
      return true;
    }
    return false;
  }

  Future<void> _onConfirmPressed(BuildContext context) async {
    final inputName = _normalizeInput(_textController.text.trim());
    final correctName = _normalizeInput(widget.item.name);
    if (inputName.isEmpty) {
      setState(() => _errorMessage = 'Le champ ne peut pas être vide.');
      return;
    }

    if (_isValidName(inputName, correctName)) {
      setState(() {
        widget.item.isFound = true;
      });

      if (!kIsWeb) {
        await FileManager().updateItemIsFound(widget.item.id);
      }

      if (context.mounted) {
        if (isGameFinished()) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/end',
            (route) => false,
          );
        } else {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/plan',
            (route) => false,
            arguments: {'itemJustFound': widget.item},
          );
        }
      }
    } else {
      setState(() {
        _errorMessage = 'Oups ! Ce n\'est pas le bon objet ! Réessayez !';
      });
    }
  }

  /// Normalise l'entrée pour simplifier la comparaison
  String _normalizeInput(String input) {
    // Supprime les accents et transforme en minuscules
    String normalized = removeDiacritics(input.toLowerCase());

    // Supprime les caractères non alphabétiques en début/fin
    normalized = normalized.replaceAll(RegExp(r'^[^a-z0-9]+|[^a-z0-9]+$'), '');

    // Supprime les espaces multiples et remplace les apostrophes manquantes
    normalized =
        normalized.replaceAll(RegExp(r"\s+"), " ").replaceAll("’", "'");

    return normalized;
  }

  // Liste des déterminants autorisés
  final List<String> _determinants = [
    'le',
    'la',
    'les',
    'un',
    'une',
    'des',
    'du',
    'de',
    'l'
  ];

  // Supprime les déterminants du début du nom
  String _removeDeterminants(String input) {
    for (final det in _determinants) {
      if (input.startsWith('$det ')) {
        return input.substring(det.length).trim();
      }
    }
    return input;
  }

  /// Vérifie si le nom est valide
  bool _isValidName(String inputName, String correctName) {
    inputName = _removeDeterminants(inputName);
    correctName = _removeDeterminants(correctName);

    // Tolérance stricte
    if (inputName == correctName) {
      return true;
    }

    // Ignore les apostrophes
    if (inputName.replaceAll("'", "") == correctName.replaceAll("'", "")) {
      return true;
    }

    // Distance d'édition pour tolérer une faute
    if (_levenshteinDistance(inputName, correctName) <= 1) {
      return true;
    }

    return false;
  }

  /// Calcule la distance de Levenshtein (faute de frappe)
  int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;
    final dp = List.generate(len1 + 1, (_) => List.filled(len2 + 1, 0));

    for (int i = 0; i <= len1; i++) {
      for (int j = 0; j <= len2; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 +
              [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]]
                  .reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[len1][len2];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: lightSand,
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résoudre l\'énigme',
            style: TextStyle(
              fontFamily: "Belanosima",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: textBrown,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/enigmezarafa.png',
                height: 50,
              ),
              const SizedBox(height: 16),
              const Text(
                'Entres le nom de l\'objet ci-dessous pour récupérer sa carte dans le Muzédex !',
                style: TextStyle(
                  fontSize: 14,
                  color: textBrown,
                ),
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'objet',
                  border: OutlineInputBorder(),
                  focusColor: textBrown,
                  hoverColor: textBrown,
                ),
                cursorColor: textBrown,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      actions: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.center,
          children: [
            ButtonAtom(
              text: 'ANNULER',
              textColor: white,
              color: lightBrown,
              onPressed: () => Navigator.of(context).pop(),
              isFixed: false,
            ),
            ButtonAtom(
              iconPath: 'assets/icons/check-mark.svg',
              text: 'CONFIRMER',
              textColor: white,
              color: primaryOrange,
              onPressed: () => _onConfirmPressed(context),
              isFixed: false,
            ),
          ],
        ),
      ],
    );
  }
}
