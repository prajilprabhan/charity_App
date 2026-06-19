import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('notifications').add({
        'userId': userId,
        'title': title,
        'body': body,
        'type': type,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
      });
    } catch (e) {
      print("Error sending notification: $e");
    }
  }
}
