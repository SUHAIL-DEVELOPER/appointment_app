import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  final String sessionId;
  final String userId;
  final String title;
  final DateTime scheduledTime;
  final String status;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? duration;

  Session({
    required this.sessionId,
    required this.userId,
    required this.title,
    required this.scheduledTime,
    required this.status,
    this.startTime,
    this.endTime,
    this.duration,
  });

  factory Session.fromMap(Map<String, dynamic> data, String id) {
    DateTime parseTime(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is int) return DateTime.fromMillisecondsSinceEpoch(val * 1000);
      return DateTime.now(); // Fallback
    }

    return Session(
      sessionId: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? 'No Title',
      scheduledTime: parseTime(data['scheduledTime']),
      status: data['status'] ?? 'upcoming',
      startTime: data['startTime'] != null ? parseTime(data['startTime']) : null,
      endTime: data['endTime'] != null ? parseTime(data['endTime']) : null,
      duration: data['duration'],
    );
  }
}
