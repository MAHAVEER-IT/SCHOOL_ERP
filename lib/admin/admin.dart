import 'package:flutter/material.dart';
import 'package:schoolerp/admin/addexamination.dart';
import 'package:schoolerp/admin/studentlist.dart';
import 'sendresults.dart';
import 'addteacher.dart';
import 'information.dart';
import 'teacherlist.dart';
import 'sendfees.dart';
import 'addstudents.dart';

class adminprofile extends StatefulWidget {
  const adminprofile({Key? key}) : super(key: key);

  @override
  State<adminprofile> createState() => _adminprofileState();
}

class _adminprofileState extends State<adminprofile> {
  int _selectedindex = 0;

  final List<Widget> _pages = [
    const informationpage(),
    const AddTeacherPage(),
    const addstudentpage(),
    const teacherlist(),
    const sendresults(),
    const sendfees(),
    const studentlist(),
    const AddExaminationPage()
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
          title: const Text("Admin Profile"),
          backgroundColor: Colors.blueAccent,
        ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
            child: Text(
              'Profile',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Information'),
              onTap: () => _onItemTapped(0)),
          ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Teacher'),
              onTap: () => _onItemTapped(1)),
          ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Exam Controller'),
              onTap: () => _onItemTapped(7)),
          ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('Add Class'),
              onTap: () => _onItemTapped(2)),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Teachers List'),
              onTap: () => _onItemTapped(3)),
          ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Student list'),
              onTap: () => _onItemTapped(6)),
          ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Send Results'),
              onTap: () => _onItemTapped(4)),
          ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Fees'),
              onTap: () => _onItemTapped(5)),
        ])),
        body: IndexedStack(index: _selectedindex, children: _pages));
  }
}
