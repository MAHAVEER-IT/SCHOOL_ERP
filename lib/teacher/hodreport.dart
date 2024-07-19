import 'package:flutter/material.dart';

class hodreportpage extends StatefulWidget {
  final String teacherId;
  const hodreportpage({Key? key, required this.teacherId}) : super(key: key);
  @override
  State<hodreportpage> createState() => _hodreportpage();
}

class _hodreportpage extends State<hodreportpage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('hodpage'),
    );
  }
}
