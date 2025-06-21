import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/riddle_atom.dart';
import 'package:muzedex_app/widgets/molecules/item_card_molecule.dart';
import 'package:muzedex_app/widgets/molecules/progress_bar_molecule.dart';
import 'package:muzedex_app/widgets/molecules/toast_message_molecule.dart';
import 'package:muzedex_app/widgets/organisms/muzedex_organism.dart';
import 'package:muzedex_app/widgets/organisms/notfounditem_popup_organism.dart';

import 'mocks.dart';

class MockRoomCubit extends Mock implements RoomCubit {}

class FakeRoomState extends Fake implements RoomState {}

void main() {
  // GROUP : Groupe de test qui contient les tests du widget MuzedexOrganism
  group('Muzedex Organism Tests', () {
    // TEST : Affiche le bon message quand tous les objets ont été trouvés
    testWidgets('Affiche le message lorsque tous les objets sont trouvés',
        (tester) async {
      final items = [
        Item(
          id: 1,
          name: 'Python',
          description:
              'Un grand serpent souvent trouvé dans les régions tropicales.',
          tags: ['animal', 'serpent'],
          imageLink: 'assets/images/python.png',
          coordinates: '54:54',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
        Item(
          id: 2,
          name: 'Lièvre',
          description: 'Un petit mammifère rapide et agile.',
          tags: ['animal', 'mammifère'],
          imageLink: 'assets/images/lievre.png',
          coordinates: '93:23',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
      ];

      final mockCubit = MockRoomCubit();
      when(() => mockCubit.state).thenReturn(const RoomState(
          currentFloor: 0,
          rooms: [],
          isLoading: false,
          gameFinished: false,
          playerName: "testeur"));
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(
          const RoomState(
              currentFloor: 0,
              rooms: [],
              isLoading: false,
              gameFinished: false,
              playerName: "testeur")));

      await tester.pumpWidget(
        BlocProvider<RoomCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: Scaffold(
              body: MuzedexOrganism(items: items),
            ),
          ),
        ),
      );

      // Avec la nouvelle logique, le message devrait être personnalisé et contenir la salle et le mot "bravo"
      expect(find.text('testeur ! Tu as trouvé tous les objets !'),
          findsOneWidget);
    });

    // TEST : Affiche le bon message quand il reste des objets à trouver avec le bon nombre de d'objets restants
    testWidgets('Affiche le nombre d\'objets restants à trouver',
        (WidgetTester tester) async {
      final items = [
        Item(
          id: 1,
          name: 'Python',
          description:
              'Un grand serpent souvent trouvé dans les régions tropicales.',
          tags: ['animal', 'serpent'],
          imageLink: 'assets/images/python.png',
          coordinates: '54:54',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
        Item(
          id: 2,
          name: 'Lièvre',
          description: 'Un petit mammifère rapide et agile.',
          tags: ['animal', 'mammifère'],
          imageLink: 'assets/images/lievre.png',
          coordinates: '93:23',
          clues: [],
          isFound: false,
          isRevealed: false,
          whoAmI: "",
        ),
        Item(
          id: 3,
          name: 'Hyène',
          description: 'Habitant de la savane',
          tags: ['animal', 'savane'],
          imageLink: 'assets/images/hyene.png',
          coordinates: '65:87',
          clues: [],
          isFound: false,
          isRevealed: false,
          whoAmI: "",
        ),
      ];

      // Ici, on crée un RoomCubit avec un état personnalisé
      final mockCubit = MockRoomCubit();
      when(() => mockCubit.state).thenReturn(const RoomState(
          currentFloor: 0,
          rooms: [],
          isLoading: false,
          gameFinished: false,
          playerName: "testeur"));
      when(() => mockCubit.stream).thenAnswer((_) => Stream.value(
          const RoomState(
              currentFloor: 0,
              rooms: [],
              isLoading: false,
              gameFinished: false,
              playerName: "testeur")));

      await tester.pumpWidget(
        BlocProvider<RoomCubit>.value(
          value: mockCubit,
          child: MaterialApp(
            home: Scaffold(
              body: MuzedexOrganism(items: items),
            ),
          ),
        ),
      );

      expect(
          find.text(
              'testeur, il te reste 2 objets à découvrir pour compléter ton Muzédex !'),
          findsOneWidget);
    });

    // TEST : Affiche une GridView qui contient le bon nombre d'éléments
    testWidgets('Affiche GridView avec le bon nombre d\'items', (tester) async {
      final items = List.generate(
        6,
        (index) => Item(
          id: index,
          name: 'Nom',
          description: 'Desc',
          tags: ['tag1', 'tag2'],
          imageLink: 'assets/images/name.png',
          coordinates: '23:42',
          clues: [],
          isFound: false,
          isRevealed: false,
          whoAmI: "",
        ),
      );

      final roomService = MockRoomService();
      await tester.pumpWidget(
        BlocProvider(
          create: (context) => RoomCubit(roomService),
          child: MaterialApp(
            home: Scaffold(
              body: MuzedexOrganism(items: items),
            ),
          ),
        ),
      );

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(ItemCard), findsNWidgets(6));
    });

    // TEST : Toast message s'affiche correctement
    testWidgets('Affiche correctement le toast message personnalisé',
        (tester) async {
      const testTitle = 'Titre de test';
      const testMessage = 'Message de test';

      // Construire le widget de test
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      ToastMessageMolecule.create(
                        title: testTitle,
                        message: testMessage,
                      ),
                    );
                  },
                  child: const Text('Afficher le toast'),
                );
              },
            ),
          ),
        ),
      );
      expect(find.text('Afficher le toast'), findsOneWidget);

      // Appuyer sur le bouton pour afficher le toast message
      await tester.tap(find.text('Afficher le toast'));
      await tester.pump(const Duration(seconds: 1));

      // Vérifications sur le toast message
      expect(find.text(testTitle), findsOneWidget);
      expect(find.text(testMessage), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(
        tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
        lightSand,
      );
    });
  });

  // GROUP : Groupe de test qui contient les tests du widget ItemCard
  group('ItemCard Tests', () {
    // TEST : Affiche correctement un objet trouvé
    testWidgets('Affiche correctement un item trouvé', (tester) async {
      final item = Item(
        id: 1,
        name: 'Python',
        description:
            'Un grand serpent souvent trouvé dans les régions tropicales.',
        tags: ['animal', 'serpent'],
        imageLink: 'assets/images/python.png',
        coordinates: '54:54',
        clues: [],
        isFound: true,
        isRevealed: true,
        whoAmI: "",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemCard(item: item, index: 11),
          ),
        ),
      );

      expect(find.text('Python'), findsOneWidget);
      expect(find.byType(RiddleAtom), findsOneWidget);
    });

    // TEST : Affiche correctement un objet non trouvé
    testWidgets('Affiche "???" pour un item non trouvé', (tester) async {
      final item = Item(
        id: 1,
        name: 'Python',
        description:
            'Un grand serpent souvent trouvé dans les régions tropicales.',
        tags: ['animal', 'serpent'],
        imageLink: 'assets/images/python.png',
        coordinates: '54:54',
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemCard(item: item, index: 2),
          ),
        ),
      );

      expect(find.text('???'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    // TEST : Popup d'un item card non trouvée
    testWidgets('Popup d\'un item card non trouvée', (tester) async {
      final item = Item(
        id: 1,
        name: 'Python',
        description:
            'Un grand serpent souvent trouvé dans les régions tropicales.',
        tags: ['animal', 'serpent'],
        imageLink: 'assets/images/python.png',
        coordinates: '54:54',
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

      final room = Room(
          id: 1, name: "Salle test", number: 1, floor: 1, position: "10;20");

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NotFoundItemPopupOrganism(item: item, room: room),
          ),
        ),
      );

      expect(find.text('Carte non trouvée'), findsOneWidget);

      final richTextMatcher = find.byWidgetPredicate((widget) {
        if (widget is RichText) {
          final textSpan = widget.text as TextSpan;
          return textSpan.toPlainText().contains("salle 1 : Salle test") &&
              textSpan.toPlainText().contains("l'étage 1");
        }
        return false;
      });

      expect(richTextMatcher, findsOneWidget);

      expect(find.byType(Image), findsOneWidget);

      expect(find.text('RETOUR'), findsOneWidget);
    });
  });

  // GROUP : Groupe de test qui contient les tests du widget ProgressBarMolecule
  group('Muzedex Progress Bar Tests', () {
    // TEST : Affiche correctement la progression
    testWidgets('Affiche correctement la barre de progression', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBarMolecule(totalItems: 10, discoveredItems: 4),
          ),
        ),
      );

      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // Vérification de la bonne progression de la barre de progression
      final linearProgressFinder = find.byType(LinearProgressIndicator);
      expect(linearProgressFinder, findsOneWidget);
      final LinearProgressIndicator progressBar =
          tester.widget<LinearProgressIndicator>(linearProgressFinder);
      expect(progressBar.value, 0.4);

      expect(find.text('4/10'), findsOneWidget);
    });
  });
}
