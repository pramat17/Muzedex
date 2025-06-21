import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:rxdart/rxdart.dart';

class RoomState extends Equatable {
  final int currentFloor;
  final int currentRoomIndex;
  final Room? currentRoom;
  final List<Room> rooms;
  final bool isLoading;
  final bool gameFinished;
  final Item? lastItemFound;
  final String? playerName;

  const RoomState({
    this.currentFloor = 0,
    this.currentRoomIndex = 0,
    this.currentRoom,
    this.rooms = const [],
    this.isLoading = false,
    this.gameFinished = false,
    this.lastItemFound,
    this.playerName,
  });

  RoomState copyWith({
    int? currentFloor,
    int? currentRoomIndex,
    Room? currentRoom,
    List<Room>? rooms,
    bool? isLoading,
    bool? gameFinished,
    Item? lastItemFound,
    String? playerName,
  }) {
    return RoomState(
      currentFloor: currentFloor ?? this.currentFloor,
      currentRoomIndex: currentRoomIndex ?? this.currentRoomIndex,
      currentRoom: currentRoom ?? this.currentRoom,
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      gameFinished: gameFinished ?? this.gameFinished,
      lastItemFound: lastItemFound ?? this.lastItemFound,
      playerName: playerName ?? this.playerName,
    );
  }

  @override
  List<Object?> get props => [
        currentFloor,
        currentRoomIndex,
        currentRoom,
        rooms,
        isLoading,
        gameFinished,
        lastItemFound,
        playerName,
      ];
}

class RoomCubit extends Cubit<RoomState> {
  final RoomService roomService;
  final _loadingProgressController = BehaviorSubject<double>();

  Stream<double> get loadingProgressStream => _loadingProgressController.stream;
  RoomCubit(this.roomService) : super(const RoomState());

  Future<void> fetchRooms() async {
    emit(state.copyWith(isLoading: true));
    _loadingProgressController.add(0.0);

    try {
      final rooms = await roomService.fetchRooms(
        onProgress: (progress) {
          _loadingProgressController.add(progress);
        },
      );
      emit(state.copyWith(
        rooms: rooms,
        currentRoom: rooms.isNotEmpty ? rooms.first : null,
        isLoading: false,
        gameFinished: state.gameFinished,
      ));
      _loadingProgressController.add(1.0);
    } catch (error) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<void> fetchPlayerName() async {
    final playerName = await FileManager().getPlayerName();
    emit(state.copyWith(playerName: playerName));
  }

  @override
  Future<void> close() {
    _loadingProgressController.close();
    return super.close();
  }

  void selectRoom(Room room) {
    emit(state.copyWith(currentRoom: room));
  }

  void setCurrentRoomIndex(int index) {
    emit(state.copyWith(currentRoomIndex: index));
  }

  void nextRoom() {
    if (state.currentRoomIndex < state.rooms.length - 1) {
      final newIndex = state.currentRoomIndex + 1;
      emit(state.copyWith(
        currentRoomIndex: newIndex,
        currentRoom: state.rooms[newIndex],
      ));
    }
  }

  void previousRoom() {
    if (state.currentRoomIndex > 0) {
      final newIndex = state.currentRoomIndex - 1;
      emit(state.copyWith(
        currentRoomIndex: newIndex,
        currentRoom: state.rooms[newIndex],
      ));
    }
  }

  void selectFloor(int floor) {
    if (state.currentFloor != floor) {
      final roomsOnFloor = getRoomsByFloor(floor);
      emit(state.copyWith(
        currentFloor: floor,
        currentRoomIndex: 0,
        currentRoom: roomsOnFloor.first,
      ));
    }
  }

  void finishGame() {
    emit(state.copyWith(gameFinished: true));
  }

  void setLastItemFound(Item item) {
    emit(state.copyWith(lastItemFound: item));
  }

  // Fonction qui retourne la salle selon l'id d'un item
  Room getRoomByItemId(int itemId) {
    final room = state.rooms.firstWhere(
      (room) => room.items.any((item) => item.id == itemId),
      orElse: () => Room(
          id: -1, name: 'Inconnu', number: -1, floor: -1, position: 'Inconnu'),
    );

    return room;
  }

  // Fonction qui retourne le numéro de l'item selon son id
  int getItemNumberById(int itemId) {
    int itemNumber = 0;
    for (var room in state.rooms) {
      for (var item in room.items) {
        if (item.id == itemId) {
          return itemNumber + 1;
        } else {
          itemNumber += 1;
        }
      }
    }
    return -1; // Return -1 if item is not found
  }

  List<Room> getRoomsByFloor(int floor) {
    return state.rooms.where((room) => room.floor == floor).toList();
  }

  void revealItem(int itemId) async {
    final rooms = state.rooms.map((room) {
      final updatedItems = room.items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(isRevealed: true);
        }
        return item;
      }).toList();

      return room.copyWith(items: updatedItems);
    }).toList();

    emit(state.copyWith(rooms: rooms));

    await FileManager().updateItemIsRevealed(itemId);
  }

  int getNumberOfFoundButUnrevealedItems() {
    int numberOfRevealedItems = 0;
    for (var room in state.rooms) {
      for (var item in room.items) {
        if (item.isFound && !item.isRevealed) {
          numberOfRevealedItems += 1;
        }
      }
    }
    return numberOfRevealedItems;
  }
}
