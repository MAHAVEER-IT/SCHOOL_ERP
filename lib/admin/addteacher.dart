import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTeacherPage extends StatefulWidget {
  const AddTeacherPage({super.key});

  @override
  State<AddTeacherPage> createState() => _AddTeacherPageState();
}

class _AddTeacherPageState extends State<AddTeacherPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  String _errorMessage = '';

  Future<void> _addTeacher() async {
    try {
      String docIdTeacher = _idController.text;
      CollectionReference teacherCollection =
          FirebaseFirestore.instance.collection('teachers');

      await teacherCollection.doc(docIdTeacher).set({
        'Role': _roleController.text,
        'ID': docIdTeacher,
        'Name': _nameController.text,
        'Email': _emailController.text,
        'Phone': _phoneController.text,
      });

      await FirebaseFirestore.instance.collection('teacher_auth').doc(docIdTeacher).set({
        'Email': _emailController.text,
        'Password': _passwordController.text,
      });

      QuerySnapshot classQuery = await FirebaseFirestore.instance
          .collection('students')
          .doc(_classController.text)
          .collection('student')
          .get();

      for (var doc in classQuery.docs) {
        teacherCollection
            .doc(docIdTeacher)
            .collection('class')
            .doc(doc['Name'])
            .set({
          'ID': doc['ID'],
          'Name': doc['Name'],
          'Email': doc['Email'],
          'Phone': doc['Phone'],
          'Marks': 'Absent',
        });
      }
    } catch (e) {
      print('Error in _addTeacher: $e');
      setState(() {
        _errorMessage = 'Error adding teacher or students: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _idController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'ID',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _roleController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Role',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Name',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Email',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Password',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Phone',
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextFormField(
              controller: _classController,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: 'Class',
              ),
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _addTeacher,
            child: const Text('Add Teacher'),
          ),
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
