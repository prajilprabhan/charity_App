import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddNews extends StatelessWidget {
  const AddNews({super.key});

  @override
  Widget build(BuildContext context) {

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController title=TextEditingController();
    final TextEditingController desc=TextEditingController();
    void add_news(){
      if(title.text.trim().isNotEmpty && desc.text.trim().isNotEmpty){
        try{
          final userid=FirebaseAuth.instance.currentUser!.uid;
          FirebaseFirestore.instance.collection("news").add({
            "title": title.text.trim(),
            "description": desc.text.trim(),
            "user":'admin',
            'id':userid,
            "date":DateTime.now(),
            "verify":"approved",
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network('https://tse2.mm.bing.net/th?id=OIP.SKJmrqBAPUffIzgxECw3lwHaHa&pid=Api&P=0&h=180'),
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
    );
  }
}