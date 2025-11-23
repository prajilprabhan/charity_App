import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddVolunteer extends StatefulWidget {
  const AddVolunteer({super.key});

  @override
  State<AddVolunteer> createState() => _AddVolunteerState();
}

class _AddVolunteerState extends State<AddVolunteer> {
  bool _isLoading=false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  String? gender;
  final TextEditingController phone = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confpass = TextEditingController();
  File? selectedimage;
  String path =" ";

  void volsignup() async {
    setState(() {
      
      _isLoading=true;
    });
    try {
      if(selectedimage!=null){
      if (pass.text.trim() == confpass.text.trim()) {
        final volCredentials = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.text.trim(), password: pass.text.trim());
          
           if(selectedimage==null)return;
          final filename=DateTime.now().millisecondsSinceEpoch.toString();
        
          path = 'uploads/users/$filename';
      

        await Supabase.instance.client.storage.from('images').upload(path, selectedimage!);




        await FirebaseFirestore.instance
            .collection('volunteers')
            .doc(volCredentials.user!.uid)
            .set({
          'name': name.text.trim(),
          'email': email.text.trim(),
          'dob': dob.text.trim(),
          'phone': phone.text.trim(),
          'gender': gender,
          'created at':DateTime.now(),
          'imageurl': path
        });
        await FirebaseFirestore.instance
            .collection('login')
            .doc(volCredentials.user!.uid)
            .set({
          'username': email.text.trim(),
          'password': pass.text.trim(),
          'role': 'vol'
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.all(10),
            content: Text("Volunteer Added Successfully",
                style: TextStyle(color: Colors.black)),
            backgroundColor: const Color.fromARGB(255, 54, 244, 82),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password does not match",
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
                                                  color: Colors.black)),
                                          backgroundColor:
                                              const Color.fromARGB(
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

  // Function to show date picker
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
      appBar: AppBar(),
      resizeToAvoidBottomInset: true,
      body: _isLoading
          ? Center(child:  Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'))
          : GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Dismiss keyboard on tap outside
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                  'https://thumbs.dreamstime.com/b/volunteering-charity-social-concept-volunteer-people-plant-trees-park-vector-illustration-ecological-lifestyle-volunteering-141041342.jpg'),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 1.1,
                decoration: BoxDecoration(
                  color: Colors.yellow[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        SizedBox(height: 50),
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: selectedimage != null
                                  ? FileImage(selectedimage!)
                                  : NetworkImage(
                                      'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Picture.png') as ImageProvider,
                              radius: 90,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt,
                                      color: Colors.white),
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
                                                  color: Colors.black)),
                                          backgroundColor:
                                              const Color.fromARGB(
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
                              controller: name,
                              decoration: InputDecoration(
                                  label: Text("Name"),
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This Field is Mandatory';
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
                                gender = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  label: Text("Email"),
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This Field is Mandatory';
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
                          padding: const EdgeInsets.only(top: 0, bottom: 10),
                          child: TextFormField(
                              controller: phone,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                  label: Text("Phone"),
                                  prefixIcon: Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This Field is Mandatory';
                                }
                                return null;
                              }),
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
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This Field is Mandatory';
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
                                label: Text("Confirm Password"),
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
                              if (formKey.currentState!.validate()) {
                                volsignup();
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
                            child: 
                                 Text(
                                    'LogIn',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}