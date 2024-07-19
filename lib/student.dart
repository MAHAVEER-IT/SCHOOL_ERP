import 'package:flutter/material.dart';

class studentprofile extends StatefulWidget {
  const studentprofile({super.key});

  @override
  State<studentprofile> createState() => _studentprofile();
}

class _studentprofile extends State<studentprofile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Profile"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("This is student page"),
            ],
          )),
    );
  }
}
