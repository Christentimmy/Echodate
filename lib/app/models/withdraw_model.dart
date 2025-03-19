
class WithdrawModel {
  final String user;
  final double amount;
  final String status;
  final String recipientCode;
  final String reference;
  final DateTime createdAt;
  final Map<String, dynamic> withDrawData;

  // Constructor
  WithdrawModel({
    required this.user,
    required this.amount,
    required this.status,
    required this.recipientCode,
    required this.reference,
    required this.createdAt,
    required this.withDrawData,
  });

  factory WithdrawModel.fromJson(Map<String, dynamic> json) {
    return WithdrawModel(
      user: json['user'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      recipientCode: json['recipientCode'],
      reference: json['reference'],
      createdAt: DateTime.parse(json['createdAt']),
      withDrawData: json['withDrawData'] ?? {},
    );
  }

}
