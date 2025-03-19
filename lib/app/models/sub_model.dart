class SubModel {
  String? id;
  String? title;
  double? price;
  int? durationDays;
  List<String>? features;

  SubModel({
     this.id,
     this.title,
     this.price,
     this.durationDays,
     this.features,
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
