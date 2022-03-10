import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';

import 'FilteredPanelStudent.dart';

class StudentsMain extends StatefulWidget {
  const StudentsMain({Key? key}) : super(key: key);

  @override
  State<StudentsMain> createState() => _StudentsMainState();
}

class _StudentsMainState extends State<StudentsMain> {
  final List<bool> _isExpanded = List.generate(1, (_) => false);

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30,
              width: 140,
              child: ElevatedButton(
                  onPressed: () {},
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
              });
            }),
            children: [
              for (int i = 0; i < 1; i++)
                ExpansionPanel(
                  canTapOnHeader: true,
                  body: screenW > mobileBrkPoint ? _expansionPanelBody[i] : _expansionPanelBodyMob[i],
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
        ],
      ),
      drawer: DrawerMAIN(),
    );
  }
}
