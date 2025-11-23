import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:seechange/login.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class Signuppage extends StatefulWidget {
  Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  bool _isLoading=false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();

  final TextEditingController email = TextEditingController();

  final TextEditingController dob = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController post = TextEditingController();

  final TextEditingController pin = TextEditingController();

  final TextEditingController phone = TextEditingController();

  final TextEditingController pass = TextEditingController();

  final TextEditingController confpass = TextEditingController();

  late String gender;

  late String blood;
  String path=" ";
  
  File? selectedimage;
  void signup() async {
    setState(() {
      _isLoading=true;
    });
    try {
      if(selectedimage!=null){
      if (pass.text.trim() == confpass.text.trim()) {
        //signup info
        final UserCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: pass.text.trim());
         
         
          //image upload

          if(selectedimage==null)return;
          final filename=DateTime.now().millisecondsSinceEpoch.toString();
        
          path = 'uploads/users/$filename';
      

        await Supabase.instance.client.storage.from('images').upload(path, selectedimage!);




        //store user data
          
        // final userdata = 
        await FirebaseFirestore.instance
            .collection('users')
            .doc(UserCredentials.user!.uid)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'dob': dob.text.trim(),
          'address': address.text.trim(),
          'post': post.text.trim(),
          'pin': pin.text.trim(),
          'phone': phone.text.trim(),
          'gender': gender,
          'blood': blood,
          'created at':DateTime.now(),
          'imageurl':path,
        });
        
        await FirebaseFirestore.instance.collection('login').doc(UserCredentials.user!.uid).set({
          'username':email.text.trim(),
          'password':pass.text.trim(),
          'role':'user'
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            content: Text(" Account Created Successfully",style: TextStyle(color: Colors.black)),
            backgroundColor: const Color.fromARGB(255, 54, 244, 82),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password doesnot match",style: TextStyle(color: Colors.black)),
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
                                                  color: Colors.black)),
                                          backgroundColor:
                                              const Color.fromARGB(
                                                  255, 244, 54, 54),
                                        ),
                                      );}
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
          content: Text(e.message ?? 'An error occurred during signup',style: TextStyle(color: Colors.black),),
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

 Future<void> _selectDate(BuildContext context) async {
  final DateTime now = DateTime.now();
  final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
  
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: eighteenYearsAgo, // Set initial date to 18 years ago
    firstDate: DateTime(1900), // Earliest possible date
    lastDate: eighteenYearsAgo, // Latest date is 18 years ago from now
  );
  
  if (picked != null) {
    setState(() {
      dob.text =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User SignUp Form"),
      ),
      body: _isLoading
            ? Center(
              child: SizedBox(
              width: 150,
              height: 150,
              child: Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'),
              ),
            )
          :ListView(
         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Column(
            children: [
              Lottie.network(
                  "https://lottie.host/d49430cc-dd04-4011-a129-101844d04f2d/OefS9YSNgH.json"),
              // Stack(
              //   children: [
              //     Container(
              //       color: Colors.white,
              //       width: 100,
              //     )
              //   ],
              // ),

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
                          Stack(
                          children: [
                            CircleAvatar(
                              // ignore: unnecessary_null_comparison
                              backgroundImage: selectedimage != null
                                  ? FileImage(selectedimage!)as ImageProvider
                                  : const NetworkImage(
                                      'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Picture.png'),
                              radius: 90,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.white),
                                  onPressed: () async {
                                    
                                    final ImagePicker picker = ImagePicker();
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                        print(image);
                                    if (image == null) {
                                      setState(() {
                                         selectedimage=null;
                                      });
                                     
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(10),
                                          content: Text("No image Selected",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          backgroundColor: const Color.fromARGB(255, 244, 54, 54),
                                        ),
                                      );
                                    }
                                    else{
                                      setState(() {
                                        selectedimage=File(image.path);
                                        print(selectedimage);
                                        // Update the CircleAvatar with the selected image
                                        // Assuming you want to display the image in the CircleAvatar
                                        // You can use a stateful widget and update the image source
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
                                controller: name,
                                decoration: InputDecoration(
                                    label: Text("Name"),
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                label: Text("Gender"),
                                prefixIcon: Icon(Icons.transgender_sharp),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: ['Male', 'Female', 'Other']
                                  .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text(gender),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                                // Handle the selected value
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    label: Text("email"),
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: dob,
                            readOnly: true, // Prevent manual input
                            decoration: InputDecoration(
                                label: Text("DOB"),
                                prefixIcon: Icon(Icons.date_range),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onTap: () => _selectDate(context), // Show date picker
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Date is required';
                              }
                              final dateRegex = RegExp(
                                  r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');
                              if (!dateRegex.hasMatch(value)) {
                                return 'Enter date in dd/MM/yyyy format';
                              }
                              return null;
                            },
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                    label: Text("Address"),
                                    prefixIcon: Icon(Icons.home),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                                controller: post,
                                decoration: InputDecoration(
                                    label: Text("Post"),
                                    prefixIcon: Icon(Icons.post_add),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                                controller: pin,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: InputDecoration(
                                    label: Text("Pin"),
                                    prefixIcon: Icon(Icons.pin),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 10),
                            child: TextFormField(
                                controller: phone,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                    label: Text("Phone"),
                                    prefixIcon: Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 10),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                label: Text("Blood Group"),
                                prefixIcon: Icon(Icons.bloodtype),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: [
                                'A+',
                                'A-',
                                'B+',
                                'B-',
                                'AB+',
                                'AB-',
                                'O+',
                                'O-'
                              ]
                                  .map((bloodGroup) => DropdownMenuItem(
                                        value: bloodGroup,
                                        child: Text(bloodGroup),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  blood = value.toString();
                                });
                                // Handle the selected value
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                                controller: pass,
                                obscureText: true,
                                decoration: InputDecoration(
                                    label: Text("Password"),
                                    prefixIcon: Icon(Icons.password),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This Field is Mantatory';
                                  }
                                  return null;
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: TextFormField(
                              controller: confpass,
                              obscureText: true,
                              decoration: InputDecoration(
                                  label: Text("Conf Password"),
                                  prefixIcon: Icon(Icons.password),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
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
                                  // Your action here
                                  signup();
                                 
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color
                                foregroundColor:
                                    Colors.white, // Text/icon color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Rounded corners
                                ),
                                elevation: 5, // Shadow
                              ),
                              child: Text(
                                    'LogIn',
                                    style: TextStyle(fontSize: 18),
                                  ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have Account'),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(), // Replace with your LoginPage widget
                                    ),
                                  );
                                },
                                child: Text("Login Now!"),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
