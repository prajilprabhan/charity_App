import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:seechange/admin/admin_home.dart';
import 'package:seechange/organization/org_home.dart';
import 'package:seechange/organization/org_signup.dart';
import 'package:seechange/users/signup.dart';
import 'package:seechange/volunteers/vol_home.dart';

import 'users/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading=false;
  final TextEditingController email = TextEditingController();

  final TextEditingController pass = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void login() async{
    setState(() {
      _isLoading = true; // Show loader
    });
    try{
 final users =await FirebaseAuth.instance.signInWithEmailAndPassword(email:email.text.trim(), password: pass.text.trim());
final DocumentSnapshot role = await FirebaseFirestore.instance
  .collection('login')
  .doc(users.user!.uid)
  .get();
//   String userRole = role['role'];
//  print(userRole);
 // ignore: unnecessary_null_comparison
 if (role.exists) {
  Map<String,dynamic> data=role.data() as Map<String,dynamic>;
  if(data!=null){
    String userRole=data['role'];
  
  if(userRole == "user"){
   Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => Homepage(),
     ),
   );
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("User Login Successfully", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),
   );}
   else if(userRole=="org")
   {
    Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => OrgHome(),
     ),
   );
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("Orgnization Login Successfully", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),
   );
   }
   else if(userRole=="admin")
   {
     Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => AdminHome(),
     ),
   );
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("Admin Login Successfully", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),
   );
   }
   else if(userRole=="vol")
   {
     Navigator.push(
     context,
     MaterialPageRoute(
       builder: (context) => VolunteerHome(),
     ),
   );
    ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("Volunteer Login Successfully", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),
   );
   }
   else
   {
     ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("Your are not allowed to Login ", style: TextStyle(color: Colors.black)),
       backgroundColor: Colors.red,
     ),
   );

   }
 } else {
   
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         behavior: SnackBarBehavior.floating,
         margin: EdgeInsets.all(10),
         content: Text("Username/Password is incorrect", style: TextStyle(color: Colors.black)),
         backgroundColor: const Color.fromARGB(255, 244, 54, 54),
       ),
     );
      
   
 }
 }
 else
 {
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         behavior: SnackBarBehavior.floating,
         margin: EdgeInsets.all(10),
         content: Text("Username/Password is incorrect", style: TextStyle(color: Colors.black)),
         backgroundColor: const Color.fromARGB(255, 244, 54, 54),
       ),
     );
 }
  }
  on FirebaseAuthException catch(e)
  {
    print(e.message);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
          content: Text(e.message ?? 'An error occurred during signup',style: TextStyle(color: Colors.black),),
          backgroundColor: const Color.fromARGB(255, 244, 54, 54),
        ),
      );
  }
  finally {
      setState(() {
        _isLoading = false; // Hide loader
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: _isLoading
            ? Container(
              decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
              child: Center(
                child: SizedBox(
                width: 150,
                height: 150,
                child: Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'),
                ),
              ),
            )
          : Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
            child: ListView(
                     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
            Column(
              children: [
                Lottie.network(
                    'https://lottie.host/66d3adf0-7af3-4cf2-bd3c-5a4fbea687ae/2nscUJpRnl.json'),
                Container(
                  width: double.infinity,
               
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Form(
                     key: _formKey,
                      child: Padding(
                   
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: email,
                            validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This Field is Mantatory';
                                    } else if (!RegExp(
                                            r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                        .hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                            decoration: InputDecoration(
                                label: Text("Username"),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: pass,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This Field is Mantatory';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                label: Text("Password"),
                                prefixIcon: Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                               FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                // Your action here
                                login();
                               
                              }
                              // Your action here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600, // Button color
                              foregroundColor: Colors.white, // Text/icon color
                              padding: EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(20), // Rounded corners
                              ),
                              elevation: 5, // Shadow
                            ),
                            child: _isLoading
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : Text(
                                      'LogIn',
                                      style: TextStyle(fontSize: 18),
                                    ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Create a New Account'),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Signuppage(), // Replace with your LoginPage widget
                                  ),
                                );
                              },
                              child: Text('signUP')
                            )
                          ],
                        ),
                        TextButton(onPressed: ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrgSignup()));
                        }, child: Text('Organization SignUP'))
                      ],
                    ),
                  )),
                )
              ],
            ),
                    ],
                  ),
          ),
    );
  }
}
