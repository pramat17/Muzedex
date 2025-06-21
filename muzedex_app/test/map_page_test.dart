import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/widgets/molecules/floor_navigation_molecule.dart';
import 'package:muzedex_app/widgets/molecules/room_navigation_molecule.dart';
import 'package:muzedex_app/widgets/organisms/map_organism.dart';

import 'mocks.dart';

void main() {
  late RoomService roomService;
  group('MapOrganism Tests', () {
    final clue = Clue(
      id: 1,
      type: 'Shadobject',
      text: 'Quelle est cette ombre ?',
    );

    // Mise à jour des coordonnées pour qu'elles soient séparées par ";".
    final List<Room> fakeRooms = [
      Room(
        id: 1,
        name: 'Room1',
        number: 1,
        floor: 1,
        position: "10;20",
        items: [
          Item(
            id: 1,
            name: "Girafe",
            imageLink: "assets/images/girafe.png",
            tags: ["Mammifère", "Savane"],
            description: "Une girafe",
            isFound: false,
            isRevealed: false,
            coordinates: "0.0;0.0",
            clues: [clue],
            whoAmI: "",
          ),
          Item(
            id: 2,
            name: "Girafe",
            imageLink: "assets/images/girafe.png",
            tags: ["Mammifère", "Savane"],
            description: "Une girafe",
            isFound: false,
            isRevealed: false,
            coordinates: "0.0;0.0",
            clues: [clue],
            whoAmI: "",
          ),
        ],
      ),
      Room(
        id: 2,
        name: 'Room2',
        position: "50;60",
        number: 2,
        floor: 1,
        items: [
          Item(
            id: 3,
            name: "Girafe",
            imageLink: "assets/images/girafe.png",
            tags: ["Mammifère", "Savane"],
            description: "Une girafe",
            isFound: false,
            isRevealed: false,
            coordinates: "0.0;0.0",
            clues: [clue],
            whoAmI: "",
          ),
        ],
      ),
    ];

    late RoomCubit roomCubit;

    setUp(() {
      roomService = MockRoomService();
      roomCubit = RoomCubit(roomService);
      // Précharge l'état du cubit avec la liste des salles et la salle initiale.
      roomCubit.emit(roomCubit.state.copyWith(
        rooms: fakeRooms,
        currentRoom: fakeRooms[0],
        currentRoomIndex: 0,
      ));
    });

    tearDown(() {
      roomCubit.close();
    });

    Widget createTestableWidget() {
      return MaterialApp(
        home: BlocProvider.value(
          value: roomCubit,
          child: Scaffold(
            body: MapOrganism(
              initialRoom: fakeRooms[0],
              currentFloor: 1,
              floorsCount: 1,
              setCurrentFloor: (floor) {},
              floorImage: 'assets/images/mapfloor1.png',
              floorSvg: 'assets/images/mapfloor1.svg',
              rooms: fakeRooms,
            ),
          ),
        ),
      );
    }

    testWidgets('renders Stack and Scrollable view',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(Stack), findsWidgets);
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('displays the active room name', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('01'), findsOneWidget);
      expect(find.text('Room1'), findsOneWidget);
    });

    testWidgets('renders navigation molecules', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(FloorNavigationMolecule), findsOneWidget);
      expect(find.byType(RoomNavigationMolecule), findsOneWidget);
    });

    testWidgets('changes the active room on navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      await tester.pump(const Duration(seconds: 1));

      // Vérification de l'état initial.
      expect(find.text('01'), findsOneWidget);
      expect(find.text('Room1'), findsOneWidget);

      // Simulation du clic sur le bouton "Next".
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pump(const Duration(seconds: 1));

      // Après clic "Next" on s'attend à voir Room2 avec numéro "02".
      expect(find.text('02'), findsOneWidget);
      expect(find.text('Room2'), findsOneWidget);

      // Simulation du clic sur le bouton "Previous".
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump(const Duration(seconds: 1));

      // Retour à Room1.
      expect(find.text('01'), findsOneWidget);
      expect(find.text('Room1'), findsOneWidget);
    });
  });
}
