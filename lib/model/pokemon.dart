class Pokemon {
  final String name;
  final String image;
  final List<String> types;
  final int id;

  Pokemon({required this.name,required this.image,required this.types,required this.id});

  factory Pokemon.fromJson(Map<dynamic, dynamic> json) {
    return Pokemon(
      name: json['name'],
      image: json['sprites']['front_default'],
      types: List.from(json['types']).map<String>((type) => type['type']['name']).toList(),
      id: json['id'],
    );
  }
  @override
  String toString() {
    return 'Pokemon{name: $name, image: $image, types: $types, id: $id}';
  }
}
