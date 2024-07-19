import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassAlloc extends StatefulWidget {
  const ClassAlloc({super.key});

  @override
  State<ClassAlloc> createState() => ClassAllocState();
}

class ClassAllocState extends State<ClassAlloc> {
  final Map<String, String?> _selectedItem = {};
  final List<String> _classitems = [
    'Free',
    'GF Rounds',
    'XII-A',
    'XII-B',
    'XII-C',
    'XI-A',
    'XI-B',
    'XI-C'
  ];

  final List<String> _examitems = [
    'Quaterly Exam',
    'Halfyearly Exam',
    'Model Exam',
    'Final Exam'
  ];
  late String _exam = _examitems[0];

  List<Map<String, dynamic>> teacherid = [];
  var isLoading = true;
  var _errorMessage = '';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _allTeacher();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        DateTime initialDate = _selectedDate ?? DateTime.now();
        TimeOfDay initialTime = TimeOfDay.now();
        return AlertDialog(
          title: const Text('Select Date and Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Date: ${initialDate.toLocal()}'.split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      initialDate = pickedDate;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Time: ${initialTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: initialTime,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      initialTime = pickedTime;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(DateTime(
                    initialDate.year,
                    initialDate.month,
                    initialDate.day,
                    initialTime.hour,
                    initialTime.minute));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _allTeacher() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('teachers').get();
      List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      setState(() {
        teacherid = data;
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error ?';
        isLoading = false;
      });
    }
  }

  Future<void> createnotifications(Map<String, String?> selecteditem) async {
    try {
      QuerySnapshot teacherCollection =
          await FirebaseFirestore.instance.collection('teachers').get();
      for (QueryDocumentSnapshot teacher in teacherCollection.docs) {
        teacher.reference.collection('notification').doc('exam').set({
          _exam: selecteditem[teacher.id],
          'DateTime':
              _selectedDate != null ? _formatDateTime(_selectedDate!) : null,
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error adding teacher or students: $e';
      });
    }
  }

  String _formatDateTime(DateTime datetime) {
    String ampm = datetime.hour < 12 ? 'AM' : 'PM';
    int hour = datetime.hour % 12;
    hour = hour == 0 ? 12 : hour;
    String month = _getMonthName(datetime.month);
    return '$month ${datetime.day} ${datetime.year} $hour:${datetime.minute.toString().padLeft(2, '0')} $ampm';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                          value: _exam,
                          onChanged: (String? newvalue) {
                            setState(() {
                              _exam = newvalue!;
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
                          onPressed: () => _selectDateTime(context),
                          child: const Text('Select date')),
                    ]),
                if (_selectedDate != null)
                  Text(
                      'Selected Date and Time : ${_selectedDate != null ? _formatDateTime(_selectedDate!) : null}'),
                Expanded(
                    child: ListView.builder(
                        itemCount: teacherid.length,
                        itemBuilder: (context, index) {
                          return Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(teacherid[index]['ID']),
                                              DropdownButton<String>(
                                                  value: _selectedItem[
                                                      teacherid[index]['ID']],
                                                  onChanged:
                                                      (String? newvalue) {
                                                    setState(() {
                                                      _selectedItem[
                                                              teacherid[index]
                                                                  ['ID']] =
                                                          newvalue;
                                                    });
                                                  },
                                                  items: _classitems.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value),
                                                    );
                                                  }).toList())
                                            ]),
                                        Text(teacherid[index]['Name'])
                                      ])));
                        })),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                        onPressed: () {
                          createnotifications(_selectedItem);
                        },
                        child: const Text('Class Alloc')))
              ]));
  }
}
