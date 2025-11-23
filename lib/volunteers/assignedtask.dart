import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Assignedtask extends StatelessWidget {
  const Assignedtask({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
     body:  Column(
        children: [
          Text(" Tastk "),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('charity')
                  .where('assigned', isEqualTo: user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No tasks assigned.'));
                }
                final charity=snapshot.data!.docs;
                    return ListView.builder(
                      itemCount:charity.length ,
                      itemBuilder: (context, index) {
                        final doc = charity[index];
                      final data = doc.data() as Map<String, dynamic>?;

                      // Safely access fields with null checks
                      final purpose =
                          data?['purpose'] as String? ?? 'No purpose';
                      final description =
                          data?['description'] as String? ?? 'No description';
                      final amount =
                          data?['goal_amount'] as String? ?? 'No amount';
                      final date = data?['deadline'] as String? ?? 'No date';
                      final status = data?['status'];
                      final assign=data?['assigned'];
                      return Card(
                         margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.blue,
                            size: 40,
                          ),
                          title: Text(
                            purpose,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Description: $description'),
                              Text('Goal Amount: $amount'),
                              Text('Date: $date'),
                              SizedBox(height: 10),
                              Row(
                                children: status == 'processing'
                                    ? [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Implement verify logic (e.g., update Firestore)
                                            FirebaseFirestore.instance
                                                .collection('charity')
                                                .doc(doc.id)
                                                .update({
                                              'status': 'approved'
                                            }).then((_) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('Project verified')),
                                                );
                                              }
                                            }).catchError((error) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                          Text('Error: $error')),
                                                );
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Verify'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Implement reject logic
                                            FirebaseFirestore.instance
                                                .collection('charity')
                                                .doc(doc.id)
                                                .update({
                                              'status': 'rejected'
                                            }).then((_) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content:
                                                          Text('Project rejected')),
                                                );
                                              }
                                            }).catchError((error) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content:
                                                          Text('Error: $error')),
                                                );
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Reject'),
                                        ),
                                      ]
                                    : [],
                              )
                            ]
                          )
                      ));
                      });
              },
            ),
          )
        ],
      ),
    );
  }
}