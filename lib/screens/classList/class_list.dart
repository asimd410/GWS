import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';
import 'package:gws/screens/classList/divisionCreateView.dart';
import 'package:gws/screens/classList/academicYrCreateView.dart';
import 'package:gws/screens/classList/classCreateView.dart';
import 'package:gws/screens/classList/subjectsCreateView.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';




bool showAddAcadYr = false;
bool showAddClass = false;
String addClassName = "";
bool addClassNameError = false;
String addClassNameErrorText = "";
String? addAcadYrFrom;
bool addAcadYrErrorFrom = false;
String addAcadYrErrorTextFrom = "";
String? addAcadYrTo;
bool addAcadYrErrorTo = false;
String addAcadYrErrorTextTo = "";

class ClassList extends StatefulWidget {
  const ClassList({Key? key}) : super(key: key);

  @override
  State<ClassList> createState() => _ClassListState();
}

class _ClassListState extends State<ClassList> {
  List<bool> _isExpanded = List.generate(4, (_) => false);

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    print(_isExpanded);

    List<Widget> expansionPanelBody = [
      AcademicYrCreateView(),
      ClassCreateViewWig(),
      SubjectCreateViewWig(),
      DivCreateView(),
    ];
    List<Widget> expansionPanelBodyMob = [
      AcademicYrCreateView(),
      ClassCreateViewWig(),
      SubjectCreateViewWig(),
      DivCreateView(),
    ];
    List<String> expansionPanelTitle = ["Create View AcademicYear", "Create View Class", "Create View Subjects", "Add Division"];

    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Class List"))),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => SingleChildScrollView(
            child: Column(
              children: [
                ExpansionPanelList(
                  expansionCallback: (index, isExpanded) => setState(() {
                    setState(() {
                      _isExpanded[index] = !isExpanded;
                    });
                  }),
                  children: [
                    for (int i = 0; i < 4; i++)
                      ExpansionPanel(
                        canTapOnHeader: true,
                        body: screenW > mobileBrkPoint ? expansionPanelBody[i] : expansionPanelBodyMob[i],
                        headerBuilder: (_, isExpanded) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 50.0),
                              child: Text(
                                expansionPanelTitle[i],
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        },
                        isExpanded: _isExpanded[i],
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerMAIN(),
    );
  }
}
