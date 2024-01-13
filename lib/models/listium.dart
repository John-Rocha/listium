class Listium {
  String id;
  String name;
  Listium({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Listium.fromMap(Map<String, dynamic> map) {
    return Listium(
      id: map['id'],
      name: map['name'],
    );
  }
}
