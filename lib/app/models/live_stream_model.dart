class LiveStreamModel {
  final String channelName;
  final String hostId;
  final DateTime startTime;
  final String hostAvater;
  final List viewers;
  final String visibility;

  LiveStreamModel({
    required this.hostAvater,
    required this.channelName,
    required this.hostId,
    required this.startTime,
    required this.viewers,
    required this.visibility,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      channelName: json['channelName'] ?? "",
      hostId: json['hostId'] ?? "",
      startTime: DateTime.parse(json['startTime']),
      hostAvater: json['hostAvater'] ?? "",
      viewers: json["viewers"] ?? [],
      visibility: json['visibility'] ?? "",
    );
  }
}
