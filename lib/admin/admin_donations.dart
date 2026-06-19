import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seechange/services/notification_service.dart';

class AdminDonationsScreen extends StatelessWidget {
  const AdminDonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Transaction Management', style: TextStyle(fontWeight: FontWeight.bold)),
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
              .orderBy('timestamp', descending: true)
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
                child: Text(
                  'No transactions recorded yet.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final transactions = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final doc = transactions[index];
                final data = doc.data() as Map<String, dynamic>;
                final charityName = data['charityName'] ?? 'Charity Campaign';
                final donorName = data['donorName'] ?? 'Anonymous';
                final donorId = data['donorId'] ?? '';
                final amount = (data['amount'] ?? 0.0) as double;
                final method = data['paymentMethod'] ?? 'UPI';
                final status = data['status'] ?? 'success';
                final timestamp = data['timestamp'] as Timestamp?;
                final charityId = data['charityId'] ?? '';

                String formattedDate = '';
                if (timestamp != null) {
                  formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
                }

                final bool isSuccess = status == 'success';
                final bool isRefunded = status == 'refunded';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                charityName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            Text(
                              '₹${amount.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Donor: $donorName'),
                        Text('Method: $method'),
                        Text('Date: $formattedDate'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Status: ${status.toString().toUpperCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isRefunded ? Colors.red : (isSuccess ? Colors.green : Colors.orange),
                              ),
                            ),
                            if (isSuccess)
                              ElevatedButton.icon(
                                onPressed: () => _refundTransaction(doc.id, charityId, donorId, donorName, charityName, amount, context),
                                icon: const Icon(Icons.undo, size: 16, color: Colors.white),
                                label: const Text('Refund'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              )
                            else if (isRefunded)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.red.shade100),
                                ),
                                child: Text(
                                  'REFUNDED',
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _refundTransaction(
    String txnId,
    String charityId,
    String donorId,
    String donorName,
    String charityName,
    double amount,
    BuildContext context,
  ) async {
    try {
      // 1. Update Transaction status to refunded
      await FirebaseFirestore.instance.collection('transactions').doc(txnId).update({'status': 'refunded'});

      // 2. Fetch current collected_amount of the charity request
      final charitySnap = await FirebaseFirestore.instance.collection('charity').doc(charityId).get();
      if (charitySnap.exists) {
        final double currentCollected = (charitySnap.data()?['collected_amount'] ?? 0.0) as double;
        final String? orgId = charitySnap.data()?['organization_id'];

        // 3. Decrement Charity collected_amount
        await FirebaseFirestore.instance.collection('charity').doc(charityId).update({
          'collected_amount': (currentCollected - amount).clamp(0.0, double.infinity),
        });

        // 4. Send notification to Donor
        await NotificationService.sendNotification(
          userId: donorId,
          title: 'Donation Refunded',
          body: 'Your donation of ₹${amount.toStringAsFixed(0)} to "$charityName" has been refunded by the Admin. Txn ID: $txnId',
          type: 'rejection',
        );

        // 5. Send notification to Organization
        if (orgId != null) {
          await NotificationService.sendNotification(
            userId: orgId,
            title: 'Donation Refunded',
            body: 'A donation of ₹${amount.toStringAsFixed(0)} from $donorName to your campaign "$charityName" was refunded.',
            type: 'rejection',
          );
        }
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation refunded successfully.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refund Failed: $e')),
        );
      }
    }
  }
}
