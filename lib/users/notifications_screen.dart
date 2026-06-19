import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_chat_read),
            tooltip: 'Mark all as read',
            onPressed: () => _markAllAsRead(currentUserId, context),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('notifications')
              .where('userId', isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No notifications yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final notifications = List<DocumentSnapshot>.from(snapshot.data!.docs);
            // Sort client-side to avoid composite index requirements
            notifications.sort((a, b) {
              final aData = a.data() as Map<String, dynamic>?;
              final bData = b.data() as Map<String, dynamic>?;
              final aTime = aData?['timestamp'] as Timestamp?;
              final bTime = bData?['timestamp'] as Timestamp?;
              if (aTime == null && bTime == null) return 0;
              if (aTime == null) return 1;
              if (bTime == null) return -1;
              return bTime.compareTo(aTime);
            });

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final doc = notifications[index];
                final data = doc.data() as Map<String, dynamic>;
                final title = data['title'] ?? 'Notification';
                final body = data['body'] ?? '';
                final isRead = data['read'] as bool? ?? false;
                final timestamp = data['timestamp'] as Timestamp?;
                final type = data['type'] ?? 'general';

                String formattedDate = '';
                if (timestamp != null) {
                  formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
                }

                IconData icon;
                Color iconColor;
                switch (type) {
                  case 'donation':
                    icon = Icons.volunteer_activism;
                    iconColor = Colors.green;
                    break;
                  case 'approval':
                    icon = Icons.check_circle;
                    iconColor = Colors.teal;
                    break;
                  case 'rejection':
                    icon = Icons.cancel;
                    iconColor = Colors.red;
                    break;
                  case 'announcement':
                    icon = Icons.campaign;
                    iconColor = Colors.orange;
                    break;
                  default:
                    icon = Icons.notifications;
                    iconColor = Colors.blue;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: isRead ? 1 : 3,
                  color: isRead ? Colors.white.withOpacity(0.85) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: iconColor.withOpacity(0.15),
                      child: Icon(icon, color: iconColor),
                    ),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(body, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                        const SizedBox(height: 6),
                        Text(formattedDate, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      ],
                    ),
                    onTap: () {
                      if (!isRead) {
                        FirebaseFirestore.instance
                            .collection('notifications')
                            .doc(doc.id)
                            .update({'read': true});
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _markAllAsRead(String userId, BuildContext context) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }
      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All notifications marked as read.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }
}
