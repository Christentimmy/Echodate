

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final int coins;
  final String reference;
  final String status;
  final DateTime? createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.reference,
    required this.status,
    required this.createdAt,
    required this.coins,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json["_id"] ?? "",
      userId: json["user"] ?? "",
      amount: (json["amount"] as num).toDouble(),
      coins: json["coins"] ?? 0,
      reference: json["reference"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }
}
