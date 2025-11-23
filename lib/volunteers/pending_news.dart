import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PendingNews extends StatelessWidget {
  const PendingNews({super.key});

  @override
  Widget build(BuildContext context) {
    final userid=FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text("Approval Pending News"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("news")
              .where("id", isEqualTo: userid)
             .where("verify", isEqualTo: "pending")
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
            final data=snapshot.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context,index){
                final news=data[index].data();
                
                return Card(
                child: ListTile(
                  title: Text(news['title'].toString().toUpperCase() ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news['description'] ?? ''),
                      SizedBox(height: 8),
                      Text(
                        "Status: ${news['verify'] ?? 'pending'}",
                        style: TextStyle(
                          color: (news['verify'] == 'pending')
                              ? Colors.orange
                              : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Date: ${news['date'] != null ? (news['date'] as Timestamp).toDate().toString().substring(0, 16) : ''}",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                 
                ),
                );
            });
          }),
    );
  }
}
