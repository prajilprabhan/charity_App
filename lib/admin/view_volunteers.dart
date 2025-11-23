import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class VolunteersList extends StatelessWidget {
  const VolunteersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteers'),
        backgroundColor: Colors.blue, // Matches Google-inspired theme
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Volunteers List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                // Matches prior Container style
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('volunteers')
                    .orderBy('created at')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Error loading volunteers',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  Center(child:  Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No volunteers found',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  final volunteers = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: volunteers.length,
                    itemBuilder: (context, index) {
                      final volunteer =
                          volunteers[index].data() as Map<String, dynamic>;
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          leading: GestureDetector(
                            onTap: () {
                              showDialog(
              
                                context: context,
                                builder: (context) => Dialog(
                                  child: InteractiveViewer(
                                    child: CircleAvatar(
                                      radius: 200,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${volunteer['imageurl']}"),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${volunteer['imageurl']}"),
                            ),
                          ),

                          // leading: CircleAvatar(

                          //   //https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/uploads/users/1747462005319
                          //  backgroundImage: NetworkImage("https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${volunteer['imageurl']}"),
                          // ),
                          title: Text(
                            volunteer['name'] ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'name: ${volunteer['name'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Date of Birth: ${volunteer['dob'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Gender: ${volunteer['gender'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Phone: ${volunteer['phone'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Email: ${volunteer['email'] ?? 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    'Created At: ${volunteer['created at'] != null ? DateFormat('dd MMM yyyy, hh:mm a').format((volunteer['created at'] as Timestamp).toDate()) : 'N/A'}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
