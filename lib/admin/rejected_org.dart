import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RejectedOrg extends StatelessWidget {
  const RejectedOrg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 245, 188, 66), Color.fromARGB(255, 37, 210, 25)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
          ),
        ),
        title: Row(
          children: [
        const Icon(Icons.verified, color: Colors.white),
        const SizedBox(width: 10),
        Text(
          "Verify Organizations",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('organization')
            .where('verfiedby', isEqualTo: "rejected by admin")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No pending news"));
          }

          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text(data['email'] ?? 'No Email'),
              );
            },
          );
        },
      ),
    );
  }
}