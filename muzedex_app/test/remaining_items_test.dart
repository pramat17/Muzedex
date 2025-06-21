import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/widgets/molecules/remaining_item_molecule.dart';
import 'package:muzedex_app/widgets/organisms/remaining_items_popup_organism.dart';

import 'mocks.dart';

class MockRoomCubit extends Mock implements RoomCubit {}

class FakeRoomState extends Fake implements RoomState {}

void main() {
  group('RemainingItemsPopupOrganism Tests', () {
    testWidgets('Affiche le bon message quand tous les objets sont trouvés',
        (WidgetTester tester) async {
      List<Item> items = [
        Item(
          id: 1,
          name: 'Le Lièvre d\'Europe',
          description: 'Description',
          tags: ['tag1', 'tag2'],
          imageLink: 'imageLink',
          coordinates: 'coordinates',
          clues: [Clue(id: 1, type: 'text', text: 'clue1')],
          isFound: true,
          isRevealed: false,
          whoAmI: 'whoAmI',
        ),
        Item(
          id: 2,
          name: 'La Hyène',
          description: 'Description',
          tags: ['tag1', 'tag2'],
          imageLink: 'imageLink',
          coordinates: 'coordinates',
          clues: [Clue(id: 1, type: 'text', text: 'clue1')],
          isFound: true,
          isRevealed: false,
          whoAmI: 'whoAmI',
        )
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
              home: RemainingItemsPopupOrganism(items: items, roomNumber: 1)),
        ),
      );

      // Le message désormais inclut le nom du joueur ("testeur")
      expect(
          find.text(
              'testeur, tu as trouvé tous les objets de la salle 1, bravo !'),
          findsOneWidget);
    });

    testWidgets('Affiche le bon message quand des objets restent à trouver',
        (WidgetTester tester) async {
      List<Item> items = [
        Item(
          id: 1,
          name: 'Le Lièvre d\'Europe',
          description: 'Description',
          tags: ['tag1', 'tag2'],
          imageLink: 'imageLink',
          coordinates: 'coordinates',
          clues: [Clue(id: 1, type: 'text', text: 'clue1')],
          isFound: true,
          isRevealed: false,
          whoAmI: 'whoAmI',
        ),
        Item(
          id: 2,
          name: 'La Hyène',
          description: 'Description',
          tags: ['tag1', 'tag2'],
          imageLink: 'imageLink',
          coordinates: 'coordinates',
          clues: [Clue(id: 1, type: 'text', text: 'clue1')],
          isFound: false,
          isRevealed: false,
          whoAmI: 'whoAmI',
        )
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
              home: RemainingItemsPopupOrganism(items: items, roomNumber: 2)),
        ),
      );

      expect(
          find.text(
              "Tu y es presque testeur ! Plus qu'un objet à trouver dans la salle 2 !"),
          findsOneWidget);
    });

    testWidgets('Affiche la liste des objets restants',
        (WidgetTester tester) async {
      List<Item> items = [
        Item(
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
        ),
        Item(
          id: 2,
          name: 'La Hyène',
          description: 'Description',
          tags: ['tag1', 'tag2'],
          imageLink: 'imageLink',
          coordinates: 'coordinates',
          clues: [Clue(id: 1, type: 'text', text: 'clue1')],
          isFound: true,
          isRevealed: false,
          whoAmI: 'whoAmI',
        )
      ];

      final roomService = MockRoomService();

      await tester.pumpWidget(
        BlocProvider(
          create: (context) => RoomCubit(roomService),
          child: MaterialApp(
            home: RemainingItemsPopupOrganism(items: items, roomNumber: 3),
          ),
        ),
      );

      expect(find.byType(RemainingItemMolecule), findsNWidgets(2));
    });
  });

  group('RemainingItemMolecule Tests', () {
    testWidgets('Navigue vers "/details" si l\'objet est trouvé',
        (WidgetTester tester) async {
      final mockObserver = NavigatorObserver();
      Item foundItem = Item(
        id: 1,
        name: 'Le Lièvre d\'Europe',
        description: 'Description',
        tags: ['tag1', 'tag2'],
        imageLink: 'imageLink',
        coordinates: 'coordinates',
        clues: [Clue(id: 1, type: 'text', text: 'clue1')],
        isFound: true,
        isRevealed: false,
        whoAmI: 'whoAmI',
      );

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/details': (context) => const Scaffold(body: Text('Détails')),
          },
          home: Scaffold(
            body: RemainingItemMolecule(item: foundItem),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Détails'), findsOneWidget);
    });

    testWidgets('Navigue vers "/riddle" si l\'objet n\'est pas trouvé',
        (WidgetTester tester) async {
      final mockObserver = NavigatorObserver();
      Item notFoundItem = Item(
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

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/riddle': (context) => const Scaffold(body: Text('Énigme')),
          },
          home: Scaffold(
            body: RemainingItemMolecule(item: notFoundItem),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Énigme'), findsOneWidget);
    });
  });
}
