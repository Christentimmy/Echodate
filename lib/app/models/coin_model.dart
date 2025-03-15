class CoinModel {
  final String id;
  final int coins;
  final num price;

  CoinModel({
    required this.id,
    required this.coins,
    required this.price,
  });

  factory CoinModel.fromMap(Map<String, dynamic> map) {
    return CoinModel(
      id: map['id'] ?? "",
      coins: map['coins'] ?? 0,
      price: map['price'] ?? 0.0,
    );
  }
  @override
  String toString() => 'CoinModel(id: $id, coins: $coins, price: $price)';
}
