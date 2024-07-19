import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class addexampage extends StatefulWidget {
  const addexampage({super.key});

  @override
  State<addexampage> createState() => _addexampageState();
}

class _addexampageState extends State<addexampage> {
  String? _selectedItem;
  String? _errorMessage;
  bool _isLoading = false;
  final List<String> _examitems = [
    'Quertly Exam',
    'Halfyearly Exam',
    'Model Exam',
    'Final Exam'
  ];

  Future<void> addExam() async {
    if (_selectedItem == null) {
      setState(() {
        _errorMessage = 'Please select an exam';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      //Fetch data from firestore
      QuerySnapshot teacherCollection =
          await FirebaseFirestore.instance.collection('teachers').get();
      for (QueryDocumentSnapshot teacherid in teacherCollection.docs) {
        QuerySnapshot classCollection =
            await teacherid.reference.collection('class').get();
        for (QueryDocumentSnapshot studentdoc in classCollection.docs) {
          studentdoc.reference.collection('exam').doc(_selectedItem).set({
            'Tamil': 'Absent',
            'English': 'Absent',
            'Maths': 'Absent',
            'Physics': 'Absent',
            'Chemistry': 'Absent'
          });
          setState(() {
            _errorMessage = 'Added Successfully!';
          });
        }
      }
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: _isLoading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        DropdownButton<String>(
                            value: _selectedItem,
                            onChanged: (String? newvalue) {
                              setState(() {
                                _selectedItem = newvalue;
                              });
                            },
                            items: _examitems
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                        ElevatedButton(
                            onPressed: () {
                              addExam();
                            },
                            child: const Text('Add Exam')),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 20),
                          Text(_errorMessage!,
                              style: TextStyle(
                                color: _errorMessage == 'Added Successfully!'
                                    ? Colors.green
                                    : Colors.red,
                              ))
                        ]
                      ]))
        //
        );
  }
}
