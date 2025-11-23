import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:seechange/about.dart';
import 'package:seechange/admin/view_news.dart';
import 'package:seechange/login.dart';
import 'package:seechange/organization/add_charity.dart';
import 'package:seechange/organization/org_add_news.dart';

class OrgHome extends StatelessWidget {
  const OrgHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Organization',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      drawer: Drawer(
        backgroundColor: Colors.teal.shade600,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topRight: Radius.circular(30))
        ),
        child:ListView(
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
                    'Organization Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
               
                 
                ],
                
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.stacked_bar_chart_outlined,color: Colors.white,),
              title: Text("Projects",style: TextStyle(color: Colors.white, fontSize: 14),),
              children: [
                ListTile(
                  leading: Icon(Icons.add_chart,color: Colors.white,),
                  title: Text("Add Projects",style: TextStyle(color: Colors.white, fontSize: 14),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCharity()),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.details,color: Colors.white,),
                  title: Text("Project Details",style: TextStyle(color: Colors.white, fontSize: 14),),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.verified_outlined,color: Colors.white,),
                  title: Text("Approved Projects",style: TextStyle(color: Colors.white, fontSize: 14),),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.cancel_presentation,color: Colors.white,),
                  title: Text("Rejected Projects",style: TextStyle(color: Colors.white, fontSize: 14),),
                  onTap: () {},
                ),
                Divider(),
                
              ],
              
            ),

            ExpansionTile(
              leading: Icon(Icons.newspaper, color: Colors.white),
              title: Text("News", style: TextStyle(color: Colors.white, fontSize: 14)),
              children: [
                   ListTile(
                   leading: Icon(Icons.add, color: Colors.white),
                   title: Text("Add News", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>OrgAddNews()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.pending_actions, color: Colors.white),
                   title: Text("Pending News", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                   ///  Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.check_circle, color: Colors.white),
                   title: Text("Accepted News", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
                   },
                   ),
                   ListTile(
                   leading: Icon(Icons.article, color: Colors.white),
                   title: Text("All News", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNews()));
                   },
                   ),
                   
              ]
              ),
              ListTile(
                   leading: Icon(Icons.info_outline_rounded, color: Colors.white),
                   title: Text("About Us", style: TextStyle(color: Colors.white, fontSize: 14)),
                   onTap: () {
                     Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>About()));
                   },
                   ),
            ListTile(
                  leading: Icon(Icons.logout,color: Colors.white,),
                  title: Text("Logout",style: TextStyle(color: Colors.white, fontSize: 14),),
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'https://img.freepik.com/premium-vector/cartoon-corporation-donating-percentage-their-profits-charity-organization_216520-62433.jpg',
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
                    Center(
                      child: const Text(
                        'Organization Dashboard',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Manage your Projects with ease',
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
                              builder: (context) => const AddCharity(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade600,
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
                              'Add New Project',
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