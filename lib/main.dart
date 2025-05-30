import 'dart:io';

import 'package:edu_marshal/screen/Attendence/OverAllAttendence.dart';
import 'package:edu_marshal/Screens/Attendence/subject_wise_attendence.dart';
import 'package:edu_marshal/Screen/Login/login.dart';
import 'package:edu_marshal/Screen/Notes_Assignment/Subject_Assignment.dart';
import 'package:edu_marshal/Screen/User_Info/Personal_Info/Personal_Info_Data.dart';
// import 'package:edumarshals/Screens/User_Info/Personal_Info/profile_info.dart';
import 'package:edu_marshal/Screen/User_Info/Profile.dart';
import 'package:edu_marshal/Screens/User_Info/Subject_Data.dart';
import 'package:edu_marshal/Screen/splash.dart';
import 'package:edu_marshal/screen/time_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screen/HomePage/Homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager.init(); //
  HttpClient httpClient = new HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      //initialRoute: 'login',
       initialRoute: 'splashscreen',  
      routes: {
        'splashscreen': (context) => SplashScreen(),
        'homepage': (context) => const Homepage(),
        'login': (context) => Login(),
        'overallattendance': (context) => OverAllAttd(),
        'timetable': (context) => ExamTimetableScreen(),
        'profile': (context) => Profile(),
        //  'profileinfo':(context) => profileInfo(),
        'test_screen': (context) => Subject_Assignment(),

        'personalinfo': (context) => PersonalInfoScreen(),
        'subject_wise_attendance': (context) => barGraph(
              userName: "user",
              userImage: "vgc",
              subjectDescription: "your attendance is good",
              subjectName: "mathematics",
            ),
        'subject': (context) => Subjectdata(),
      },
    );
  }
}

class PreferencesManager {
  static late PreferencesManager _instance;
  late SharedPreferences _prefs;

  // private constructor
  PreferencesManager._();

  // factory method to access the singleton instance
  factory PreferencesManager() {
    return _instance;
  }

  // initialize the singleton instance
  static Future<void> init() async {
    _instance = PreferencesManager._();
    _instance._prefs = await SharedPreferences.getInstance();
  }

  // add methods for storing and retrieving data
  String get email => _prefs.getString('email') ?? '';
  set email(String value) => _prefs.setString('email', value);

  String get name => _prefs.getString('name') ?? '';
  set name(String value) => _prefs.setString('name', value);
  String get token => _prefs.getString('token') ?? '';
  set token(String value) => _prefs.setString('token', value);
  String get ack => _prefs.getString('ack') ?? '';
  set ack(String value) => _prefs.setString('ack', value);
  String get studentPhoto => _prefs.getString('studentPhoto') ?? '';
  set studentPhoto(String value) => _prefs.setString('studentPhoto', value);
  String get studentNumber => _prefs.getString('studentNumber') ?? '';
  set studentNumber(String value) => _prefs.setString('studentNumber', value);
  String get universityRollNumber =>
      _prefs.getString('universityRollNumber') ?? '';
  set universityRollNumber(String value) =>
      _prefs.setString('universityRollNumber', value);
  String get dob => _prefs.getString('dob') ?? '';
  set dob(String value) => _prefs.setString('dob', value);
  int get totalclasses => _prefs.getInt('totalclasses') ?? 0;
  set totalclasses(int value) => _prefs.setInt('totalclasses', value);

  int get presentclasses => _prefs.getInt('presentclasses') ?? 0;
  set presentclasses(int value) => _prefs.setInt('presentclasses', value);

  int get sem => _prefs.getInt('sem') ?? 0;
  set sem(int value) => _prefs.setInt('sem', value);
    String get userid => _prefs.getString('userid') ?? '';
  set userid(String value) => _prefs.setString('userid', value);

  // add more methods as needed
}
