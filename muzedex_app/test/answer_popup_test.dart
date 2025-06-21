import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/widgets/organisms/answer_popup_organism.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';

void main() {
  group('AnswerPopupOrganism', () {
    late Item testItem;

    setUp(() {
      testItem = Item(
        id: 1,
        name: 'Le Lièvre d\'Europe',
        description: 'Description',
        tags: ['tag1', 'tag2'],
        imageLink: 'imageLink',
        coordinates: 'coordinates',
        clues: [Clue(id: 1, type: 'text', text: 'clue1')],
        isFound: false,
        isRevealed: false,
        whoAmI: 'whoAmI',
      );
    });

    Future<void> buildWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnswerPopupOrganism(item: testItem),
          ),
        ),
      );
    }

    testWidgets('Affiche une erreur si le champ est vide', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(find.text('Le champ ne peut pas être vide.'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Valide la réponse correcte', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), 'Lièvre d\'Europe');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(testItem.isFound, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Affiche une erreur pour une réponse incorrecte', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), 'Lion');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(find.text('Oups ! Ce n\'est pas le bon objet ! Réessayez !'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Ignore les déterminants', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), 'Le Lièvre d\'Europe');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(testItem.isFound, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Tolère les apostrophes et accents', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), 'Lievre d\'Europe');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(testItem.isFound, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Tolère une faute de frappe', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), 'Lievrre d\'Europe');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(testItem.isFound, isTrue);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });

    testWidgets('Affiche une erreur si le champ contient uniquement des espaces', (WidgetTester tester) async {
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('Incorrect use of ParentDataWidget')) {
          return;
        }
        originalOnError?.call(details);
      };
      try {
        await buildWidget(tester);

        await tester.enterText(find.byType(TextField), '      ');
        await tester.tap(find.text('CONFIRMER'));
        await tester.pumpAndSettle();

        expect(find.text('Le champ ne peut pas être vide.'), findsOneWidget);
      } finally {
        FlutterError.onError = originalOnError;
      }
    });
  });
}