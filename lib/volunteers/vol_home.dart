import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:seechange/about.dart';
import 'package:seechange/admin/pending.dart';
import 'package:seechange/admin/view_news.dart';
import 'package:seechange/admin/view_org.dart';
import 'package:seechange/firstpage.dart';
import 'package:seechange/login.dart';
import 'package:seechange/volunteers/accepted_news.dart';
import 'package:seechange/volunteers/assignedtask.dart';
import 'package:seechange/volunteers/pending_news.dart';
import 'package:seechange/volunteers/voladdnews.dart';

class VolunteerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Volunteer Hub',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      drawer: Drawer(
        backgroundColor:Colors.teal.shade600, // Primary color
        child: ListView(
          padding: EdgeInsets.zero,
            children: [
            DrawerHeader(
              decoration: const BoxDecoration(
             color: Colors.teal, // Slightly darker accent
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                  const Text(
                    'Volunteers Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
               
                 
                ],
                
              ),
            ),
            ListTile(
                     leading: Icon(Icons.assignment_turned_in, color: Colors.white70),
                  title: Text("Task",style: TextStyle(color: Colors.white70, fontSize: 14),),
                  onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const Assignedtask(),
                  ),
                );
                },
                 ),
                 Divider(),
                  ListTile(
                    leading: Icon(Icons.business, color: Colors.white),
                    title: Text("Organization", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    onTap: () {
                        Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewOrg()));
                  
                    // TODO: Navigate to Organization page
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.volunteer_activism, color: Colors.white70),
                    title: Text("Charity", style: TextStyle(color: Colors.white70, fontSize: 14)),
                    onTap: () {
                       Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PendingProjects()));
                   
                    // TODO: Navigate to Charity page
                    },
                  ),
                 Divider(),
                 ExpansionTile(
                   leading: Icon(Icons.newspaper, color: Colors.white70),
                   title: Text("News", style: TextStyle(color: Colors.white70, fontSize: 14)),
                   children: [
                   ListTile(
                   leading: Icon(Icons.add, color: Colors.white70),
                   title: Text("Add News", style: TextStyle(color: Colors.white70, fontSize: 14)),
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>Volnews()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.pending_actions, color: Colors.white70),
                   title: Text("Pending News", style: TextStyle(color: Colors.white70, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PendingNews()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.check_circle, color: Colors.white70),
                   title: Text("Accepted News", style: TextStyle(color: Colors.white70, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>AcceptedNews()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.article, color: Colors.white70),
                   title: Text("All News", style: TextStyle(color: Colors.white70, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNews()));
                   },
                   ),
                   ],
                 ),
                 Divider(),
                 
              ListTile(
                   leading: Icon(Icons.info_outline_rounded, color: Colors.white),
                   title: Text("About Us", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
                   },
                   ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                // TODO: Implement logout logic (e.g., clear auth, navigate to login)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out!')),
                );
              },
            ),
                 Divider(),

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Network image for banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://media.istockphoto.com/vectors/illustration-of-a-group-of-volunteers-packing-food-to-deliver-to-in-vector-id1227597644?k=20&m=1227597644&s=612x612&w=0&h=wMZiyRn-XMs2_NKMWKOIxcANzJkdnQQdOoPBT0OMwr4=',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: const Center(child: Text('Image failed to load')),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Volunteer Hub',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Join us in making a difference!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: () {
                          // Placeholder for future navigation or action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Explore volunteer opportunities!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:Colors.teal.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.volunteer_activism, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Get Involved',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}