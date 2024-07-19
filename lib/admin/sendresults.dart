
import 'package:flutter/material.dart';
//import 'package:flutter_sms/flutter_sms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class sendresults extends StatefulWidget {
  const sendresults({Key? key}) : super(key: key);

  @override
  State<sendresults> createState() => _sendresultsState();
}

class _sendresultsState extends State<sendresults> {
  List<Map<String, dynamic>> studentData = [];
  List<Map<String, dynamic>> markData = [];
  List<Map<String, dynamic>> failedSms = [];
  bool isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
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
      List<Map<String, dynamic>> stddata = [];
      List<Map<String, dynamic>> markdata = [];
      QuerySnapshot teacherCollection =
          await FirebaseFirestore.instance.collection('teachers').get();
      for (QueryDocumentSnapshot teacherid in teacherCollection.docs) {
        QuerySnapshot studentCollection =
            await teacherid.reference.collection('class').get();

        for (QueryDocumentSnapshot studentdoc in studentCollection.docs) {
          QuerySnapshot examCollection =
              await studentdoc.reference.collection('exam').get();
          stddata.add({
            'Name': studentdoc['Name'],
            'Phone': studentdoc['Phone'],
            'ID': studentdoc['ID'],
          });

          for (QueryDocumentSnapshot examdoc in examCollection.docs) {
            markdata.add({
              'Tamil': examdoc['Tamil'],
              'English': examdoc['English'],
              'Maths': examdoc['Maths'],
              'Physics': examdoc['Physics'],
              'Chemistry': examdoc['Chemistry'],
            });
          }
        }
      }
      setState(() {
        studentData = stddata;
        markData = markdata;
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

    for (int i = 0; i < studentData.length; i++) {
      var student = studentData[i];
      var mark = markData[i];

      List<String> recipients = [student['Phone']];
      String message = '''
          Hello ${student['Name']}(${student['ID']}), 
           
          Your marks are: 
          Tamil:${mark['Tamil']}
          English:${mark['English']}
          Maths:${mark['Maths']}
          Phisics:${mark['Physics']}
          Chemistry:${mark['Chemistry']}
          ''';
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
                      subtitle: Text('${failedSms[index]['Phone']})'));
                }))
    ]));
  }
}
