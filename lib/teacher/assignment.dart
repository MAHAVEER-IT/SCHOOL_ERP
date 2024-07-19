import 'package:flutter/material.dart';

class assignmentpage extends StatefulWidget {
  final String teacherId;
  const assignmentpage({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<assignmentpage> createState() => _assignmentpage();
}

class _assignmentpage extends State<assignmentpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('assignmentpage'),
    );
  }
}
