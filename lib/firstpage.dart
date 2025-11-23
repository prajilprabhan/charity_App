import 'package:flutter/material.dart';
import 'package:seechange/login.dart';
import 'package:seechange/users/signup.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: Container(
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://i.pinimg.com/originals/a7/16/36/a71636b6b16491c09ed3317e821205da.png',
                    height: 500,
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome to SeeChange',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.orange),
                  ),
                  const SizedBox(height: 50),
            
                  // First Rounded Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) => Signuppage())),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Get Started',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  // Second Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: ()=>  Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage())),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Login Now',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
