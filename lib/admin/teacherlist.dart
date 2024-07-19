import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class teacherlist extends StatefulWidget {
  const teacherlist({super.key});

  @override
  State<teacherlist> createState() => _teacherlistState();
}

class _teacherlistState extends State<teacherlist> {
  final TextEditingController _teacheridController = TextEditingController();
  final TextEditingController _teachernameController = TextEditingController();
  final TextEditingController _teacheremailController = TextEditingController();
  final TextEditingController _teacherphoneController = TextEditingController();
  final TextEditingController _teacherroleController = TextEditingController();
  List<Map<String, dynamic>> teacherdata = [];
  var isLoading = true;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _allTeacher();
  }

  Future<void> _allTeacher() async {
    try {
      //
      //Fetch data from firestore
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('teachers').get();
      //
      //Converts querysnapshot int list of maps
      List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      //
      //Update the data
      setState(() {
        teacherdata = data;
        isLoading = false;
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
  Future _updateDetails(String teacherid, String newname, String newemail,
      String newphone, String newrole) async {
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherid)
          .update({
        'Name': newname,
        'Email': newemail,
        'Phone': newphone,
        'Role': newrole
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error';
      });
    }
  }

  //
  //
  Future<void> _updateTeacherDetails(String teacherid, String teachername,
      String teacheremail, String teacherphone, String teacherrole) async {
    final teacher = teacherdata
        .firstWhere((teacher) => teacher['ID'] == teacherid, orElse: () => {});
    if (teacher.isNotEmpty) {
      _teacheridController.text = teacherid;
      _teachernameController.text = teacher['Name'] ?? '';
      _teacheremailController.text = teacher['Email'] ?? '';
      _teacherphoneController.text = teacher['Phone'] ?? '';
      _teacherroleController.text = teacher['Role'] ?? '';
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Edit Details',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  Text(teacherid,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _teachernameController,
                      decoration: InputDecoration(
                          labelText: 'Name',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  TextField(
                      controller: _teacheremailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  TextField(
                      controller: _teacherphoneController,
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 25),
                  TextField(
                      controller: _teacherroleController,
                      decoration: InputDecoration(
                          labelText: 'Role',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder()))
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
                          _teacheridController.text,
                          _teachernameController.text,
                          _teacheremailController.text,
                          _teacherphoneController.text,
                          _teacherroleController.text);
                      Navigator.pop(context);
                      _allTeacher();
                    },
                    child: const Text('Save'),
                  )
                ]);
          });
    }
  }
  //
  //}

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
          : ListView.builder(
              //
              //printing the Teacher list
              itemCount: teacherdata.length,
              itemBuilder: (context, index) {
                return Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(teacherdata[index]['ID']),
                            GestureDetector(
                              onTap: () {
                                _updateTeacherDetails(
                                    teacherdata[index]['ID'],
                                    teacherdata[index]['Name'],
                                    teacherdata[index]['Email'],
                                    teacherdata[index]['Phone'],
                                    teacherdata[index]['Role']);
                              },
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Text(teacherdata[index]['Name']),
                        const SizedBox(height: 10.0),
                        Text(teacherdata[index]['Email']),
                        const SizedBox(height: 10.0),
                        Text(teacherdata[index]['Phone']),
                        const SizedBox(height: 10.0),
                        Text(teacherdata[index]['Role']),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
