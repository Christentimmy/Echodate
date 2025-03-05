
class LiveStreamChatModel {
  final String id;
  final String userId;
  final String username;
  final String message;
  final String userAvatar;
  final DateTime timestamp;

  LiveStreamChatModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.message,
    required this.userAvatar,
    required this.timestamp,
  });

  factory LiveStreamChatModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamChatModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      message: json['message'] ?? '',
      userAvatar: json['userAvatar'] ?? '',
      timestamp: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}