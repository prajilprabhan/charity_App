import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrgAddNews extends StatelessWidget {
  const OrgAddNews({super.key});

  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController title=TextEditingController();
    final TextEditingController desc=TextEditingController();
    void add_news(){
      if(title.text.trim().isNotEmpty && desc.text.trim().isNotEmpty){
        try{
          FirebaseFirestore.instance.collection("news").add({
            "title": title.text.trim(),
            "description": desc.text.trim(),
            "user":"org",
            'id':FirebaseAuth.instance.currentUser?.uid,
            "date":DateTime.now(),
            "verify":"pending",
            "like": [],
          });
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("News Content Added", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 54, 244, 82),
     ),

   );
        }
        catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
       behavior: SnackBarBehavior.floating,
       margin: EdgeInsets.all(10),
       content: Text("${e}", style: TextStyle(color: Colors.black)),
       backgroundColor: const Color.fromARGB(255, 244, 54, 54),
     ),
   );
          // Optionally handle the error here
        }
      }
    }




    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          'Add News Content',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
          child: Column(
            children: [
              SizedBox(height: 40,),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 80,
                child: Image.network('https://static.vecteezy.com/system/resources/thumbnails/024/485/011/small_2x/man-holds-newspaper-reading-news-about-latest-business-events-and-political-changes-or-articles-png.png')),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: title,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                                label: Text("Title"),
                                prefixIcon: Icon(Icons.title),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: desc,
                        maxLines: 5,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          
                                label: Text("Description"),
                                prefixIcon: Icon(Icons.description),
                                border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(onPressed: (){
                      add_news();
                      }, child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload),
                          Text("Submit",style: TextStyle(color: Colors.teal.shade600),)
                        ],
                      )),
                    )
                
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}