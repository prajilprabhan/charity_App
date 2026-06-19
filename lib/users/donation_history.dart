import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seechange/users/receipt_screen.dart';

class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('My Donations', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .where('donorId', isEqualTo: currentUserId)
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
                    Icon(Icons.history, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'You have not made any donations yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final transactions = List<DocumentSnapshot>.from(snapshot.data!.docs);
            // Sort client-side to avoid composite index requirements
            transactions.sort((a, b) {
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
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final doc = transactions[index];
                final data = doc.data() as Map<String, dynamic>;
                final charityName = data['charityName'] ?? 'Charity Campaign';
                final amount = (data['amount'] ?? 0.0) as double;
                final method = data['paymentMethod'] ?? 'UPI';
                final status = data['status'] ?? 'success';
                final timestamp = data['timestamp'] as Timestamp?;

                String formattedDate = '';
                if (timestamp != null) {
                  formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
                }

                Color statusColor = Colors.green;
                if (status == 'refunded') {
                  statusColor = Colors.red;
                } else if (status == 'failed') {
                  statusColor = Colors.orange;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.volunteer_activism, color: Colors.white),
                    ),
                    title: Text(
                      charityName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('Method: $method | Status: ${status.toString().toUpperCase()}', 
                          style: TextStyle(fontSize: 12, color: statusColor, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(formattedDate, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    trailing: Text(
                      '₹${amount.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReceiptScreen(transactionId: doc.id),
                        ),
                      );
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
}
