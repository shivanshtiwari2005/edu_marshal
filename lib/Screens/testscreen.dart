
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:edumarshals/Utils/floating_action%20_button.dart';
import 'package:edu_marshal/Model/student_attendence_data.dart';
import 'package:edu_marshal/Utils/attendence_list_card.dart';
import 'package:edu_marshal/Utils/daily_attendence_list_card.dart';
import 'package:edu_marshal/Utils/floating_action_button.dart';
import 'package:edu_marshal/Utils/weekly_widget.dart';
import 'package:edu_marshal/Widget/AttendenceCard.dart';
import 'package:edu_marshal/Widget/CommonDrawer.dart'; // Ensure this import is correct and the file exists
import 'package:edu_marshal/Widget/CustomAppBar.dart' as custom_app_bar;
import 'package:edu_marshal/main.dart';
import 'package:edu_marshal/repository/overall_attendence_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class testscreen extends StatefulWidget {
  final String userName;
  final String userImage;
  final String subjectName;
  final String subjectDescription;
  //final String userName;
  testscreen(
      {super.key,
      required this.userName,
      required this.userImage,
      required this.subjectName,
      required this.subjectDescription});
  final Color leftBarColor = Color(0xff004BB8);
  final Color rightBarColor = Color(0xff5299FF);
  final Color avgColor = Colors.orange;
  @override
  State<StatefulWidget> createState() => testscreenState();
}
final _key = GlobalKey<ExpandableFabState>();




class testscreenState extends State<testscreen> {
final GlobalKey<ScaffoldState> scaffoldKey_ = GlobalKey<ScaffoldState>();



  final AttendanceRepository _repository = AttendanceRepository();

  List<StudentAttendanceData>? _attendanceDataList;

  // ..............attendace api is intigrated ..................
  // final AttendanceRepository _repository = AttendanceRepository();
  // List<StudentAttendanceData>? _attendanceDataList;
  // int _totalClasses = 0;
  // int _totalPresentClasses = 0;




//.............calling attendance repository ...................................//


//   Future<void> _fetchAttendanceData() async {
//     List<StudentAttendanceData>? attendanceDataList =
//         await _repository.fetchAttendance();
//     int totalClasses = 0;
//     int totalPresentClasses = 0;
// //...............function to store total present and total classes .............//




//     if (attendanceDataList != null) {
//       for (var data in attendanceDataList) {
//         totalClasses += data.totalClasses ?? 0;
//         totalPresentClasses += data.totalPresent ?? 0;
//       }
//     }
//      void printAttendanceData(List<StudentAttendanceData> data) {
//     data.forEach((attendanceData) {
//       print('Subject: ${attendanceData.subject}');
//       print('Total Classes: ${attendanceData.totalClasses}');
//       print('Total Present: ${attendanceData.totalPresent}');
//       print('Attendance:');
//       attendanceData.attendance?.forEach((entry) {
//         print('  Date: ${entry.date}');
//         print('  Attended: ${entry.attended}');
//         print('  Is Academic: ${entry.isAc}');
//       });
//       print('\n');
//     });
//   }
//   print("hello");
//   if (attendanceDataList != null) {
//     printAttendanceData(attendanceDataList);
//   }

//   // if (attendanceDataList != null) {
//   //     setState(() {
//   //       _attendanceDataList = attendanceDataList;
//   //     });
//   //   }

//     setState(() {
//       _attendanceDataList = attendanceDataList ?? [];
      
//       // if(attendanceDataList!= null){
//       //    _attendanceDataList = attendanceDataList;
//       // }
//       _totalClasses = totalClasses;
//       print('totalclasses${_totalClasses}');
//       // PreferencesManager.totalclasses=_totalClasses;
//       // print('totalPresentClasses${_totalPresentClasses}');
//       _totalPresentClasses = totalPresentClasses;

//       PreferencesManager().totalclasses = _totalClasses;
//       PreferencesManager().presentclasses = _totalPresentClasses;

//       print('totalPresentClasses${_totalPresentClasses}');

//       // print('dfghj $attendanceDataList');
//       // PreferencesManager.totalclasses=_totalClasses;




      
//     });
//   }



//.............calling attendance repository ...................................//

  Future<void> _fetchAttendanceData() async {
    final List<StudentAttendanceData>? attendanceDataList =
        await _repository.fetchAttendance();
    if (attendanceDataList != null) {
      setState(() {
        _attendanceDataList = attendanceDataList;
        
      });
    }
  }


