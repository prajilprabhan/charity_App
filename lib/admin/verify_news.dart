import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class VerifyNews extends StatelessWidget {
  const VerifyNews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Verification"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("news")
            .where('verify', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(), // Replaced Lottie with simpler loader
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending news"));
          }

          final data = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true, // Ensure ListView takes only needed space
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];
              final title = doc['title'] as String;
              final desc = doc['description'] as String;
                final docid = doc.id;
                final id =doc['id'];
              final date = (doc['date'] as Timestamp?)?.toDate();
              final formattedDate = date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : 'No date';

              return Card(
                key: ValueKey(docid), // Unique key for each item
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: const Icon(Icons.newspaper, color: Colors.blue),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(desc),
                      const SizedBox(height: 4),
                      Text("ID: $id"),
                      Text("Date: $formattedDate"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          // Implement approve logic
                          FirebaseFirestore.instance
                              .collection("news")
                              .doc(docid)
                              .update({'verify': 'approved'});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          // Implement reject logic
                          FirebaseFirestore.instance
                              .collection("news")
                              .doc(docid)
                              .update({'verify': 'rejected'});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}