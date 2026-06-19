import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminReportsScreen extends StatelessWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Reports & Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
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
          stream: FirebaseFirestore.instance.collection('transactions').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final txns = snapshot.data?.docs ?? [];
            double totalRaised = 0.0;
            int successfulTxns = 0;
            int refundedTxns = 0;
            Map<String, double> categorySums = {};

            for (var doc in txns) {
              final data = doc.data() as Map<String, dynamic>;
              final status = data['status'] ?? 'success';
              final amount = (data['amount'] ?? 0.0) as double;

              if (status == 'success') {
                totalRaised += amount;
                successfulTxns++;
              } else if (status == 'refunded') {
                refundedTxns++;
              }
            }

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('charity').snapshots(),
              builder: (context, charitySnapshot) {
                final charities = charitySnapshot.data?.docs ?? [];
                
                // Group collected amounts by category
                for (var doc in charities) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data['status'] ?? '';
                  if (status == 'approved') {
                    final cat = data['category'] ?? 'General Charity';
                    final col = (data['collected_amount'] ?? 0.0) as double;
                    categorySums[cat] = (categorySums[cat] ?? 0.0) + col;
                  }
                }

                // If empty, fill with default values
                if (categorySums.isEmpty) {
                  categorySums = {
                    'Medical & Healthcare': 0.0,
                    'Education': 0.0,
                    'Disaster Relief': 0.0,
                    'General Charity': 0.0,
                  };
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Financial Summary',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Total Funds Raised',
                              value: '₹${totalRaised.toStringAsFixed(0)}',
                              icon: Icons.monetization_on,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Active Campaigns',
                              value: '${charities.where((d) => d['status'] == 'approved').length}',
                              icon: Icons.volunteer_activism,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Successful Donations',
                              value: '$successfulTxns',
                              icon: Icons.check_circle,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              title: 'Refunded Transactions',
                              value: '$refundedTxns',
                              icon: Icons.undo,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Donations by Category',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: categorySums.entries.map((entry) {
                              final double catAmount = entry.value;
                              final double pct = totalRaised > 0 ? (catAmount / totalRaised) : 0.0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '₹${catAmount.toStringAsFixed(0)} (${(pct * 100).toStringAsFixed(1)}%)',
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: pct,
                                        minHeight: 8,
                                        backgroundColor: Colors.teal.shade50,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
