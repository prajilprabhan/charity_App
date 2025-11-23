import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:seechange/admin/admin_home.dart';
import 'package:seechange/firstpage.dart';
import 'package:seechange/login.dart';
import 'package:seechange/organization/add_charity.dart';
import 'package:seechange/organization/org_home.dart';
import 'package:seechange/users/home.dart';
import 'package:seechange/volunteers/assignedtask.dart';
import 'package:seechange/volunteers/vol_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
      url: 'https://ygnoqrlyolmswdzsmbdu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inlnbm9xcmx5b2xtc3dkenNtYmR1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc0NTg5OTUsImV4cCI6MjA2MzAzNDk5NX0.dY-e4EX3-MN75NuZHZoFjalunjPUnJSfWeHtXe-Mmn8');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(), // Listen to auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading screen while checking auth state
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          print(snapshot.hasData);
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection("login")
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (userSnapshot.hasError || !userSnapshot.hasData || !userSnapshot.data!.exists) {
                return LoginPage();
              }
            final userData = userSnapshot.data!.data()as Map<String, dynamic>?;
                final userType = userData?['role'];
              print(userType);
              if (userType == 'admin') {
                return AdminHome();
              } else if (userType == 'user') {
                return Homepage();
              } else if (userType == 'vol') {
                return VolunteerHome();
              }
              else if (userType == 'org') {
                return OrgHome();
              }
              return LoginPage(); // Default fallback
            },
          );
        } else {
          // User is not logged in, show LoginPage
          return FirstPage();
        }
      },
    );
  }
}