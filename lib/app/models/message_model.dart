
class MessageModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  String? messageType;
  String? status;
  DateTime? timestamp;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MessageModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.messageType,
    this.status,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });


  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json["_id"] ?? "",
      senderId: json["senderId"] ?? "",
      receiverId: json["receiverId"] ?? "",
      message: json["message"] ?? "",
      messageType: json["messageType"] ?? "text",
      status: json["status"] ?? "sent",
      timestamp: json["timestamp"] != null ? DateTime.parse(json["timestamp"]) : null,
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
      v: json["__v"] ?? 0,
    );
  }

  // Method to convert the Message instance back to JSON, omitting null values
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (id != null) data["_id"] = id;
    if (senderId != null) data["senderId"] = senderId;
    if (receiverId != null) data["receiverId"] = receiverId;
    if (message != null) data["message"] = message;
    if (messageType != null) data["messageType"] = messageType;
    if (status != null) data["status"] = status;
    if (timestamp != null) data["timestamp"] = timestamp?.toIso8601String();
    if (createdAt != null) data["createdAt"] = createdAt?.toIso8601String();
    if (updatedAt != null) data["updatedAt"] = updatedAt?.toIso8601String();
    if (v != null) data["__v"] = v;

    return data;
  }
}
