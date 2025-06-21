import 'package:muzedex_app/logics/models/clue_model.dart';

class Item {
  final int id;
  final String name;
  final String description;
  final List<String> tags;
  final String imageLink;
  final String coordinates;
  final List<Clue> clues;
  final String whoAmI;
  bool isFound;
  bool isRevealed;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.imageLink,
    required this.coordinates,
    required this.clues,
    required this.isFound,
    required this.isRevealed,
    required this.whoAmI,
  });

  Item copyWith({
    int? id,
    String? name,
    String? description,
    List<String>? tags,
    String? imageLink,
    String? coordinates,
    List<Clue>? clues,
    String? whoAmI,
    bool? isFound,
    bool? isRevealed,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      imageLink: imageLink ?? this.imageLink,
      coordinates: coordinates ?? this.coordinates,
      clues: clues ?? this.clues,
      whoAmI: whoAmI ?? this.whoAmI,
      isFound: isFound ?? this.isFound,
      isRevealed: isRevealed ?? this.isRevealed,
    );
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    var cluesFromJson = json['clues'] as List;
    List<Clue> clueList =
        cluesFromJson.map((clue) => Clue.fromJson(clue)).toList();

    return Item(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      tags: List<String>.from(json['tags']),
      imageLink: json['imageLink'],
      coordinates: json['coordinates'],
      clues: clueList,
      whoAmI: json['whoAmI'],
      isFound: json['isFound'] ?? false,
      isRevealed: json['isRevealed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags,
      'imageLink': imageLink,
      'coordinates': coordinates,
      'whoAmI': whoAmI,
      'isFound': isFound,
      'isRevealed': isRevealed,
      'clues': clues.map((clue) => clue.toJson()).toList(),
    };
  }
}
