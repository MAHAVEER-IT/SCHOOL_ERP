import 'package:flutter/material.dart';
//import 'package:flutter_sms/flutter_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class sendfees extends StatefulWidget {
  const sendfees({Key? key}) : super(key: key);

  @override
  State<sendfees> createState() => _sendfeesState();
}

class _sendfeesState extends State<sendfees> {
  List<Map<String, dynamic>> studentData = [];
  List<Map<String, dynamic>> failedSms = [];
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndSendSMS() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    try {
      var status = await Permission.sms.request();
      if (status.isGranted) {
        await _sendSMS();
      } else {
        throw Exception('SMS permission not granted');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  //
  //
  //
  //Collect the data of the students
  Future<void> _studentsPhone() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    try {
      List<Map<String, dynamic>> data = [];

      QuerySnapshot teacherCollection =
          await FirebaseFirestore.instance.collection('teachers').get();
      for (QueryDocumentSnapshot teacherid in teacherCollection.docs) {
        QuerySnapshot classCollection =
            await teacherid.reference.collection('class').get();

        for (QueryDocumentSnapshot studentdoc in classCollection.docs) {
          data.add({
            'Name': studentdoc['Name'],
            'ID': studentdoc['ID'],
            'Phone': studentdoc['Phone'],
          });
        }
      }
      setState(() {
        studentData = data;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error ?';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendSMS() async {
    await _studentsPhone();

    List<Map<String, dynamic>> failed = [];

    for (var student in studentData) {
      List<String> recipients = [student['Phone']];
      String message = '''Greetings of the Day! 
          Parent of${student['Name']}(${student['ID']}),
          ${_messageController.text}''';
      try {
        await //sendSMS
        (
            message: message, recipients: recipients, sendDirect: true);
      } catch (e) {
        failed.add({'Name': student['Name'], 'Phone': student['Phone']});
      }
    }
    setState(() {
      failedSms = failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextField(
        controller: _messageController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter the message",
        ),
      ),
      const SizedBox(height: 25),
      ElevatedButton(
          onPressed: _fetchAndSendSMS,
          child: const Text(
            'Send SMS',
          )),
      if (isLoading) const CircularProgressIndicator(),
      if (!isLoading && _errorMessage.isNotEmpty)
        Text(
          _errorMessage,
          style: const TextStyle(color: Color.fromARGB(255, 214, 46, 33)),
        ),
      if (!isLoading && failedSms.isNotEmpty)
        Expanded(
            child: ListView.builder(
                itemCount: failedSms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text('${failedSms[index]['Name']}'),
                      subtitle: Text(
                        '${failedSms[index]['Phone']})',
                      ));
                }))
    ]));
  }
}
