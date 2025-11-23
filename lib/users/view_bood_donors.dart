import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ViewBoodDonors extends StatelessWidget {
  const ViewBoodDonors({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.home),
            SizedBox(width: 8),
            Text(
              'Blod Donors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                final doner = data[index].data();
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Card(
                    elevation: 20,
                    child: ListTile(
                      leading: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.water_drop, color: Colors.red, size: 40),
                          Text(
                            doner['blood'] ?? '66',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              shadows: [
                                Shadow(
                                  blurRadius: 2,
                                  color: Colors.black,
                                  offset: Offset(0.5, 0.5),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      title: Text(doner['name'].toString().toUpperCase()),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Address: ${doner['address'] ?? 'N/A'}\n"
                            "        ${doner['post'] ?? ''}\n"
                            "        PIN: ${doner['pin'] ?? ''}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text("Gender :${doner['gender']}"),
                          Text("email :${doner['email']}"),
                          Text("Phone :${doner['phone']}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
