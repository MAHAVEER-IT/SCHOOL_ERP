import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentList extends StatefulWidget {
  final String teacherId;
  const StudentList({Key? key, required this.teacherId}) : super(key: key);
  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tamilMarkController = TextEditingController();
  final TextEditingController _englishMarkController = TextEditingController();
  final TextEditingController _mathsMarkController = TextEditingController();
  final TextEditingController _physicsMarkController = TextEditingController();
  final TextEditingController _chemistryMarkController =
      TextEditingController();

  List<Map<String, dynamic>> studentData = [];
  List<Map<String, dynamic>> markData = [];
  final List<String> _examitems = [
    'Quertly Exam',
    'Halfyearly Exam',
    'Model Exam',
    'Final Exam'
  ];
  String? _selectedItem;

  bool isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _studentsMarks();
  }

  Future<void> _studentsMarks() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });
    List<Map<String, dynamic>> stddata = [];
    List<Map<String, dynamic>> markdata = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(widget.teacherId)
          .collection('class')
          .get();
      for (QueryDocumentSnapshot studentdoc in querySnapshot.docs) {
        DocumentSnapshot examdoc = await studentdoc.reference
            .collection('exam')
            .doc(_selectedItem)
            .get();
        if (examdoc.exists) {
          markdata.add(examdoc.data() as Map<String, dynamic>);
        } else {
          markdata.add({'error': 'No exam data found'});
        }
      }
      stddata = querySnapshot.docs.map((doc) {
        return {
          'Name': doc['Name'] ?? '',
          'ID': doc['ID'] ?? '',
        };
      }).toList();

      setState(() {
        studentData = stddata;
        markData = markdata;
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error ?';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future _updateMarks(String studentName, String tamilMark, String englishMark,
      String mathsMark, String physicsMark, String chemistryMark) async {
    try {
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(widget.teacherId)
          .collection('class')
          .doc(studentName)
          .collection('exam')
          .doc(_selectedItem)
          .update({
        'Tamil': tamilMark,
        'English': englishMark,
        'Maths': mathsMark,
        'Physics': physicsMark,
        'Chemistry': chemistryMark
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error';
      });
    }
  }

  Future<void> _updateStudentMarks(
      String studentId,
      String studentName,
      String tamilMark,
      String englishMark,
      String mathsMark,
      String physicsMark,
      String chemistryMark) async {
    final student = studentData.firstWhere(
        (student) => student['Name'] == studentName,
        orElse: () => {});
    if (student.isNotEmpty) {
      _nameController.text = studentName;
      _tamilMarkController.text = tamilMark;
      _englishMarkController.text = englishMark;
      _mathsMarkController.text = mathsMark;
      _physicsMarkController.text = physicsMark;
      _chemistryMarkController.text = chemistryMark;

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                    'Edit Marks',
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    studentName,
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _tamilMarkController,
                      decoration: InputDecoration(
                          labelText: 'Tamil',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _englishMarkController,
                      decoration: InputDecoration(
                          labelText: 'English',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _mathsMarkController,
                      decoration: InputDecoration(
                          labelText: 'Maths',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _physicsMarkController,
                      decoration: InputDecoration(
                          labelText: 'Physics',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                  const SizedBox(height: 20.0),
                  TextFormField(
                      controller: _chemistryMarkController,
                      decoration: InputDecoration(
                          labelText: 'Chemistry',
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: const OutlineInputBorder())),
                ]),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () async {
                    await _updateMarks(
                        studentName,
                        _tamilMarkController.text,
                        _englishMarkController.text,
                        _mathsMarkController.text,
                        _physicsMarkController.text,
                        _chemistryMarkController.text);
                    Navigator.pop(context);
                    _studentsMarks();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          });
    }
  }

  Widget buildStudentItem(Map<String, dynamic> stdmark, String sub) {
    try {
      String mark = stdmark[sub];
      if (mark == 'Absent') {
        return Text('$sub: Absent',
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold));
      }
      int marks = int.parse(mark);
      if (marks >= 40) {
        return Text(
          '$sub: $mark - PASS',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Text(
          '$sub: $mark - FAIL',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        );
      }
    } catch (e) {
      return Text('$sub : Absent',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ));
    }
  }
  //
  //
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const SizedBox(height: 25),
      isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : DropdownButton<String>(
                  value: _selectedItem,
                  onChanged: (String? newvalue) {
                    setState(() {
                      _selectedItem = newvalue;
                    });
                  },
                  items:
                      _examitems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
      ElevatedButton(
          onPressed: () {
            _studentsMarks();
          },
          child: const Text('Get Students')),
      Expanded(
          child: ListView.builder(
              itemCount: studentData.length,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(studentData[index]['Name']),
                                    Text(studentData[index]['ID']),
                                    GestureDetector(
                                        onTap: () {
                                          _updateStudentMarks(
                                            studentData[index]['ID'] ??
                                                'Unknown',
                                            studentData[index]['Name'] ??
                                                'Unknown',
                                            studentData[index]['Tamil'] ?? '',
                                            studentData[index]['English'] ?? '',
                                            studentData[index]['Maths'] ?? '',
                                            studentData[index]['Physics'] ?? '',
                                            studentData[index]['Chemistry'] ??
                                                '',
                                          );
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          size: 20,
                                        ))
                                  ]),
                              const SizedBox(height: 10.0),
                              buildStudentItem(markData[index], 'Tamil'),
                              const SizedBox(height: 10.0),
                              buildStudentItem(markData[index], 'English'),
                              const SizedBox(height: 10.0),
                              buildStudentItem(markData[index], 'Maths'),
                              const SizedBox(height: 10.0),
                              buildStudentItem(markData[index], 'Physics'),
                              const SizedBox(height: 10.0),
                              buildStudentItem(markData[index], 'Chemistry'),
                            ])));
              }))
    ]));
  }
}