  //................attendance api is intigrated ....................//

  // final _key = GlobalKey<ExpandableFabState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final double width = 15;
  EasyInfiniteDateTimelineController _dailycontroller =
      EasyInfiniteDateTimelineController();
  DateTime _focusDate = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  String filter = 'Monthly'; // Default filter
  late Map<String, List<Widget>> filterWidgets;
  int touchedGroupIndex = -1;

  void _initFilterWidgets() {
    filterWidgets = {
      'Monthly': [
        // monthly()
        // _attendanceDataList != null
        //  ? MonthlyAttendanceList(attendanceData: _attendanceDataList!)
        //  : Center(
        //      child: CircularProgressIndicator(),
        //    )
      ],
      'Weekly': [
        _buildWeeklyWidgets(),
      ],
      'Daily': [
        _buildDailyWidgets(),
      ],
    };
  }



  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
    final barGroup1 = makeGroupData(0, 12, 5);
    final barGroup2 = makeGroupData(1, 16, 12);
    final barGroup3 = makeGroupData(2, 18, 5);
    final barGroup4 = makeGroupData(3, 20, 16);
    final barGroup5 = makeGroupData(4, 17, 6);
    final barGroup6 = makeGroupData(5, 14, 1.5);
    final barGroup7 = makeGroupData(6, 10, 1.5);
    _initFilterWidgets();

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.of(context).size.height;
    final swidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF2F6FF),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: custom_floating_action_button(Gkey: _key,),
      key: scaffoldKey_,
      appBar:
          custom_app_bar.CustomAppBar(
        userName: PreferencesManager().name,
        userImage: PreferencesManager().studentPhoto,
        onTap: () {
          scaffoldKey_.currentState?.openDrawer();
        },
        scaffoldKey_: scaffoldKey_,// Pass the _scaffoldKey
      ),
      drawer: CommonDrawer(
        scaffoldKey_: scaffoldKey_, currentIndex: 0, // Ensure CommonDrawer is defined in the imported file
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

// monthly(),
              Container(
                height: sheight * 0.18,
//.................fetching list in which all attendace is stored................//
                child: _attendanceDataList != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: _attendanceDataList!.length,
                              itemBuilder: (context, index) {
                                final attendanceData =
                                    _attendanceDataList![index];
//.......................assigning subject attendace to the SubjectAttendaceCard......//
                                if (attendanceData.subject == 'DSTL') {
                                  // Only render the SubjectAttendanceCard if the subject is Mathematics
                                  return AttendanceCard(
                                      attendedClasses:
                                          attendanceData.totalPresent!,
                                      totalClassess:
                                          attendanceData.totalClasses!,
                                      // title: widget.subjectName,
                                      title:
                                          'Subject: ${attendanceData.subject}',
                                      description: widget.subjectDescription);
                                  // SubjectAttendanceCard(
                                  //   subjectName:
                                  //       'Subject: ${attendanceData.subject}',
                                  //   attendedClasses:
                                  //       attendanceData.totalPresent!,
                                  //   totalClasses: attendanceData.totalClasses!,
                                  // );
                                } else {
                                  // Return an empty container for other subjects
                                  return Container();
                                }
                                // return SubjectAttendanceCard(
                                //   subjectName:
                                //       'Subject: ${attendanceData.subject}',
                                //   attendedClasses: attendanceData.totalPresent!,
                                //   totalClasses: attendanceData.totalClasses!,
                                // );
                              },
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: SizedBox(
                          height: 50, // Adjust the height as needed
                          width: 50, // Adjust the width as needed
                          child: CircularProgressIndicator(),
                        ),
                      ),
              ),
              // AttendanceCard(
              //     attendedClasses: 24,
              //     totalClassess: 28,
              //     // title: widget.subjectName,
              //     title: "Mathematics",
              //     description: widget.subjectDescription),

              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(width: 8),
                  Text("Attendance Chart",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    alignment: Alignment.center,
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Color(0xff004BB8),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Total Classes',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 5,
                              backgroundColor: Color(0xff5299FF),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Classes attended',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SizedBox(width: 1),
                  Text(" " + filter + " Attendance",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 25)),
                  IconButton(
                      onPressed: () {
                        showFilter();
                      },
                      icon: Image.asset('assets/filter.png'))
                ],
              ),
              SizedBox(
                height: 15,
              ),
             
              ...(filterWidgets[filter] ?? []).map((widget) => widget).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '10';
    } else if (value == 10) {
      text = '25';
    } else if (value == 19) {
      text = '50';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      'Aug\'23',
      'Sept\'23',
      'Oct\'23',
      'Nov\'23',
      'Dec\'23',
      'Jan\'24',
      'Feb\'24'
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 10,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }

  void showFilter() {
    showFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 0.41,
      context: context,
      builder: _buildBottomSheet,
      anchors: [0, 0.4, 0.41],
      isSafeArea: true,
    );
  }

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    return Material(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    "  Attendance",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel_outlined),
                  )
                ],
              ),
              Text(
                "Time",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              CustomRadioButton(
                //radius: 12,
                //shapeRadius: 24,
                enableShape: true,
                unSelectedBorderColor: Color(0xff004BB8),
                selectedBorderColor: Colors.white,
                defaultSelected: filter,
                // customShape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
                elevation: 0,
                absoluteZeroSpacing: false,
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  'Monthly',
                  'Weekly',
                  'Daily',
                ],
                buttonValues: ['Monthly', 'Weekly', 'Daily'],
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Color(0xff004BB8),
                    textStyle:
                        TextStyle(fontSize: 14, color: Color(0xff004BB8))),
                radioButtonValue: (value) {
                  setFilter(value);
                },
                selectedColor: Color(0xff004BB8),
              ),
              SizedBox(
                height: 14,
              ),
              Text(
                "Absence/Presence",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              CustomCheckBoxGroup(
                enableShape: true,
                unSelectedBorderColor: Color(0xff004BB8),
                // selectedBorderColor: Colors.white,
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: Colors.white,
                    unSelectedColor: Color(0xff004BB8),
                    textStyle: TextStyle(fontSize: 14)),
                unSelectedColor: Theme.of(context).canvasColor,
                buttonLables: [
                  "Absent",
                  "Present",
                ],
                buttonValuesList: [
                  "Absent",
                  "Present",
                ],
                checkBoxButtonValues: (values) {
                  print(values);
                },
                spacing: 12,
                defaultSelected: ["Present"],
                horizontal: false,
                enableButtonWrap: false,
                //width: 40,
                //absoluteZeroSpacing: false,
                selectedColor: Color(0xff004BB8),
                padding: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xff004BB8)),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.white)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Apply"))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setFilter(String value) {
    setState(() {
      filter = value;
    });
  }

  Widget _buildDailyWidgets() {
    return Column(
      children: [
        EasyInfiniteDateTimeLine(
          dayProps: EasyDayProps(
              dayStructure: DayStructure.dayNumDayStr,
              height: 38,
              width: 60,
              inactiveDayStyle: DayStyle(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  dayNumStyle: TextStyle(
                      color: Color(0xff004BB8), fontWeight: FontWeight.w500),
                  dayStrStyle: TextStyle(
                      color: Color(0xff004BB8), fontWeight: FontWeight.w500))),
          controller: _dailycontroller,
          activeColor: Color(0xff004BB8),
          firstDate: DateTime(2023),
          focusDate: _focusDate,
          lastDate: DateTime.now(),
          showTimelineHeader: false,
          onDateChange: (selectedDate) {
            setState(() {
              print(selectedDate);
              _focusDate = selectedDate;
              print(_focusDate);
            });
          },
        ),
        SizedBox(
          height: 15,
        ),
        DailyAttendanceListCard(
            date: _focusDate, isPresent: [true, false, true])
      ],
    );
  }

  Widget _buildWeeklyWidgets() {
    return Column(
      children: [
        WeeklyDatePicker(
          selectedDay: DateTime.now(),
          changeDay: (value) => setState(() {
            _selectedDay = value;
          }),
        ),
        AttendanceListCard(date: "Mon", isPresent: [true, true, true]),
        AttendanceListCard(date: "Tue", isPresent: [
          true,
        ]),
        AttendanceListCard(date: "Wed", isPresent: [false, false]),
        AttendanceListCard(date: "Thu", isPresent: [true]),
        AttendanceListCard(date: "Fri", isPresent: [true, true]),
        AttendanceListCard(date: "Sat", isPresent: []),
        AttendanceListCard(date: "Sun", isPresent: []),
      ],
    );
  }
  // Widget monthly(){
  //   return   _attendanceDataList != null
  //        ? MonthlyAttendanceList(attendanceData: _attendanceDataList!,subject: ,)
  //        : Center(
  //            child: CircularProgressIndicator(),
  //          );
  // }
}
