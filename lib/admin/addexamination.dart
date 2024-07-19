import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddExaminationPage extends StatefulWidget {
  const AddExaminationPage({super.key});

  @override
  State<AddExaminationPage> createState() => _AddExaminationPageState();
}

class _AddExaminationPageState extends State<AddExaminationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  String _errorMessage = '';
  //
  //
  //
  //
  //STORING LOGIN DATABASE
  Future<void> _loginDatabase() async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      await _examinationDatabase();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occured';
      });
    }
  }

  //TEACHER DATABASE
  Future<void> _examinationDatabase() async {
    try {
      String docid = _idController.text;
      CollectionReference examinationcollection =
          FirebaseFirestore.instance.collection('examinations');

      await examinationcollection.doc(docid).set({
        'Role': _roleController.text,
        'ID': docid,
        'Name': _nameController.text,
        'Email': _emailController.text,
        'Phone': _phoneController.text,
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding teacher or students: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      //ID
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _idController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: 'Controller Id',
          ),
        ),
      ),
      //ROLE
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _roleController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: 'Controller Role',
          ),
        ),
      ),
      //EMAIL
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: 'Controller Email',
          ),
        ),
      ),
      //PASSWORD
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: 'Controller Password',
          ),
        ),
      ),
      //NAME
      const SizedBox(height: 25),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            fillColor: Colors.grey.shade200,
            filled: true,
            labelText: 'Controller Name',
          ),
        ),
      ),
      //PHONE
      const SizedBox(height: 25),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  labelText: 'Controller Phone Number'))),
      const SizedBox(height: 25),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: ElevatedButton(
              onPressed: () {
                _loginDatabase();
                // _nameController.clear();
                //  _idController.clear();
                //  _roleController.clear();
                //  _passwordController.clear();
                // _phoneController.clear();
                //_emailController.clear();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0))),
              child: const Center(child: Text('Add Exam Controller')))),
      //ERRORMESSAGE
      const SizedBox(height: 50),
      if (_errorMessage.isNotEmpty)
        Text(_errorMessage, style: const TextStyle(color: Colors.red))
    ]));
  }
}
