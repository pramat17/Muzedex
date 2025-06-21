import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';

void main() {
  group('Clue Model Tests', () {
    test('fromJson creates a valid Clue object', () {
      final clueJson = {'id': 1, 'type': 'text', 'text': 'This is a clue'};
      final clue = Clue.fromJson(clueJson);

      expect(clue.id, 1);
      expect(clue.type, 'text');
      expect(clue.text, 'This is a clue');
    });

    test('toJson converts a Clue object to JSON', () {
      final clue = Clue(id: 1, type: 'text', text: 'This is a clue');
      final json = clue.toJson();

      expect(json, {
        'id': 1,
        'type': 'text',
        'text': 'This is a clue',
      });
    });
  });

  group('Item Model Tests', () {
    test('fromJson creates a valid Item object', () {
      final itemJson = {
        'id': 1,
        'name': 'Key',
        'description': 'A golden key',
        'tags': ['metal', 'key'],
        'imageLink': 'https://example.com/key.png',
        'coordinates': '12,34',
        'isFound': false,
        'isRevealed': false,
        'clues': [
          {'id': 1, 'type': 'text', 'text': 'This is the first clue'},
          {'id': 2, 'type': 'text', 'text': 'This is the second clue'},
        ],
        'whoAmI': "",
      };

      final item = Item.fromJson(itemJson);

      expect(item.id, 1);
      expect(item.name, 'Key');
      expect(item.description, 'A golden key');
      expect(item.tags, ['metal', 'key']);
      expect(item.imageLink, 'https://example.com/key.png');
      expect(item.coordinates, '12,34');
      expect(item.isFound, false);
      expect(item.isRevealed, false);
      expect(item.clues.length, 2);
      expect(item.clues.first.text, 'This is the first clue');
    });

    test('toJson converts an Item object to JSON', () {
      final item = Item(
        id: 1,
        name: 'Key',
        description: 'A golden key',
        tags: ['metal', 'key'],
        imageLink: 'https://example.com/key.png',
        coordinates: '12,34',
        isFound: false,
        isRevealed: false,
        clues: [
          Clue(id: 1, type: 'text', text: 'This is the first clue'),
          Clue(id: 2, type: 'text', text: 'This is the second clue'),
        ],
        whoAmI: "",
      );

      final json = item.toJson();

      expect(json, {
        'id': 1,
        'name': 'Key',
        'description': 'A golden key',
        'tags': ['metal', 'key'],
        'imageLink': 'https://example.com/key.png',
        'coordinates': '12,34',
        'isFound': false,
        'isRevealed': false,
        'clues': [
          {'id': 1, 'type': 'text', 'text': 'This is the first clue'},
          {'id': 2, 'type': 'text', 'text': 'This is the second clue'},
        ],
        'whoAmI': "",
      });
    });
  });

  group('Room Model Tests', () {
    test('fromJson creates a valid Room object', () async {
      final roomJson = {
        'id': 1,
        'name': 'Room 101',
        'number': 101,
        'position': "12,34",
        'floor': 1,
        'items': [
          {
            'id': 1,
            'name': 'Key',
            'description': 'A golden key',
            'tags': ['metal', 'key'],
            'imageLink': 'https://example.com/key.png',
            'coordinates': '12,34',
            'isFound': false,
            'isRevealed': false,
            'clues': [
              {'id': 1, 'type': 'text', 'text': 'This is the first clue'},
            ],
            'whoAmI': "",
          },
        ],
      };

      final room = await Room.fromJson(roomJson);

      expect(room.id, 1);
      expect(room.name, 'Room 101');
      expect(room.number, 101);
      expect(room.floor, 1);
      expect(room.position, '12,34');
      expect(room.items.length, 1);
      expect(room.items.first.name, 'Key');
    });

    test('toJson converts a Room object to JSON', () {
      final room = Room(
        id: 1,
        name: 'Room 101',
        number: 101,
        position: '12,34',
        floor: 1,
        items: [
          Item(
            id: 1,
            name: 'Key',
            description: 'A golden key',
            tags: ['metal', 'key'],
            imageLink: 'https://example.com/key.png',
            coordinates: '12,34',
            isFound: false,
            isRevealed: false,
            clues: [
              Clue(id: 1, type: 'text', text: 'This is the first clue'),
            ],
            whoAmI: "",
          ),
        ],
      );

      final json = room.toJson();

      expect(json, {
        'id': 1,
        'name': 'Room 101',
        'number': 101,
        'floor': 1,
        'position': '12,34',
        'items': [
          {
            'id': 1,
            'name': 'Key',
            'description': 'A golden key',
            'tags': ['metal', 'key'],
            'imageLink': 'https://example.com/key.png',
            'coordinates': '12,34',
            'isFound': false,
            'isRevealed': false,
            'clues': [
              {'id': 1, 'type': 'text', 'text': 'This is the first clue'},
            ],
            'whoAmI': "",
          },
        ],
      });
    });

    test('addItem adds an Item to the Room', () {
      final room = Room(
        id: 1,
        name: 'Room 101',
        number: 101,
        position: '12,34',
        floor: 1,
        items: [],
      );

      final item = Item(
        id: 1,
        name: 'Key',
        description: 'A golden key',
        tags: ['metal', 'key'],
        imageLink: 'https://example.com/key.png',
        coordinates: '12,34',
        clues: [],
        isFound: false,
        isRevealed: false,
        whoAmI: "",
      );

      room.addItem(item);

      expect(room.items.length, 1);
      expect(room.items.first.name, 'Key');
    });
  });
}
