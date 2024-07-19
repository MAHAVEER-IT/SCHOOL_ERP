import 'package:flutter/material.dart';

class mentorshippage extends StatefulWidget {
  final String teacherId;
  const mentorshippage({Key? key, required this.teacherId}) : super(key: key);
  @override
  State<mentorshippage> createState() => _mentorshippage();
}

class _mentorshippage extends State<mentorshippage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('mentorshippage'),
    );
  }
}
