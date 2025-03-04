class LiveStreamModel {
  final String channelName;
  final String hostId;
  final DateTime startTime;
  final String hostAvater;
  final List viewers;

  LiveStreamModel({
    required this.hostAvater,
    required this.channelName,
    required this.hostId,
    required this.startTime,
    required this.viewers,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      channelName: json['channelName'] ?? "",
      hostId: json['hostId'] ?? "",
      startTime: DateTime.parse(json['startTime']),
      hostAvater: json['hostAvater'] ?? "",
      viewers: json["viewers"] ?? [],
    );
  }
}
