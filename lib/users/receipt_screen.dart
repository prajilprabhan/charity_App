import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatelessWidget {
  final String transactionId;

  const ReceiptScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text('Donation Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
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
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('transactions').doc(transactionId).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('Error loading receipt details.'));
            }

            final txnData = snapshot.data!.data() as Map<String, dynamic>;
            final charityName = txnData['charityName'] ?? '';
            final donorName = txnData['donorName'] ?? '';
            final amount = (txnData['amount'] ?? 0.0) as double;
            final method = txnData['paymentMethod'] ?? 'UPI';
            final timestamp = txnData['timestamp'] as Timestamp?;
            final status = txnData['status'] ?? 'success';

            String formattedDate = '';
            if (timestamp != null) {
              formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp.toDate());
            } else {
              formattedDate = DateFormat('MMM dd, yyyy - hh:mm a').format(DateTime.now());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    const CircleAvatar(
                                      radius: 36,
                                      backgroundColor: Colors.teal,
                                      child: Icon(Icons.check, color: Colors.white, size: 40),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Payment Successful!',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Thank you for your donation!',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Divider(thickness: 1),
                              const SizedBox(height: 12),
                              _buildReceiptRow('Transaction ID', transactionId),
                              _buildReceiptRow('Date & Time', formattedDate),
                              _buildReceiptRow('Donor Name', donorName),
                              _buildReceiptRow('Charity Campaign', charityName),
                              _buildReceiptRow('Payment Method', method),
                              _buildReceiptRow('Status', status.toString().toUpperCase(), valueColor: status == 'success' ? Colors.green : Colors.orange),
                              const SizedBox(height: 12),
                              const Divider(thickness: 1),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount Paid',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '₹${amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Text(
                                  'This is a system-generated electronic receipt. No signature is required. HopeConnect values your support in bringing positive change to society.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Simulating receipt PDF sharing...')),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share Receipt'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                          icon: const Icon(Icons.home),
                          label: const Text('Go to Home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
