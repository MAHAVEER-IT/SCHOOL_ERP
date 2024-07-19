import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addstudentpage extends StatefulWidget {
  const addstudentpage({super.key});

  @override
  State<addstudentpage> createState() => _addstudentpageState();
}

class _addstudentpageState extends State<addstudentpage> {
  final TextEditingController _classController = TextEditingController();
  final List<Map<String, String>> _nameControllers = [];

  Future<void> _addStudentAlert() async {
    final TextEditingController studentNameController = TextEditingController();
    final TextEditingController studentPhoneController =
        TextEditingController();
    final TextEditingController studentEmailController =
        TextEditingController();
    final TextEditingController studentIdController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Enter Student',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: studentNameController,
                      decoration: InputDecoration(
                          labelText: 'Student Name',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  //
                  TextFormField(
                      controller: studentIdController,
                      decoration: InputDecoration(
                          labelText: 'Student ID',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  //
                  TextFormField(
                      controller: studentEmailController,
                      decoration: InputDecoration(
                          labelText: 'Student Email',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  //
                  TextFormField(
                      controller: studentPhoneController,
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder()))
                ]),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _nameControllers.add({
                          'name': studentNameController.text,
                          'id': studentIdController.text,
                          'email': studentEmailController.text,
                          'phone': studentPhoneController.text,
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Add'),
                  ),
                ]));
  }

  Future<void> classDatabase() async {
    try {
      DocumentReference classdoc = FirebaseFirestore.instance
          .collection('students')
          .doc(_classController.text);
      //
      classdoc.set({'data': 'data'});
      //
      CollectionReference studentcollection =
          classdoc.collection('student');
      //
      for (var student in _nameControllers) {
        studentcollection.doc(student['name']).set({
          'ID': student['id'],
          'Name': student['name'],
          'Email': student['email'],
          'Phone': student['phone'],
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //add students
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                _addStudentAlert();
              });
            },
            child: const Icon(Icons.add)),
        //class
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(height: 25),
              TextFormField(
                  controller: _classController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelStyle: const TextStyle(
                        fontFamily: 'Arial',
                      ),
                      labelText: 'Student Class')),

              const SizedBox(height: 25),
              //
              ElevatedButton(
                  onPressed: () {
                    classDatabase();
                    _classController.clear();
                    _nameControllers.clear();
                  },
                  child: const Text('Add Students')),
              //
              Expanded(
                  child: ListView.builder(
                      itemCount: _nameControllers.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(children: [
                              const SizedBox(height: 25),
                              Text(
                                '${index + 1}. ${_nameControllers[index]['name']}\n'
                                '${_nameControllers[index]['id']}\n'
                                '${_nameControllers[index]['email']}\n'
                                '${_nameControllers[index]['phone']}',
                              ),
                            ]));
                      }))
            ])));
  }
}
