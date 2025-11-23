import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seechange/about.dart';
import 'package:seechange/admin/add_news.dart';
import 'package:seechange/admin/add_volunteer.dart';
import 'package:seechange/admin/pending.dart';
import 'package:seechange/admin/rejected_org.dart';
import 'package:seechange/admin/rejectedcharity.dart';
import 'package:seechange/admin/taskassign.dart';
import 'package:seechange/admin/verified_charity.dart';
import 'package:seechange/admin/verify_news.dart';
import 'package:seechange/admin/verify_org.dart';
import 'package:seechange/admin/view_news.dart';
import 'package:seechange/admin/view_org.dart';
import 'package:seechange/admin/view_volunteers.dart';
import 'package:seechange/login.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Admin',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      drawer: Drawer( 
        backgroundColor: Colors.teal.shade600, // Primary color
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
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                 
                ],
              ),
            ),
            ExpansionTile(
              leading: const Icon(Icons.people, color: Colors.white),
              title: const Text(
              'Volunteers',
              style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              children: [
              ListTile(
                title: const Text(
                'View Volunteers',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                leading: const Icon(Icons.visibility, color: Colors.white70),
                onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>VolunteersList()));// Close drawer
               
                },
              ),
              ListTile(
                title: const Text(
                'Add Volunteer',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                leading: const Icon(Icons.person_add, color: Colors.white70),
                onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => const AddVolunteer(),
                  ),
                );
                },
              ),
              ],
            ),
            ExpansionTile(
              title: const Text("Organization",style: TextStyle(color: Colors.white, fontSize: 16),),
              leading: const Icon(Icons.business, color: Colors.white),
                children: [
                ListTile(
                  leading: const Icon(Icons.verified_user, color: Colors.white70),
                  title: const Text(
                  "Verify Organization",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () {
                  Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOrg()));
                  // TODO: Implement verify organization navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.hourglass_top, color: Colors.white70),
                  title: const Text(
                  "Pending Verification",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement pending verification navigation
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.apartment, color: Colors.white70),
                  title: const Text(
                  "View Organizations",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOrg()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.white70),
                  title: const Text(
                  "Rejected Organization",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  onTap: () {
                  Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context)=>RejectedOrg()));
                
                  // TODO: Implement rejected organization navigation
                  },
                ),
                ],
              
            )
            ,
            ExpansionTile(
              leading: Icon(Icons.handshake, color: Colors.white),
              title: Text("Charity",style: TextStyle(color: Colors.white, fontSize: 16),),
              children: [
                ListTile(
                  title: Text("Verifiy Charity",style: TextStyle(color: Colors.white70, fontSize: 14),),
                  leading: Icon(Icons.assignment, color: Colors.white),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Taskassign()));
                  },
                ),
                ListTile(
                  title: Text("Pending Charity",style: TextStyle(color: Colors.white70, fontSize: 14),),
                    leading: Icon(Icons.hourglass_empty, color: Colors.white),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PendingProjects()));
                  },
                ),
                ListTile(
                  title: Text("Verified Charity",style: TextStyle(color: Colors.white70, fontSize: 14),),
                    leading: Icon(Icons.verified, color: Colors.white),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifiedCharity()));
                  },
                ),
                ListTile(
                  title: Text("Rejected Charity",style: TextStyle(color: Colors.white70, fontSize: 14),),
                  leading: Icon(Icons.close_rounded, color: Colors.white),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Rejectedcharity()));
                  },
                ),

              ],),
            
            ExpansionTile(
              leading: const Icon(Icons.newspaper, color: Colors.white),
              title: const Text(
              'News',
              style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              children: [
              ListTile(
                leading: const Icon(Icons.verified, color: Colors.white70),
                title: const Text(
                'Verify News',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyNews()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.add, color: Colors.white70),
                title: const Text(
                'Add News',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AddNews()));
               
                // TODO: Implement Add News navigation
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility, color: Colors.white70),
                title: const Text(
                'View News',
                style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ViewNews()));
               
                // TODO: Implement View News navigation
                },
              ),
              ],
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text(
                'Reports',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reports page coming soon!')),
                );
              },
            ),
             Divider(),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings page coming soon!')),
                );
              },
            ),
            
              ListTile(
                   leading: Icon(Icons.info_outline_rounded, color: Colors.white),
                   title: Text("About Us", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
                   },
                   ),
            const Divider(color: Colors.white24),
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
                    // Network image for logo or banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://thumbs.dreamstime.com/b/young-dark-haired-business-woman-desk-working-laptop-computer-office-space-vector-illustration-secretary-workspace-208615179.jpg',
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
                      'Admin Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Manage your volunteers with ease',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddVolunteer(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
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
                            Icon(Icons.person_add, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add New Volunteer',
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