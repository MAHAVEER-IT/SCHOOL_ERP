import 'package:flutter/material.dart';

class parentprofile extends StatefulWidget {
  const parentprofile({super.key});

  @override
  State<parentprofile> createState() => _parentprofile();
}

class _parentprofile extends State<parentprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Profile"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("This is parent page"),
            ],
          )),
    );
  }
}
