class LiveStreamModel {
  final String channelName;
  final String hostId;
  final DateTime startTime;
  final String hostAvater;
  final String hostName;
  final List viewers;
  final String visibility;

  LiveStreamModel({
    required this.hostAvater,
    required this.channelName,
    required this.hostId,
    required this.startTime,
    required this.viewers,
    required this.visibility,
    required this.hostName,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      channelName: json['channelName'] ?? "",
      hostId: json['hostId'] ?? "",
      startTime: DateTime.parse(json['startTime']),
      hostAvater: json['hostAvater'] ?? "",
      viewers: json["viewers"] ?? [],
      visibility: json['visibility'] ?? "",
      hostName: json['hostName'] ?? "",
    );
  }
}
