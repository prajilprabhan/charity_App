import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seechange/admin/view_news.dart';
import 'package:seechange/users/view_bood_donors.dart';
import 'package:seechange/users/notifications_screen.dart';
import 'package:seechange/users/donation_history.dart';
import 'package:seechange/users/charity_detail.dart';
import 'package:seechange/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Medical & Healthcare',
    'Education',
    'Disaster Relief',
    'Hunger & Food',
    'Shelter & Housing',
    'General Charity',
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.home),
            SizedBox(width: 8),
            Text(
              'HOME',
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
      drawer: Drawer(
        backgroundColor: Colors.teal.shade600,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Text(
                      'Error loading user data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.teal),
                    child: Text(
                      'User not found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final userName = userData['name'] ?? 'Anonymous';

                return DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.teal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome, $userName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bloodtype_rounded, color: Colors.white),
              title: const Text("Blood Donors", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewBoodDonors()));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.3)),
            ListTile(
              leading: const Icon(Icons.newspaper, color: Colors.white),
              title: const Text("News", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewNews()));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.3)),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text("Notifications", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.3)),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.white),
              title: const Text("My Donations", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DonationHistoryScreen()));
              },
            ),
            Divider(color: Colors.white.withOpacity(0.3)),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out!')),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Category filter chips
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.teal.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.teal.shade600,
                      backgroundColor: Colors.teal.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.teal.shade100),
                      ),
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            // Active charity campaigns list
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedCategory == 'All'
                    ? FirebaseFirestore.instance
                        .collection('charity')
                        .where('status', isEqualTo: 'approved')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('charity')
                        .where('status', isEqualTo: 'approved')
                        .where('category', isEqualTo: selectedCategory)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No active charity campaigns found.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  final campaigns = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: campaigns.length,
                    itemBuilder: (context, index) {
                      final doc = campaigns[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final purpose = data['purpose'] ?? 'No Purpose';
                      final desc = data['description'] ?? 'No Description';
                      final targetStr = data['goal_amount'] ?? '0';
                      final target = double.tryParse(targetStr) ?? 0.0;
                      final collected = (data['collected_amount'] ?? 0.0) as double;
                      final deadline = data['deadline'] ?? 'No Deadline';
                      final category = data['category'] ?? 'General Charity';
                      final imageUrl = data['imageurl'] as String?;

                      final double progress = target > 0 ? (collected / target).clamp(0.0, 1.0) : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (imageUrl != null && imageUrl.trim().isNotEmpty)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  "https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/$imageUrl",
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 160,
                                    color: Colors.grey.shade200,
                                    width: double.infinity,
                                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Icon(Icons.volunteer_activism, color: Colors.teal.shade700, size: 48),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal.shade700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    purpose,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    desc,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(height: 14),
                                  // Progress
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Raised: ₹${collected.toStringAsFixed(0)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                                      ),
                                      Text(
                                        'Goal: ₹${target.toStringAsFixed(0)}',
                                        style: TextStyle(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 6,
                                      backgroundColor: Colors.teal.shade50,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${(progress * 100).toStringAsFixed(0)}% Raised',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Deadline: $deadline',
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CharityDetailScreen(charityDoc: doc),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal.shade600,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'View Details & Donate',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
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