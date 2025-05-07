import 'package:edu_marshal/Model/student_attendence_data.dart';
import 'package:edu_marshal/Screens/Monthlyattendencelist.dart';
import 'package:edu_marshal/repository/overall_attendence_repository.dart';
import 'package:flutter/material.dart';

class DisplayScreen extends StatefulWidget {
  final String? subject;

  const DisplayScreen({Key? key, required this.subject}) : super(key: key);

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  final AttendanceRepository _repository = AttendanceRepository();

  List<StudentAttendanceData>? _attendanceDataList;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }


  Future<void> _fetchAttendanceData() async {
    final List<StudentAttendanceData>? attendanceDataList =
        await _repository.fetchAttendance();
    if (attendanceDataList != null) {
      setState(() {
        _attendanceDataList = attendanceDataList
            .where((data) => data.subject == widget.subject)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(242, 246, 255, 1),
      appBar: AppBar(
        title: Text('Attendance Display'),
      ),
      body: _attendanceDataList != null
          ? MonthlyAttendanceList(attendanceData: _attendanceDataList!,subject: widget.subject,)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}