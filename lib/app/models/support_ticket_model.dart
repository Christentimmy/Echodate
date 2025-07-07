class SupportTicketModel {
  final String id;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? category;

  SupportTicketModel({
    required this.id,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: json['_id'] ?? '',
      description: json['description'] ?? "",
      status: json['status'] ?? "",
      createdAt:
          json["createdAt"] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json["updatedAt"] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
      category: json['category'] ?? "",
    );
  }
}
