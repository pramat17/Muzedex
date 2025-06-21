import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/pages/end_page.dart';
import 'package:muzedex_app/pages/map_page.dart';
import 'package:muzedex_app/widgets/organisms/end_organism.dart';

import 'mocks.dart';

void main() {
  late RoomService roomService;
  late RoomCubit roomCubit;

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
            coordinates: "0, 0",
            clues: [],
            whoAmI: ""),
      ],
    ),
  ];

  setUp(() {
    roomService = MockRoomService();
    roomCubit = RoomCubit(roomService);

    when(() => roomService.fetchRooms(onProgress: any(named: 'onProgress')))
        .thenAnswer((_) async => fakeRooms);
  });

  tearDown(() {
    roomCubit.close();
  });

  group('EndPage Rendering and Navigation Tests', () {
    Widget createTestableWidget({required Widget child}) {
      return BlocProvider(
        create: (context) => roomCubit,
        child: MaterialApp(
          home: child,
          routes: {
            '/plan': (context) => const MapPage(),
          },
        ),
      );
    }

    testWidgets('EndPage renders correctly with confetti, messages, and button',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(child: const EndPage()));

      await tester.pump();

      expect(find.byType(EndOrganism), findsOneWidget);
      expect(find.text('Félicitations !'), findsOneWidget);
      expect(
        find.textContaining(
            'Tu as trouvé toutes les cartes de la collection !'),
        findsOneWidget,
      );
      expect(find.text("Retour au Muzédex"), findsOneWidget);
    });

    blocTest<RoomCubit, RoomState>(
      'emits updated state when fetchRooms is triggered',
      build: () => roomCubit,
      act: (cubit) => cubit.fetchRooms(),
      expect: () => [
        const RoomState(currentFloor: 0, isLoading: true),
        RoomState(
          currentFloor: 0,
          rooms: fakeRooms,
          currentRoom: fakeRooms.first,
          isLoading: false,
        ),
      ],
      verify: (_) {
        verify(() =>
                roomService.fetchRooms(onProgress: any(named: 'onProgress')))
            .called(1);
      },
    );
  });
}
