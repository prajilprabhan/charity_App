import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lottie/lottie.dart';
class AddCharity extends StatefulWidget {
  const AddCharity({super.key});

  @override
  State<AddCharity> createState() => _AddCharityState();
}

class _AddCharityState extends State<AddCharity> {
  bool _isLoading=false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController purpose = TextEditingController();
  final TextEditingController description = TextEditingController();
 
  final TextEditingController amount = TextEditingController();
  final TextEditingController date = TextEditingController();
  File? selectedimage;
  String path =" ";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now, // Do not allow past dates
      lastDate: DateTime(now.year + 100), // Allow up to 100 years in future
    );

    if (picked != null) {
      setState(() {
        date.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

void add_charity()async
{
  // Get current user ID from FirebaseAuth
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  await FirebaseFirestore.instance.collection('charity').add({
    'purpose': purpose.text.trim(),
    "description": description.text.trim(),
    "goal_amount": amount.text.trim(),
    "deadline": date.text.trim(),
    "organization_id": userId,
    "status":"pending",
    "verfiedby":"null",
    "assigned":"null"
  });
  Navigator.pop(context);
  ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("Charity Project Added", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),
   );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_isLoading
            ? Center(
              child: SizedBox(
              width: 150,
              height: 150,
              child: Lottie.network('https://lottie.host/e074026e-f6cc-458b-af87-9f1222e0a958/DrD8OUGv19.json'),
              ),
            )
          :  SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                  'https://thumbs.dreamstime.com/b/volunteering-charity-social-concept-volunteer-people-plant-trees-park-vector-illustration-ecological-lifestyle-volunteering-141041342.jpg'),
              Container(
                width: double.infinity,
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
                            // CircleAvatar(
                            //   backgroundImage: selectedimage != null
                            //       ? FileImage(selectedimage!)
                            //       : NetworkImage(
                            //           'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Picture.png') as ImageProvider,
                            //   radius: 90,
                            // ),
                            Container(
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                image: DecorationImage(
                                  image: selectedimage != null
                                      ? FileImage(selectedimage!)
                                      : NetworkImage(
                                          'https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Picture.png',
                                        ) as ImageProvider,
                                  fit: BoxFit.cover,
                                  
                                ),
                              ),
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
                          controller: purpose,
                          decoration: InputDecoration(
                            label: Text("Purpose"),
                            prefixIcon: Icon(Icons.flag),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Purpose is required';
                            }
                            return null;
                          },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: description,
                          maxLines: 4,
                          decoration: InputDecoration(
                            label: Text("Description"),
                            prefixIcon: Icon(Icons.description),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Description is required';
                            }
                            return null;
                          },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: amount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            label: Text("Needed Amount"),
                            prefixIcon: Icon(Icons.attach_money),
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Needed amount is required';
                            }
                            if (double.tryParse(value) == null) {
                            return 'Enter a valid number';
                            }
                            return null;
                          },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: TextFormField(
                            controller: date,
                            readOnly: true, // Prevent manual input
                            decoration: InputDecoration(
                                label: Text("Deadline"),
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
                          padding: const EdgeInsets.only(top: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              if (formKey.currentState!.validate()) {
                               add_charity();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade600,
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
                                    'Add Request',
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ),
                        ),
                        SizedBox(height: 100,)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}