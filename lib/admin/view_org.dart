import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ViewOrg extends StatelessWidget {
  const ViewOrg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Organization"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("organization")
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
                final org = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: org.length,
                  itemBuilder: (context, index) {
                    final doc = org[index];
                     final data = doc.data() as Map<String, dynamic>?;
                   final name=data?['name'].toString().toUpperCase();
                   final email =data?['email'];
                  final phone = data?['phone'] ?? '';
                  final place = data?['place'] ?? '';
                  final post = data?['post'] ?? '';
                  final district = data?['district'] ?? '';
                  final image = data?['imageurl'] ?? '';
                 print(image);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                      child: ListTile(
                      leading: GestureDetector(
                        onTap: (){
                          showDialog(
              
                                context: context,
                                builder: (context) => Dialog(
                                  child: InteractiveViewer(
                                    child: CircleAvatar(
                                      radius: 200,
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(
                                          "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${image}"),
                                    ),
                                  ),
                                ),
                              );
                        },
                        child:  CircleAvatar(
                            minRadius: 40,
                            maxRadius: 50,
                          backgroundImage: NetworkImage( "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/${image}"),
                          ),
                      )
                        
                        ,
                      title: Text(name ?? 'No Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const SizedBox(height: 8),
                        Text('Email: $email'),
                        Text('Phone: $phone'),
                        Text('Place: $place'),
                        Text('Post: $post'),
                        Text('District: $district'),
                        ],
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
