import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ViewNews extends StatefulWidget {
  const ViewNews({super.key});

  @override
  State<ViewNews> createState() => _ViewNewsState();
}

class _ViewNewsState extends State<ViewNews> {
  @override
  Widget build(BuildContext context) {
    bool islike=false;
    return Scaffold(
        
      appBar: AppBar(
        title: Text("NEWS"),
        backgroundColor: const Color.fromARGB(255, 58, 164, 183),
      ),
      body: StreamBuilder(
          stream:  FirebaseFirestore.instance
              .collection('news')
              .where("verify", isEqualTo: "approved")
            // .orderBy("date",descending: true)
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
            final data = snapshot.data!.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final news = data[index].data();
                  var userlike;
                   final userId = FirebaseAuth.instance.currentUser!.uid;
                          final likes = List<String>.from(news['like'] ?? []);
                          
                            userlike = likes.contains(userId) ? true : false;
                         
                             print(userlike);
                  return Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      title: Text(news['title'].toString().toUpperCase() ?? 'No Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          news['description'] ?? 'No Description',
                          style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Row(
                          children: [
                            const Icon(Icons.person,
                              size: 16, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Text(
                            news['user'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 13, color: Colors.blueGrey),
                            ),
                          ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                          children: [
                            const Icon(Icons.verified,
                              size: 16, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                            'Status: ${news['verify'] ?? 'pending'}',
                            style: TextStyle(
                              fontSize: 13,
                              color: news['verify'] == 'approved'
                                ? Colors.green
                                : Colors.orange,
                            ),
                            ),
                          ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                          children: [
                            const Icon(Icons.calendar_today,
                              size: 16, color: Colors.deepPurple),
                            const SizedBox(width: 4),
                            Text(
                            news['date'] != null
                              ? "${(news['date'] as Timestamp).toDate().day.toString().padLeft(2, '0')}-"
                                "${(news['date'] as Timestamp).toDate().month.toString().padLeft(2, '0')}-"
                                "${(news['date'] as Timestamp).toDate().year} ,"
                                "${(news['date'] as Timestamp).toDate().hour.toString().padLeft(2, '0')}:"
                                "${(news['date'] as Timestamp).toDate().minute.toString().padLeft(2, '0')}:"
                                "${(news['date'] as Timestamp).toDate().second.toString().padLeft(2, '0')}"
                              : 'Unknown',
                            style: const TextStyle(
                              fontSize: 13, color: Colors.deepPurple),
                            ),
                          ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                          children: [
                            IconButton(
                            onPressed: () {
                              if (!likes.contains(userId)) {
                              FirebaseFirestore.instance
                                .collection("news")
                                .doc(data[index].id)
                                .update({
                                "like": FieldValue.arrayUnion([userId])
                              });
                              } else {
                              FirebaseFirestore.instance
                                .collection("news")
                                .doc(data[index].id)
                                .update({
                                "like": FieldValue.arrayRemove([userId])
                              });
                              }
                            },
                            icon: userlike == true
                              ? Stack(
                                children: [
                                  Icon(Icons.thumb_up,
                                    color: Colors.black, size: 28),
                                  Positioned(
                                    child: Icon(Icons.thumb_up,
                                      color: const Color.fromARGB(255, 45, 84, 213),
                                      size: 24))
                                ],
                                )
                              : Stack(
                                children: [
                                  Icon(Icons.thumb_up,
                                    color: const Color.fromARGB(
                                      255, 0, 0, 0),
                                    size: 28),
                                  Positioned(
                                    child: Icon(Icons.thumb_up,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      size: 24))
                                ],
                                ),
                            ),
                            SizedBox(width: 8),
                            Text(
                            '${likes.length} likes',
                            style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                            ),
                          ],
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
