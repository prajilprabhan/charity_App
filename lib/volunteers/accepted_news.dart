import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AcceptedNews extends StatelessWidget {
  const AcceptedNews({super.key});

  @override
  Widget build(BuildContext context) {
    final userid=FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('news')
                .where("verify", isEqualTo: "approved")
                .where("id", isEqualTo: userid)
              .snapshots(),
          builder: (context,snapshot){
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
              itemBuilder:(context,index){
                final news=data[index].data();
                var userlike;
                 final likes = List<String>.from(news['like'] ?? []);
                 userlike = likes.contains(userid) ? true : false;
                 return Card(
                  child: ListTile(
                    title: Text(news['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(news['description'] ?? ''),
                        SizedBox(height: 8),
                        if (news['verify'] == 'approved')
                          Text(
                          'Status: Approved',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                          ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                userlike ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                color: userlike ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () async {
                                final docRef = FirebaseFirestore.instance
                                    .collection('news')
                                    .doc(data[index].id);
                                if (userlike) {
                                  await docRef.update({
                                    'like': FieldValue.arrayRemove([userid])
                                  });
                                } else {
                                  await docRef.update({
                                    'like': FieldValue.arrayUnion([userid])
                                  });
                                }
                              },
                            ),
                            Text('${likes.length}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                 );
            } );
          }),
    );
  }
}
