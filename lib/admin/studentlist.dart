import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class studentlist extends StatefulWidget {
  const studentlist({super.key});

  @override
  State<studentlist> createState() => _studentlistState();
}

class _studentlistState extends State<studentlist> {
  final TextEditingController _studentidController = TextEditingController();
  final TextEditingController _studentnameController = TextEditingController();
  final TextEditingController _studentemailController = TextEditingController();
  final TextEditingController _studentphoneController = TextEditingController();
  final TextEditingController _classController = TextEditingController();

  List<Map<String, dynamic>> studentdata = [];
  var isLoading = true;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _allStudent();
  }

  Future<void> _allStudent() async {
    try {
      if (_classController.text.isEmpty) {
        setState(() {
          _errorMessage = 'Class field is empty';
          isLoading = false;
        });
        return;
      }
      //
      //Fetch data from firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(_classController.text)
          .collection('student')
          .get();
      //
      //Converts querysnapshot int list of maps
      List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      //
      //Update the data
      setState(() {
        studentdata = data;
        isLoading = false;
        _errorMessage = '';
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error ?';
        isLoading = false;
      });
    }
  }

  //
  //
  Future _updateDetails(String newid, String studentname, String newemail,
      String newphone) async {
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(_classController.text)
          .collection('student')
          .doc(studentname)
          .update({
        'ID': newid,
        'Email': newemail,
        'Phone': newphone,
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error';
      });
    }
  }

  //
  //
  Future<void> _updateStudentDetails(String studentid, String studentname,
      String studentemail, String studentphone) async {
    final student = studentdata.firstWhere(
        (student) => student['Name'] == studentname,
        orElse: () => {});
    if (student.isNotEmpty) {
      _studentidController.text = student['ID'] ?? '';
      _studentnameController.text = student['Name'] ?? '';
      _studentemailController.text = student['Email'] ?? '';
      _studentphoneController.text = student['Phone'] ?? '';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Edit Details',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  Text(studentname,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _studentidController,
                      decoration: InputDecoration(
                          labelText: 'ID',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  TextField(
                      controller: _studentemailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  TextField(
                      controller: _studentphoneController,
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                ]),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel')),
                  ElevatedButton(
                      onPressed: () async {
                        _updateDetails(
                            _studentidController.text,
                            _studentnameController.text,
                            _studentemailController.text,
                            _studentphoneController.text);
                        Navigator.pop(context);
                        _allStudent();
                      },
                      child: const Text('Save'))
                ]);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                //
                //Printing the error message
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : Column(children: [
                const SizedBox(height: 10.0),
                TextField(
                    controller: _classController,
                    decoration: InputDecoration(
                        labelText: 'Class',
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        border: const OutlineInputBorder())),
                const SizedBox(height: 10.0),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: ElevatedButton(
                      onPressed: _allStudent,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          textStyle: const TextStyle(fontSize: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0))),
                      child: const Text('  Fetch Students  '),
                    )),
                Expanded(
                    child: ListView.builder(
                        //
                        //printing the Teacher list
                        itemCount: studentdata.length,
                        itemBuilder: (context, index) {
                          return Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                studentdata[index]['ID'] ?? ''),
                                            GestureDetector(
                                              onTap: () {
                                                _updateStudentDetails(
                                                  studentdata[index]['ID'] ??
                                                      '',
                                                  studentdata[index]['Name'] ??
                                                      '',
                                                  studentdata[index]['Email'] ??
                                                      '',
                                                  studentdata[index]['Phone'] ??
                                                      '',
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(studentdata[index]['Name'] ?? ''),
                                        const SizedBox(height: 10.0),
                                        Text(studentdata[index]['ID'] ?? ''),
                                        const SizedBox(height: 10.0),
                                        Text(studentdata[index]['Email'] ?? ''),
                                        const SizedBox(height: 10.0),
                                        Text(studentdata[index]['Phone'] ?? ''),
                                        const SizedBox(height: 10.0),
                                        Text(studentdata[index]['Role'] ?? ''),
                                      ])));
                        }))
              ]));
  }
}
