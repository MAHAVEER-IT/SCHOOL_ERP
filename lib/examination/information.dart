import 'package:flutter/material.dart';

class informationpage extends StatefulWidget {
  const informationpage({Key? key}) : super(key: key);

  @override
  State<informationpage> createState() => informationpageState();
}

class informationpageState extends State<informationpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text("This is information page"));
  }
}
