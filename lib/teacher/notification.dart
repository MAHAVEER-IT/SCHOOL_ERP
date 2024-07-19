import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class notificationpage extends StatefulWidget {
  final String teacherId;
  const notificationpage({Key? key, required this.teacherId}) : super(key: key);
  @override
  State<notificationpage> createState() => _notificationpage();
}

class _notificationpage extends State<notificationpage> {
  List<Map<String, dynamic>> teachernotification = [];
  var isLoading = true;
  var _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchnotification();
  }

  Future<void> _fetchnotification() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(widget.teacherId)
          .collection('notification')
          .get();
      List<Map<String, dynamic>> data = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      setState(() {
        teachernotification = data;
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Unknow Error ?';
        isLoading = false;
      });
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
              ),
            )
          : ListView.builder(
              itemCount: teachernotification.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> notification = teachernotification[index];
                return Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: notification.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(entry.value.toString())
                              ],
                            ),
                          );
                        }).toList()),
                  ),
                );
              },
            ),
    );
  }
}
