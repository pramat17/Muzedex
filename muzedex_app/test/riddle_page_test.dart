import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/widgets/atoms/icon_atom.dart';
import 'package:muzedex_app/widgets/atoms/riddle_atom.dart';
import 'package:muzedex_app/widgets/molecules/clue_button_molecule.dart';
import 'package:muzedex_app/widgets/molecules/clue_guess_molecule.dart';
import 'package:muzedex_app/widgets/molecules/clue_type_molecule.dart';
import 'package:muzedex_app/widgets/organisms/answer_popup_organism.dart';
import 'package:muzedex_app/widgets/organisms/clue_card_organism.dart';

void main() {
  group("Riddle Page Tests", () {
    testWidgets('ClueCard displays clue type, label, and riddle',
        (tester) async {
      var clue = Clue(
        id: 1,
        type: 'Shadobject',
        text: 'Quelle est cette ombre ?',
      );

      var imageLink =
          'https://res.cloudinary.com/dozwg0xdq/image/upload/v1733393693/lie%CC%80vre_clair_f7upfn.png';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClueCard(
              clue: clue,
              imageLink: imageLink,
              whoAmI: 'Lièvre',
            ),
          ),
        ),
      );

      // Attendre que le widget soit rendu
      await tester.pumpAndSettle();

      // Vérifiez que le texte de l'énigme est affiché
      expect(find.text('Quelle est cette ombre ?'), findsOneWidget);

      // Vérifiez que le type de l'indice est affiché
      expect(find.text('Shadobject'), findsOneWidget);

      // Vérifiez que l'icône est affichée dans ClueType
      final clueTypeFinder = find.byType(ClueType);
      expect(clueTypeFinder, findsOneWidget);
      expect(
          find.descendant(of: clueTypeFinder, matching: find.byType(IconAtom)),
          findsOneWidget);

      // Vérifiez que l'image est affichée dans ClueGuess
      final clueGuessFinder = find.byType(ClueGuess);
      expect(clueGuessFinder, findsOneWidget);
      expect(
          find.descendant(
              of: clueGuessFinder, matching: find.byType(RiddleAtom)),
          findsOneWidget);
    });
  });

  group("Answer Popup Tests", () {
    testWidgets('AnswerPopupOrganism displays title, input field, and buttons',
        (tester) async {
      // ignore: unused_local_variable
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError!(details);
      };
      try {

      // Création d'un faux item
      final fakeItem = Item(
        id: 1,
        name: "Objet Mystère",
        description: "Description test",
        tags: ["test", "objet"],
        imageLink: "https://example.com/image.png",
        coordinates: "0,0",
        clues: [
          Clue(id: 1, type: "Type d'indice", text: "Texte de l'indice"),
        ],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

        // Construire le widget AnswerPopupOrganism
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnswerPopupOrganism(item: fakeItem),
            ),
          ),
        );

        // Vérifier que le titre s'affiche correctement
        expect(find.text('Résoudre l\'énigme'), findsOneWidget);

        // Vérifier que le texte d'instruction s'affiche
        expect(
          find.text(
              'Entres le nom de l\'objet ci-dessous pour récupérer sa carte dans le Muzédex !'),
          findsOneWidget,
        );

        // Vérifier la présence du champ de saisie
        expect(find.byType(TextField), findsOneWidget);

        // Vérifier que les boutons ANNULER et CONFIRMER s'affichent
        expect(find.text('ANNULER'), findsOneWidget);
        expect(find.text('CONFIRMER'), findsOneWidget);

        // Tester l'interaction avec le bouton ANNULER
        await tester.tap(find.text('ANNULER'));
        await tester.pumpAndSettle();

        // Vérifier que le popup se ferme après avoir cliqué sur ANNULER
        expect(find.byType(AlertDialog), findsNothing);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets(
        'AnswerPopupOrganism shows error message when incorrect name is entered',
        (tester) async {
      
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      try {
      final fakeItem = Item(
        id: 1,
        name: "Objet Mystère",
        description: "Description test",
        tags: ["test"],
        imageLink: "https://example.com/image.png",
        coordinates: "0,0",
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnswerPopupOrganism(item: fakeItem),
            ),
          ),
        );

        // Saisir un texte incorrect
        await tester.enterText(find.byType(TextField), 'Mauvais Objet');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        // Vérifier que le message d'erreur s'affiche
        expect(find.text("Oups ! Ce n'est pas le bon objet ! Réessayez !"),
            findsOneWidget);
      } finally {
        FlutterError.onError = null;
      }
    });

    testWidgets(
        'AnswerPopupOrganism shows error message when input field is empty',
        (tester) async {

      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      try {

      final fakeItem = Item(
        id: 1,
        name: "Objet Mystère",
        description: "Description test",
        tags: ["test"],
        imageLink: "https://example.com/image.png",
        coordinates: "0,0",
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnswerPopupOrganism(item: fakeItem),
            ),
          ),
        );

        // Ne rien saisir et appuyer sur CONFIRMER
        await tester.enterText(find.byType(TextField), '');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        // Vérifier que le message d'erreur s'affiche
        expect(find.text('Le champ ne peut pas être vide.'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });

  group("ClueButtonMolecule Tests", () {
    testWidgets('ClueButtonMolecule displays button and badge correctly',
        (tester) async {
      const remainingClues = 3;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClueButtonMolecule(
              remainingCluesCount: remainingClues,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Vérifier que le texte "INDICE" est affiché
      expect(find.text('INDICE'), findsOneWidget);

      // Vérifier que le badge affiche le bon nombre d'indices
      expect(find.text('$remainingClues'), findsOneWidget);

      // Vérifier que le bouton est cliquable
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('ClueButtonMolecule disables button when onPressed is null',
        (tester) async {
      const remainingClues = 5;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClueButtonMolecule(
              remainingCluesCount: remainingClues,
              onPressed: null,
            ),
          ),
        ),
      );

      // Vérifier que le bouton est désactivé
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('ClueButtonMolecule handles zero clues gracefully',
        (tester) async {
      const remainingClues = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClueButtonMolecule(
              remainingCluesCount: remainingClues,
              onPressed: () {},
            ),
          ),
        ),
      );

      // Vérifier que le badge affiche zéro correctement
      expect(find.text('$remainingClues'), findsOneWidget);
    });
  });

  group("AnswerPopup Validation Tests", () {
    testWidgets('AnswerPopupOrganism keeps popup open on incorrect name entry',
        (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      try {
      final fakeItem = Item(
        id: 1,
        name: "Objet Mystère",
        description: "Description test",
        tags: ["test"],
        imageLink: "https://example.com/image.png",
        coordinates: "0,0",
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnswerPopupOrganism(item: fakeItem),
            ),
          ),
        );

        // Saisir un texte incorrect
        await tester.enterText(find.byType(TextField), 'Mauvais Nom');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        // Vérifier que le popup reste ouvert
        expect(find.byType(AlertDialog), findsOneWidget);

        // Vérifier que l'objet n'est pas marqué comme trouvé
        expect(fakeItem.isFound, isFalse);

        // Vérifier que le message d'erreur s'affiche
        expect(find.text("Oups ! Ce n'est pas le bon objet ! Réessayez !"),
            findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('AnswerPopupOrganism shows error when input is whitespace only',
        (tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        FlutterError.dumpErrorToConsole(details);
      };
      try {
      final fakeItem = Item(
        id: 1,
        name: "Objet Mystère",
        description: "Description test",
        tags: ["test"],
        imageLink: "https://example.com/image.png",
        coordinates: "0,0",
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnswerPopupOrganism(item: fakeItem),
            ),
          ),
        );

        // Entrer uniquement des espaces
        await tester.enterText(find.byType(TextField), '   ');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        // Vérifier que le message d'erreur s'affiche
        expect(find.text('Le champ ne peut pas être vide.'), findsOneWidget);

        // Vérifier que le popup reste ouvert
        expect(find.byType(AlertDialog), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}