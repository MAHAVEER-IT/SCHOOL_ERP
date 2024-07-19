import 'package:flutter/material.dart';
import 'classalloc.dart';
import 'information.dart';
import 'addexam.dart';

class ExamProfile extends StatefulWidget {
  const ExamProfile({Key? key}) : super(key: key);

  @override
  State<ExamProfile> createState() => _ExamProfileState();
}

class _ExamProfileState extends State<ExamProfile> {
  int _selectedindex = 0;

  final List<Widget> _pages = [
    const informationpage(),
    const addexampage(),
    const ClassAlloc()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Examination Controller Profile"),
            backgroundColor: Colors.blueAccent),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
              decoration: BoxDecoration(color: Colors.lightBlueAccent),
              child: Text('Profile',
                  style: TextStyle(color: Colors.white, fontSize: 24))),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Information'),
              onTap: () => _onItemTapped(0)),
          ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Add Exam'),
              onTap: () => _onItemTapped(1)),
          ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Class Allco'),
              onTap: () => _onItemTapped(2))
        ])),
        body: IndexedStack(index: _selectedindex, children: _pages));
  }
}
