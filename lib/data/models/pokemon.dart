class Pokemon {
  final int id;
  final String name;
  final List<String> type;
  final String image;

  Pokemon({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      type: List<String>.from(json['type']),
      image: json['img'],
    );
  }
}
