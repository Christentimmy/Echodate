

class BankModel {
  String? recipientCode;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? bankName;
  String? currency;
  Map<String, dynamic>? metadata;
  String? id;

  BankModel({
    this.recipientCode,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    this.currency,
    this.metadata,
    this.id,
  });

  // Convert from JSON (Map)
  factory BankModel.fromMap(Map<String, dynamic> map) {
    return BankModel(
      recipientCode: map["recipient_code"] ?? "",
      accountNumber: map["account_number"] ?? "",
      accountName: map["account_name"] ?? "",
      bankCode: map["bank_code"] ?? "",
      bankName: map["bank_name"] ?? "",
      currency: map["currency"] ?? "",
      metadata: map["metadata"] ?? "",
      id: map["_id"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (recipientCode != null && recipientCode?.isNotEmpty == true) {
      data["recipient_code"] = recipientCode;
    }
    if (accountNumber != null && accountNumber?.isNotEmpty == true) {
      data["account_number"] = accountNumber;
    }
    if (accountName != null && accountName?.isNotEmpty == true) {
      data["account_name"] = accountName;
    }
    if (bankCode != null && bankCode?.isNotEmpty == true) {
      data["bank_code"] = bankCode;
    }
    if (bankName != null && bankName?.isNotEmpty == true) {
      data["bank_name"] = bankName;
    }
    if (currency != null && currency?.isNotEmpty == true) {
      data["currency"] = currency;
    }
    if (metadata != null && metadata?.isNotEmpty == true) {
      data["metadata"] = metadata;
    }
    if (id != null && id?.isNotEmpty == true) data["_id"] = id;

    return data;
  }
}
