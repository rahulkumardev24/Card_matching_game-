import 'dart:convert';

class CardItem {
  final int id;
  final String imagePath;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.imagePath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'isFlipped': isFlipped,
      'isMatched': isMatched,
    };
  }

  factory CardItem.fromMap(Map<String, dynamic> map) {
    return CardItem(
      id: map['id'],
      imagePath: map['imagePath'],
      isFlipped: map['isFlipped'] ?? false,
      isMatched: map['isMatched'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory CardItem.fromJson(String source) => CardItem.fromMap(json.decode(source));

  CardItem copyWith({
    int? id,
    String? imagePath,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardItem(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}