
class Leave {
  final int type;
  final int duration;
  final String note;
  final String realName;
  final String objectId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String username;
  final DateTime startDate;
  final DateTime endDate;
  final String endTime; //AM or PM
  final String startTime;

  Leave({
    this.type,
    this.duration,
    this.note,
    this.realName,
    this.objectId,
    this.createdAt,
    this.updatedAt,
    this.username,
    this.startDate,
    this.endDate,
    this.endTime,
    this.startTime,
  });

  factory Leave.fromJson(Map<String, dynamic> json) {
    return new Leave(
      type: json['type'],
      duration: json['duration'],
      note: json['note'],
      realName: json['realName'],
      objectId: json['objectId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      username: json['username'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      endTime: json['endTime'],
      startTime: json['startTime'],
    );
  }
}
