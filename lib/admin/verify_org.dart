import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifyOrg extends StatelessWidget {
  const VerifyOrg({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('organization').where('verfiedby' ,isEqualTo: "null" ).snapshots(), builder: (context,snapshot){
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
            
            return ListView.builder(
            
              itemCount:snapshot.data!.docs.length ,
              itemBuilder: (context,index){
      
                final data=snapshot.data!.docs[index] ;
                  final orgname = data["name"];
                  final email = data["email"];
                  final phone = data["phone"];
                  final place = data["place"];
                  final post = data["post"];
                  final pin = data["pin"];
                  final district = data["district"];
                    final Timestamp? createdAtTimestamp = data["created at"];
                    final createdAt = createdAtTimestamp != null
                      ? DateTime.fromMillisecondsSinceEpoch(
                        createdAtTimestamp.millisecondsSinceEpoch)
                      : null;
                    final createdAtStr = createdAt != null
                      ? "${createdAt.day.toString().padLeft(2, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.year} ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}"
                      : '';
                  final imageUrl = data["imageurl"];
                  final verified = data["verfiedby"];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: const Color.fromARGB(255, 222, 228, 222),
                    child: ListTile(
                      leading: GestureDetector(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage("https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/$imageUrl"),
                       
                        ),
                        onTap: (){
                         showDialog(
                  
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: InteractiveViewer(
                                        child: CircleAvatar(
                                          radius: 200,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: NetworkImage(
                                              "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${imageUrl}"),
                                        ),
                                      ),
                                    ),
                                  );
                        },
                      )
                        ,
                      title: Text(orgname ?? 'No Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text('Email: ${email ?? ''}'),
                        Text('Phone: ${phone ?? ''}'),
                        Text('Place: ${place ?? ''}'),
                        Text('Post: ${post ?? ''}'),
                        Text('Pin: ${pin ?? ''}'),
                        Text('District: ${district ?? ''}'),
                        Text('Created At: ${createdAt ?? ''}'),
                        Text('Verified: ${verified == true ? "Yes" : "No"}'),
                          Row(
                          children: [
                            Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                              // Approve organization
                              await FirebaseFirestore.instance
                                .collection('organization')
                                .doc(data.id)
                                .update({'verfiedby': 'admin'});
                                  await FirebaseFirestore.instance.collection("login").doc(data.id)
                                .update({"role":"org"});
                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size.fromHeight(40),
                              ),
                              child: const Text('Approve'),
                            ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                              // Reject organization
                              await FirebaseFirestore.instance
                                .collection('organization')
                                .doc(data.id)
                                .update({'verfiedby': 'rejected by admin'});
                              
                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size.fromHeight(40),
                              ),
                              child: const Text('Reject'),
                            ),
                            ),
                          ],
                          ),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
            });
      
      }),
    );
  }
}