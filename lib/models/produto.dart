class Produto {
  final String id;
  final String name;
  final double? price;
  final double? amount;
  final bool isComprado;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Produto({
    required this.id,
    required this.name,
    this.price,
    this.amount,
    required this.isComprado,
    required this.createdAt,
    this.updatedAt,
  });

  Produto copyWith({
    String? id,
    String? name,
    double? price,
    double? amount,
    bool? isComprado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Produto(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      isComprado: isComprado ?? this.isComprado,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'price': price,
      'amount': amount,
      'isComprado': isComprado,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt?.toUtc().toIso8601String(),
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      name: map['name'],
      price: map['price']?.toDouble(),
      amount: map['amount']?.toDouble(),
      isComprado: map['isComprado'],
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt']).toLocal()
          : null,
    );
  }
}
