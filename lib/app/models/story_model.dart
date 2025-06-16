class StoryModel {
  final String? id;
  final String? userId;
  final String? fullName;
  final List<Stories>? stories;

  StoryModel({
    this.id,
    this.userId,
    this.fullName,
    this.stories,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['_id'] ?? "",
      userId: json['userId'] ?? "",
      fullName: json['full_name'] as String?,
      stories: json['stories'] != null
          ? List<Stories>.from(json['stories'].map((x) => Stories.fromMap(x)))
          : <Stories>[],
    );
  }

  @override
  String toString() {
    return '''
    StoryModel(
    id: $id, 
    userId: $userId, 
    fullName: $fullName, 
    stories: $stories
    )''';
  }
}

class Stories {
  final String? content;
  final String? mediaUrl;
  final String? mediaType;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final List<String>? viewedBy;
  final String? id;

  Stories({
    this.content,
    this.mediaUrl,
    this.mediaType,
    this.createdAt,
    this.expiresAt,
    this.viewedBy,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content ?? "",
      'mediaUrl': mediaUrl ?? "",
      'mediaType': mediaType ?? "",
      'createdAt': createdAt ?? "",
      'expiresAt': expiresAt ?? "",
      'viewedBy': viewedBy ?? [],
      'id': id ?? "",
    };
  }

  factory Stories.fromMap(Map<String, dynamic> map) {
    return Stories(
      content: map['content'] ?? "",
      mediaUrl: map['mediaUrl'] ?? "",
      mediaType: map['mediaType'] ?? "",
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'].toString())
          : DateTime.now(),
      expiresAt: map['expiresAt'] != null
          ? DateTime.tryParse(map['expiresAt'].toString())
          : DateTime.now(),
      viewedBy:
          map['viewedBy'] != null ? List<String>.from((map['viewedBy'])) : [],
      id: map['id'] ?? "",
    );
  }

  @override
  String toString() {
    return '''
    Stories(
    content: $content, 
    mediaUrl: $mediaUrl, 
    mediaType: $mediaType, 
    createdAt: $createdAt, 
    expiresAt: $expiresAt, 
    viewedBy: $viewedBy, 
    id: $id 
    )''';
  }
}
