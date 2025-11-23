import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seechange/volunteers/vol_home.dart';

class Taskassign extends StatelessWidget {
  const Taskassign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.back_hand)),
        title: const Text('Charity Projects'),
        backgroundColor: Colors.blueAccent, // Match your app's theme
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Charity Projects',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              // Constrain the StreamBuilder's ListView.builder
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('charity')
                    .where('assigned', isEqualTo: "null")
                    .snapshots(),
                builder: (context, snapshot) {
                  // Loading state
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
                  // Error state
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  // No data state
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No charity projects found'));
                  }

                  // Data available
                  final charity = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: charity.length,
                    itemBuilder: (context, index) {
                      final doc = charity[index];
                      final data = doc.data() as Map<String, dynamic>?;

                      // Safely access fields with null checks
                      final purpose =
                          data?['purpose'] as String? ?? 'No purpose';
                      final description =
                          data?['description'] as String? ?? 'No description';
                      final amount =
                          data?['goal_amount'] as String? ?? 'No amount';
                      final date = data?['date'] as String? ?? 'No date';
                      final status = data?['status'];
                      final assign=data?['assigned'];

                      return Card(
                        // Use Card for better UI
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.volunteer_activism,
                            color: Colors.blue,
                            size: 40,
                          ),
                          title: Text(
                            purpose,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text('Description: $description'),
                              Text('Goal Amount: $amount'),
                              Text('Date: $date'),
                              SizedBox(height: 10),
                              Row(
                                children: () {
                                  if (status == 'pending') {
                                    return [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement verify logic (e.g., update Firestore)
                                          FirebaseFirestore.instance
                                              .collection('charity')
                                              .doc(doc.id)
                                              .update({
                                            'status': 'processing'
                                          }).then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Project verified')),
                                            );
                                          }).catchError((error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text('Error: $error')),
                                            );
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Verify'),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Implement reject logic
                                          FirebaseFirestore.instance
                                              .collection('charity')
                                              .doc(doc.id)
                                              .update({
                                            'status': 'rejected'
                                          }).then((_) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content:
                                                      Text('Project rejected')),
                                            );
                                          }).catchError((error) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content:
                                                      Text('Error: $error')),
                                            );
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Reject'),
                                      ),
                                    ];
                                  } else if (status == 'processing') {
                                    return [
                                      Column(
                                        children: [
                                          Text(
                                            'Processing',
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12),
                                          ),
                                          FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('volunteers')
                                                  .get(),
                                              builder: (context, snpashot1) {
                                                if (snpashot1.connectionState ==
                                                    ConnectionState.waiting) {
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
                                                // Error state
                                                if (snpashot1.hasError) {
                                                  return Center(
                                                      child: Text(
                                                          'Error: ${snpashot1.error}'));
                                                }
                                                // No data state
                                                if (!snapshot.hasData ||
                                                    snpashot1
                                                        .data!.docs.isEmpty) {
                                                  return const Center(
                                                      child: Text(
                                                          'No volunteers  found'));
                                                }
                                               final volunteers = snpashot1.data!.docs;
                                               if(assign=='null'){
                                              return DropdownButton<String>(
                                                hint: const Text('Assign Volunteer'),
                                                
                                                items: volunteers.map<DropdownMenuItem<String>>((volDoc) {
                                                  final vData = volDoc.data() ;
                                                  final name = vData['name'] ?? 'No Name';
                                                  return DropdownMenuItem<String>(
                                                    value: volDoc.id,
                                                    child: Text(name),
                                                  );
                                                }).toList(),
                                                onChanged: (selectedVolunteerId) {
                                                   print(selectedVolunteerId);
                                                    FirebaseFirestore.instance
                                                        .collection('charity')
                                                        .doc(doc.id)
                                                        .update({'assigned': selectedVolunteerId}).then((_) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(content: Text('Volunteer assigned')),
                                                      );
                                                      print(doc.id);
                                                    }).catchError((error) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('Error: $error')),
                                                      );
                                                    });
                                                  
                                                },
                                              );
                                               }
                                               else{
                                                 return Text("assigned by ${data?['verfiedby'] ?? 'Unknown'}");
                                               }
                                                // final volunteers=snapshot.docs.
                                              })
                                        ],
                                      ),
                                    ];
                                  } else {
                                    return [
                                      Text(
                                        'Rejected',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    ];
                                  }
                                }(),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
