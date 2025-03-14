class SubModel {
  final String id;
  final String title;
  final double price;
  final int durationDays;
  final List<String> features;

  SubModel({
    required this.id,
    required this.title,
    required this.price,
    required this.durationDays,
    required this.features,
  });


  factory SubModel.fromMap(Map<String, dynamic> map) {
    return SubModel(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
      price: map['price'] ?? 0.0,
      durationDays: map['durationDays'] ?? 0,
      features: map['features'] != null
          ? List<String>.from((map['features']))
          : [],
    );
  }

  @override
  String toString() {
    return 'SubModel(id: $id, title: $title, price: $price, durationDays: $durationDays, features: $features)';
  }
}
