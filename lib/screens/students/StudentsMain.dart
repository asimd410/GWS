import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';
import 'package:provider/provider.dart';

import 'DataTableStudents/DataTableForStudentInfo.dart';
import 'FilteredPanelStudent.dart';
import 'add_student_page.dart';
import 'delete_studentPage.dart';
import 'edit_studentPage.dart';

bool showAddStudent = false;

class StudentsMain extends StatefulWidget {
  const StudentsMain({Key? key}) : super(key: key);

  @override
  State<StudentsMain> createState() => _StudentsMainState();
}

class _StudentsMainState extends State<StudentsMain> {
  List<bool> _isExpanded = List.generate(1, (_) => false);

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    print(_isExpanded);
    //---------------------------- Filter Search Expansion Panel -----------------------------
    List<Widget> _expansionPanelBody = [
      FilteredPanelDesktop(screenW: screenW),
    ];
    List<Widget> _expansionPanelBodyMob = [Container()];
    List<String> _expansionPanelTitle = ["Filtered Search"];
    //---------------------------- Filter Search Expansion Panel CLOSED ----------------------
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 75.0),
            child: Text("Student Info"),
          ),
        ),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Provider.of<Data>(context, listen: true).refreshStudentMain == true
              ? Stack(
                  children: [
                    StudentMainSub(),
                    funcIfElseWidgetReturnTrue(showAddStudent, const AddStudentPage()),
                    funcIfElseWidgetReturnTrue(showEditStudentDetials, const EditStudentPage()),
                    funcIfElseWidgetReturnTrue(showDeleteStudentPage, const Delete_StudentPage()),
                  ],
                )
              : Stack(
                  children: [
                    StudentMainSub(),
                    funcIfElseWidgetReturnTrue(showAddStudent, const AddStudentPage()),
                    funcIfElseWidgetReturnTrue(showEditStudentDetials, const EditStudentPage()),
                    funcIfElseWidgetReturnTrue(showDeleteStudentPage, const Delete_StudentPage()),
                  ],
                ),
        ),
      ), //COPY
      drawer: DrawerMAIN(),
    );
  }
}
//_____________________________________________________________________________________________________________________________________________

class StudentMainSub extends StatefulWidget {
  const StudentMainSub({Key? key}) : super(key: key);

  @override
  State<StudentMainSub> createState() => _StudentMainSubState();
}

class _StudentMainSubState extends State<StudentMainSub> {
  List<bool> _isExpanded = List.generate(1, (_) => false);

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    print(_isExpanded);
    //---------------------------- Filter Search Expansion Panel -----------------------------
    List<Widget> _expansionPanelBody = [
      FilteredPanelDesktop(screenW: screenW),
    ];
    List<String> _expansionPanelTitle = ["Filtered Search"];
    //---------------------------- Filter Search Expansion Panel CLOSED ----------------------
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              width: 140,
              child: ElevatedButton(
                  onPressed: () async {
                    final progress = ProgressHUD.of(context);
                    progress?.show();
                    // Navigator.pushNamed(context, '/AddStudentPage');
                    await funcToGenerateRandomUserName(10);
                    initialValuePassword = functionPasswordGenerator();
                    progress?.dismiss();
                    setState(() {
                      showAddStudent = true;
                      Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Add Student"),
                      Icon(Icons.add),
                    ],
                  )),
            ),
          ), //ADD STUDENT BUTTON
          ExpansionPanelList(
            expansionCallback: (index, isExpanded) => setState(() {
              setState(() {
                _isExpanded[index] = !isExpanded;
                Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
              });
            }),
            children: [
              for (int i = 0; i < 1; i++)
                ExpansionPanel(
                  canTapOnHeader: true,
                  body: _expansionPanelBody[i],
                  headerBuilder: (_, isExpanded) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Text(
                          _expansionPanelTitle[i],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  },
                  isExpanded: _isExpanded[i],
                ),
            ],
          ), //FILTER PANEL
          SizedBox(
              height:screenH-200,
              child:refreshStudentTable == false?
              Container()
                  : DataPageStudentInfo(width: screenW, height:screenH-200)),
        ],
      ),
    );
  }
}


