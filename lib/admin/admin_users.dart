import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade700,
          foregroundColor: Colors.white,
          title: const Text('User Management', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Donors'),
              Tab(text: 'Organizations'),
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
          child: TabBarView(
            children: [
              _buildDonorsList(),
              _buildOrganizationsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDonorsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Donors registered yet.'));
        }

        final users = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final doc = users[index];
            final data = doc.data() as Map<String, dynamic>;
            final name = data['name'] ?? 'N/A';
            final email = data['email'] ?? 'N/A';
            final phone = data['phone'] ?? 'N/A';
            final imageurl = data['imageurl'] as String?;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('login').doc(doc.id).get(),
              builder: (context, loginSnapshot) {
                final loginData = loginSnapshot.data?.data() as Map<String, dynamic>?;
                final currentRole = loginData?['role'] ?? 'user';
                final bool isDisabled = currentRole == 'disabled';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: imageurl != null && imageurl.trim().isNotEmpty
                          ? NetworkImage("https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/$imageurl")
                          : const NetworkImage('https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Picture.png') as ImageProvider,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('Email: $email\nPhone: $phone'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isDisabled ? Icons.play_arrow : Icons.block,
                            color: isDisabled ? Colors.green : Colors.orange,
                          ),
                          tooltip: isDisabled ? 'Enable User' : 'Disable User',
                          onPressed: () => _toggleUserStatus(doc.id, currentRole, context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete User',
                          onPressed: () => _deleteUser(doc.id, 'users', context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildOrganizationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('organization').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Organizations registered yet.'));
        }

        final orgs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orgs.length,
          itemBuilder: (context, index) {
            final doc = orgs[index];
            final data = doc.data() as Map<String, dynamic>;
            final name = data['name'] ?? 'N/A';
            final email = data['email'] ?? 'N/A';
            final phone = data['phone'] ?? 'N/A';
            final verified = data['verfiedby'] ?? 'null';
            final imageurl = data['imageurl'] as String?;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('login').doc(doc.id).get(),
              builder: (context, loginSnapshot) {
                final loginData = loginSnapshot.data?.data() as Map<String, dynamic>?;
                final currentRole = loginData?['role'] ?? 'org';
                final bool isDisabled = currentRole == 'disabled';

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: imageurl != null && imageurl.trim().isNotEmpty
                          ? NetworkImage("https://ygnoqrlyolmswdzsmbdu.supabase.co/storage/v1/object/public/images/$imageurl")
                          : const NetworkImage('https://cdn-icons-png.freepik.com/512/7486/7486692.png') as ImageProvider,
                    ),
                    title: Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: isDisabled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text('Email: $email\nPhone: $phone\nVerified: $verified'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (verified == 'admin')
                          IconButton(
                            icon: Icon(
                              isDisabled ? Icons.play_arrow : Icons.block,
                              color: isDisabled ? Colors.green : Colors.orange,
                            ),
                            tooltip: isDisabled ? 'Enable Org' : 'Disable Org',
                            onPressed: () => _toggleUserStatus(doc.id, currentRole, context),
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete Org',
                          onPressed: () => _deleteUser(doc.id, 'organization', context),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _toggleUserStatus(String uid, String currentRole, BuildContext context) async {
    try {
      String newRole = 'disabled';
      if (currentRole == 'disabled') {
        // Find correct role
        final docOrg = await FirebaseFirestore.instance.collection('organization').doc(uid).get();
        newRole = docOrg.exists ? 'org' : 'user';
      }

      await FirebaseFirestore.instance.collection('login').doc(uid).update({'role': newRole});

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User status updated to ${newRole == 'disabled' ? 'Disabled' : 'Enabled'}.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteUser(String uid, String collection, BuildContext context) async {
    try {
      // 1. Delete from users/organization collection
      await FirebaseFirestore.instance.collection(collection).doc(uid).delete();
      // 2. Delete from login collection
      await FirebaseFirestore.instance.collection('login').doc(uid).delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
