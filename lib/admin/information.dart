import 'package:flutter/material.dart';

class informationpage extends StatefulWidget {
  const informationpage({super.key});

  @override
  State<informationpage> createState() => _informationpageState();
}

class _informationpageState extends State<informationpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("This is information page of admin"));
  }
}
