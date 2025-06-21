import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/services/item_service.dart';

class Room {
  final int id;
  final String name;
  final int number;
  final int floor;
  final String position;
  final List<Item> items;

  Room({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.floor,
    this.items = const [],
  });

  /// ✅ Ajout de `copyWith`
  Room copyWith({
    int? id,
    String? name,
    int? number,
    int? floor,
    List<Item>? items,
    String? position,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      floor: floor ?? this.floor,
      items: items ?? this.items,
      position: position ?? this.position,
    );
  }

  static Future<Room> fromJson(Map<String, dynamic> json) async {
    var itemsFromJson = json['items'] as List;
    List<Item> itemsList =
        itemsFromJson.map((item) => Item.fromJson(item)).toList();

    return Room(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      floor: json['floor'],
      position: json['position'],
      items: itemsList,
    );
  }

  static Future<Room> fromJsonFetchingItems(
      Map<String, dynamic> json, ItemService itemService) async {
    List<Item> items = [];
    for (var itemJson in json['items']) {
      Item item = await itemService.fetchItem(itemJson['id']);
      items.add(item);
    }

    return Room(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      position: json['position'],
      floor: json['floor'],
      items: items,
    );
  }

  void addItem(Item item) {
    items.add(item);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'position': position,
      'floor': floor,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
