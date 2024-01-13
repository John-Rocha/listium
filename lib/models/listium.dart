class Listium {
  final String id;
  final String name;
  final DateTime createdAt;

  Listium({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory Listium.fromMap(Map<String, dynamic> map) {
    return Listium(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
    );
  }
}
