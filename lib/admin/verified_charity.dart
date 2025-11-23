import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VerifiedCharity extends StatelessWidget {
  const VerifiedCharity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("Pending Charity Details"),
        backgroundColor: const Color.fromARGB(255, 58, 164, 183),
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("charity")
                  .where('status', isEqualTo: 'approved')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Lottie.network(
                        'https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json',
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Data"));
                }
                final project = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: project.length,
                  itemBuilder: (context, index) {
                    final doc = project[index];
                     final data = doc.data() as Map<String, dynamic>?;
                    final String description=data?['description'];
                    final purpose =
                          data?['purpose'] as String? ?? 'No purpose';
                      final amount =
                          data?['goal_amount'] as String? ?? 'No amount';
                      final date = data?['deadline'] as String? ?? 'No date';
                      final status = data?['status'];
                      final assign=data?['assigned'];
                    return Card(
                      
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.volunteer_activism,
                          color: Colors.blue,
                        ),
                        subtitle: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Description: $description'),
                              Text('Goal Amount: $amount'),
                              Text('Date: $date'),
                              Text(status,style: TextStyle(color: Colors.green),),
                              Text("Needed date $date"),
                              SizedBox(height: 10),]
                        ),
                      ),
                    );
                  },
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
