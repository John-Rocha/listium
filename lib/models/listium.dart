class Listium {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Listium({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  factory Listium.fromMap(Map<String, dynamic> map) {
    return Listium(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: map['updatedAt'] == null
          ? null
          : DateTime.parse(map['updatedAt']).toLocal(),
    );
  }

  Listium copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Listium(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
