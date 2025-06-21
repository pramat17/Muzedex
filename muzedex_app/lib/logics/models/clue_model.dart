class Clue {
  final int id;
  final String type;
  final String text;

  Clue({required this.id, required this.type, required this.text});

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'],
      type: json['type'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'text': text,
    };
  }
}
