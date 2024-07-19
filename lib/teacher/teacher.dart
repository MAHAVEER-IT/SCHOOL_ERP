import 'package:flutter/material.dart';
import 'package:schoolerp/teacher/assignment.dart';
import 'package:schoolerp/teacher/hodreport.dart';
import 'package:schoolerp/teacher/information.dart';
import 'package:schoolerp/teacher/mentorship.dart';
import 'package:schoolerp/teacher/notification.dart';
import 'package:schoolerp/teacher/students.dart';

class teacherprofile extends StatefulWidget {
  final String teacherId;
  teacherprofile({Key? key, required this.teacherId}) : super(key: key);

  @override
  State<teacherprofile> createState() => _teacherprofile();
}

class _teacherprofile extends State<teacherprofile> {
  int _selectedindex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      informationPage(teacherId: widget.teacherId),
      assignmentpage(teacherId: widget.teacherId),
      StudentList(teacherId: widget.teacherId),
      mentorshippage(teacherId: widget.teacherId),
      hodreportpage(teacherId: widget.teacherId),
      notificationpage(teacherId: widget.teacherId),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Profile"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
              onTap: () {
                setState(() {
                  _selectedindex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Assignment'),
              onTap: () {
                setState(() {
                  _selectedindex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Students'),
              onTap: () {
                setState(() {
                  _selectedindex = 2;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.hail),
              title: const Text('Mentorship'),
              onTap: () {
                setState(() {
                  _selectedindex = 3;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.mode_comment),
              title: const Text('HOD\'s Reports'),
              onTap: () {
                setState(() {
                  _selectedindex = 4;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification'),
              onTap: () {
                setState(() {
                  _selectedindex = 5;
                });
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedindex],
    );
  }
}
