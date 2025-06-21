import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/room_service.dart';

import 'mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RoomService roomService;
  late RoomCubit roomCubit;

  var clue = Clue(
    id: 1,
    type: 'Shadobject',
    text: 'Quelle est cette ombre ?',
  );

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
            clues: [clue],
            whoAmI: ""),
      ],
    ),
  ];

  setUp(() {
    roomService = MockRoomService();
    roomCubit = RoomCubit(roomService);
  });

  tearDown(() {
    roomCubit.close();
  });

  group('RoomCubit', () {
    test('initial state is correct', () {
      expect(roomCubit.state, const RoomState(currentFloor: 0));
    });

    blocTest<RoomCubit, RoomState>(
      'emits [isLoading: true, rooms: fakeRooms, currentRoom: fakeRooms.first, isLoading: false, playerName: test_user] when fetchRooms is called',
      build: () {
        when(() => roomService.fetchRooms(onProgress: any(named: 'onProgress')))
            .thenAnswer((_) async => fakeRooms);
        return roomCubit;
      },
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

    blocTest<RoomCubit, RoomState>(
      'emits updated state when selectRoom is called',
      build: () => roomCubit,
      seed: () => RoomState(currentFloor: 0, rooms: fakeRooms),
      act: (cubit) => cubit.selectRoom(fakeRooms[0]),
      expect: () => [
        RoomState(
          currentFloor: 0,
          rooms: fakeRooms,
          currentRoom: fakeRooms[0],
        ),
      ],
    );
  });
}
