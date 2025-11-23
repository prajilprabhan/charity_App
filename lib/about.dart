import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Column(
                children: [
                  Image.network(
                     width: double.infinity,
                    "https://oddsdrive.com/wp-content/uploads/2022/11/about-us-2048x768.png"),
                  SizedBox(height: 20,),
                  Stack(
                    children: [
                      Center(
                          child: Image.network(
                            
                            scale: .5,
                              'https://static.wixstatic.com/media/8247c1_468301a25df6475f97220759a817a1c5~mv2.png/v1/fill/w_175,h_221,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/ronexbd%20about%20us.png')),
                      Positioned(
                          child: Text(
                            textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.normal, // or FontStyle.italic
                              ),
                             'HopeConnect is a charity app built to bridge the gap between generous donors and those in need. '
  'Our mission is to create a transparent, accessible, and efficient platform that empowers individuals to make a difference through donations, volunteering, and community support.\n\n'
  'Every contribution made through HopeConnect goes directly to verified causes, ranging from education and healthcare to emergency relief. '
  'We believe in the power of community and technology to bring lasting change.\n\n'
  'Join us in spreading hope, one act of kindness at a time.\n\n'
  'For inquiries, support, or partnership opportunities, please contact us at support@hopeconnect.org.',
  ))
                    ],
                  ),
                  SizedBox(height: 50,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
