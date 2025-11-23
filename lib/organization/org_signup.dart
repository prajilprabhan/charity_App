import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:seechange/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrgSignup extends StatefulWidget {
  const OrgSignup({super.key});

  @override
  State<OrgSignup> createState() => _OrgSignupState();
}

class _OrgSignupState extends State<OrgSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? selectedimage;
  final TextEditingController orgname = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController place = TextEditingController();
  final TextEditingController post = TextEditingController();
  final TextEditingController pin = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confpass = TextEditingController();
  String path= " ";
  String? district;
 bool _isLoading=false;
  void org_signup(BuildContext context) async {
    try {
      setState(() {
        _isLoading=true;
      });
      if(selectedimage!=null){
      if (pass.text.trim() == confpass.text.trim()) {
        final OrgCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: pass.text.trim());


           if(selectedimage==null)return;
          final filename=DateTime.now().millisecondsSinceEpoch.toString();
        
          path = 'uploads/users/$filename';
      

        await Supabase.instance.client.storage.from('images').upload(path, selectedimage!);




        await FirebaseFirestore.instance
            .collection('organization')
            .doc(OrgCredentials.user!.uid)
            .set({
          'name': orgname.text.trim(),
          'email': email.text.trim(),
          'phone': phone.text.trim(),
          'place': place.text.trim(),
          'post': post.text.trim(),
          'pin': pin.text.trim(),
          'district': district,
          'created at':DateTime.now(),
          'imageurl':path,
          'verfiedby':'null',
          
        });

        // Optional: Avoid storing passwords in Firestore for security
        await FirebaseFirestore.instance
            .collection('login')
            .doc(OrgCredentials.user!.uid)
            .set({
          'username': email.text.trim(),
          'role': 'pending',
          'password':pass.text.trim()
        });
       

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            content: Text("Account Created Successfully",
                style: TextStyle(color: Colors.black)),
            backgroundColor: const Color.fromARGB(255, 54, 244, 82),
          ),
        );

        // Delay navigation to ensure SnackBar is visible
        await Future.delayed(Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            content: Text("Passwords do not match",
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.red,
          ),
        );
      }
      }
      else{
         ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.all(10),
                                            content: Text("No image Selected",
                                                style: TextStyle(
                                                    color: const Color.fromARGB(255, 255, 255, 255))),
                                            backgroundColor: const Color.fromARGB(
                                                255, 244, 54, 54),
                                          ),
                                        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          content: Text(e.message ?? 'An error occurred during signup',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Signup'),
      ),
      body: _isLoading
          ? Center(child:  Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'))
          : GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: ListView(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Lottie.network(
                    'https://lottie.host/15de517f-724e-4caf-9284-f511cc044e61/Uzblb5Qa08.json',
                  
                  ),
                ),
                Container(
                  width: double.infinity,
                 
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
                    borderRadius: const BorderRadius.only(
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
                          const SizedBox(height: 50),
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: selectedimage != null
                                    ? FileImage(selectedimage!)
                                    : const NetworkImage(
                                        'https://cdn-icons-png.freepik.com/512/7486/7486692.png') as ImageProvider,
                                radius: 90,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon:
                                        Icon(Icons.camera_alt, color: Colors.white),
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? image = await picker.pickImage(
                                          source: ImageSource.gallery);
                                      if (image == null) {
                                          setState(() {
                                         selectedimage=null;
                                      });
                                     
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            behavior: SnackBarBehavior.floating,
                                            margin: EdgeInsets.all(10),
                                            content: Text("No image Selected",
                                                style: TextStyle(
                                                    color: const Color.fromARGB(255, 255, 255, 255))),
                                            backgroundColor: const Color.fromARGB(
                                                255, 244, 54, 54),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          selectedimage = File(image.path);
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: orgname,
                              decoration: InputDecoration(
                                label: const Text("Organization Name"),
                                prefixIcon: const Icon(Icons.business),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the organization name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                label: const Text("Email"),
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                label: const Text("Phone"),
                                prefixIcon: const Icon(Icons.phone),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                  return 'Please enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: place,
                              decoration: InputDecoration(
                                label: const Text("Place"),
                                prefixIcon: const Icon(Icons.location_on),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the place';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: post,
                              decoration: InputDecoration(
                                label: const Text("Post"),
                                prefixIcon: const Icon(Icons.mail),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the post';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: pin,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: InputDecoration(
                                label: const Text("Pin"),
                                prefixIcon: const Icon(Icons.pin_drop),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the pin code';
                                }
                                if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                                  return 'Please enter a valid 6-digit pin code';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                label: const Text("District"),
                                prefixIcon: const Icon(Icons.location_city),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: [
                                'Thiruvananthapuram',
                                'Kollam',
                                'Pathanamthitta',
                                'Alappuzha',
                                'Kottayam',
                                'Idukki',
                                'Ernakulam',
                                'Thrissur',
                                'Palakkad',
                                'Malappuram',
                                'Kozhikode',
                                'Wayanad',
                                'Kannur',
                                'Kasaragod'
                              ].map((String district) {
                                return DropdownMenuItem<String>(
                                  value: district,
                                  child: Text(district),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  district = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a district';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: pass,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: const Text("Password"),
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: confpass,
                              obscureText: true,
                              decoration: InputDecoration(
                                label: const Text("Confirm Password"),
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != pass.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  org_signup(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5,
                              ),
                              child:  Text(
                                    'LogIn',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text("Login Now!"),
                              )
                            ],
                          ),
                          SizedBox(height: 50,)
                        ],
                      ),
                    ),
                  ),
                ),
              ]
              ),
            ],
          
        ),
      ),
    );
  }
}