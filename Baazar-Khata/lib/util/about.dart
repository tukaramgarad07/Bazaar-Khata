import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.orange[600],
          title: const Text("About Us")),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: const Text(
            "Hi, I am Mayur Bansod, Founder and Developer of this 'Bazaar Khata App'. "),
      ),
    );
  }
}
