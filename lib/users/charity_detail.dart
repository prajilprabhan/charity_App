import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:seechange/users/payment_screen.dart';

class CharityDetailScreen extends StatelessWidget {
  final DocumentSnapshot charityDoc;

  const CharityDetailScreen({super.key, required this.charityDoc});

  @override
  Widget build(BuildContext context) {
    final data = charityDoc.data() as Map<String, dynamic>;
    final purpose = data['purpose'] ?? 'No Purpose';
    final desc = data['description'] ?? 'No Description';
    final targetStr = data['goal_amount'] ?? '0';
    final target = double.tryParse(targetStr) ?? 0.0;
    final collected = (data['collected_amount'] ?? 0.0) as double;
    final deadline = data['deadline'] ?? 'No Deadline';
    final category = data['category'] ?? 'General Charity';
    final imageUrl = data['imageurl'] as String?;
    final orgId = data['organization_id'] as String?;

    final double progress = target > 0 ? (collected / target).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text('Campaign Details', style: TextStyle(fontWeight: FontWeight.bold)),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null && imageUrl.trim().isNotEmpty)
                Image.network(
                  "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/$imageUrl",
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: Colors.grey.shade200,
                    width: double.infinity,
                    child: const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                  ),
                )
              else
                Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.teal.shade50,
                  child: Icon(Icons.volunteer_activism, color: Colors.teal.shade700, size: 64),
                ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ),
                        Text(
                          'Deadline: $deadline',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      purpose,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress card
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Raised: ₹${collected.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                Text(
                                  'Goal: ₹${target.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 10,
                                backgroundColor: Colors.teal.shade50,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${(progress * 100).toStringAsFixed(1)}% Completed',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'About the Campaign',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      desc,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    // Host info
                    if (orgId != null)
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('organization').doc(orgId).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                            return const SizedBox.shrink();
                          }
                          final orgData = snapshot.data!.data() as Map<String, dynamic>;
                          final orgName = orgData['name'] ?? 'Organization';
                          final orgEmail = orgData['email'] ?? '';
                          final orgPhone = orgData['phone'] ?? '';
                          final orgPlace = orgData['place'] ?? '';

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.teal.shade50.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.teal.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Host Organization',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  orgName,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text('Location: $orgPlace', style: const TextStyle(fontSize: 13)),
                                Text('Contact: $orgPhone | $orgEmail', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(charityDoc: charityDoc),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Donate Now',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
