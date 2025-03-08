
import 'dart:convert';

class StoryModel {
  final String? id;
  final String? userId;
  final String? fullName;
  final String? content;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime? expiresAt;
  final String? visibility;
  final List<String>? viewedBy;
  final DateTime? createdAt;

  StoryModel({
    this.id,
    this.userId,
    this.fullName,
    this.content,
    this.mediaUrl,
    this.mediaType,
    this.expiresAt,
    this.visibility,
    this.viewedBy,
    this.createdAt,
  });

  // Factory method to create a StoryModel object from a JSON map
  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String?,
      fullName: json['full_name'] as String?,
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      mediaType: json['mediaType'] as String?,
      expiresAt: json['expiresAt'] != null ? DateTime.tryParse(json['expiresAt']) : null,
      visibility: json['visibility'] as String?,
      viewedBy: (json['viewedBy'] as List<dynamic>?)?.map((e) => e as String).toList(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  // Convert a StoryModel object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'full_name': fullName,
      'content': content,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'expiresAt': expiresAt?.toIso8601String(),
      'visibility': visibility,
      'viewedBy': viewedBy,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Convert a JSON string to a StoryModel object
  static StoryModel? fromJsonString(String jsonString) {
    try {
      return StoryModel.fromJson(json.decode(jsonString));
    } catch (e) {
      return null;
    }
  }

  // Convert a StoryModel object to a JSON string
  String toJsonString() {
    return json.encode(toJson());
  }
}
