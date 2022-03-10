import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import 'dataTable/DataTableForDivisionView.dart';

bool addDivision = false;
List<String> listOfAcadYr = [];
List<String> listOfClass = [];
List<String> listOfSubjects = [];
List<dynamic> listOfMainFees = [
  [
    "^",
    "^",
    ["^", "^", "^"]
  ]
];
List<dynamic> listOfExtraFees = [];
int ExtraFeesNumber = 0;

List<Widget> ExtraFeesWig = [];

String? _chosenValueAcadYr;
String? divisionName;
String? _chosenValueClass;
String? _chosenValueAdmissionFees;
List<String>? _chosenValueSubjects;

class DivCreateView extends StatefulWidget {
  @override
  State<DivCreateView> createState() => _DivCreateViewState();
}

class _DivCreateViewState extends State<DivCreateView> {
  final ScrollController _controllerOne = ScrollController();

  // final ScrollController _controllerTwo = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey.shade50,
      child: Provider.of<Data>(context, listen: true).refrashPageEditDivision == true
          ? DevisionCreateViewSUB(screenW: screenW)
          : DevisionCreateViewSUB(screenW: screenW),
    );
  }
}

//----------------------------------- MAIN --------------------------------------
class DevisionCreateViewSUB extends StatefulWidget {
  double screenW;

  DevisionCreateViewSUB({required this.screenW});

  @override
  _DevisionCreateViewSUBState createState() => _DevisionCreateViewSUBState();
}

class _DevisionCreateViewSUBState extends State<DevisionCreateViewSUB> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final progress = ProgressHUD.of(context);
                  progress?.show();
                  showAcadYr_responseBodyJSON = await httpPost(
                    msgToSend: {"msg": "viewAcadYrinDB"},
                    destinationPort: 8080,
                    destinationPost: "/addAcademicYear/viewAcadYrinDB",
                    destinationUrl: mainDomain,
                  );
                  showClass_responseBodyJSON = await httpPost(
                    msgToSend: {"msg": "viewClassesinDB"},
                    destinationPort: 8080,
                    destinationPost: "/addClass/viewClassesinDB",
                    destinationUrl: mainDomain,
                  );
                  showSubject_responseBodyJSON = await httpPost(
                    msgToSend: {"msg": "viewSubjectinDB"},
                    destinationPort: 8080,
                    destinationPost: "/addsubject/viewSubjectinDB",
                    destinationUrl: mainDomain,
                  );

                  showAcadYr_responseBody = json.decode(showAcadYr_responseBodyJSON!);
                  showClass_responseBody = json.decode(showClass_responseBodyJSON!);
                  showSubject_responseBody = json.decode(showSubject_responseBodyJSON!);

                  listOfAcadYr.clear();
                  for (var i in showAcadYr_responseBody) {
                    listOfAcadYr.add(i["year"]);
                  }
                  listOfClass.clear();
                  for (var i in showClass_responseBody) {
                    listOfClass.add(i["standard_name"]);
                  }
                  listOfSubjects.clear();
                  for (var i in showSubject_responseBody) {
                    listOfSubjects.add(i["subject_name"]);
                  }

                  progress?.dismiss();
                  setState(() {
                    addDivision = true;
                  });
                },
                child: const Text("Add Division")), //ADD DIVISION BUTTON
            SizedBox(
                height: 700,
                width: widget.screenW,
                child: addDivision == true
                    ? Container()
                    : showEditDivision == true
                        ? Container()
                        : delDivision == true
                            ? Container()
                            : DataPageDivision(width: widget.screenW < 1000 ? 1000 : widget.screenW)), //DateTable
            const SizedBox(height: 10)
          ],
        ),
        addDivision == true
            ? DivisionCreateViewADD(
                screenW: widget.screenW,
              )
            : Container(), //AddDivPage
        showEditDivision == true
            ? DevisionCreateViewEDIT(
                screenW: widget.screenW,
              )
            : Container(),
        delDivision == true ? const DevisionCreateViewDELETE() : Container(),
      ],
    );
  }
}

//_____________________________________ Add Division ____________________________________________________

class DivisionCreateViewADD extends StatefulWidget {
  double screenW;

  DivisionCreateViewADD({required this.screenW});

  @override
  State<DivisionCreateViewADD> createState() => _DivisionCreateViewADDState();
}

class _DivisionCreateViewADDState extends State<DivisionCreateViewADD> {
  late ScrollController _controllerOne = ScrollController();
  late TextEditingController _controllerAdmissionFees;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chosenValueAcadYr = null;
    divisionName = null;
    _chosenValueClass = null;
    _chosenValueAdmissionFees = null;
    _chosenValueSubjects = null;

    _controllerAdmissionFees = TextEditingController(text: editAdmissionFeesToEdit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: (widget.screenW) - 2,
      child: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Container(
                        //TOP BAR
                        height: 30,
                        width: widget.screenW > 700 ? 700 : widget.screenW,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widget.screenW > 700 ? 660 : widget.screenW - 40,
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Add Division",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  listOfMainFees = [
                                    [
                                      "^",
                                      "^",
                                      ["^", "^", "^"]
                                    ]
                                  ];
                                  setState(() {
                                    addDivision = false;
                                  });
                                },
                                splashColor: Colors.white,
                                // autofocus: true,
                                child: Ink(
                                    height: 30,
                                    width: 30,
                                    child: const Center(
                                        child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    )
                                        // const Text("X",
                                        //   style: TextStyle(fontWeight: FontWeight.bold ,
                                        //       color: Colors.white),),
                                        // )
                                        )),
                              ),
                            )
                          ],
                        ),
                        color: Colors.blue), //TOP BAR
                    Scrollbar(
                      controller: _controllerOne,
                      child: SingleChildScrollView(
                        controller: _controllerOne,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            widget.screenW > mobileBrkPoint
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 20),
                                      SizedBox(
                                        //Acad Yr, Class, Subject
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Column(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    divisionName = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Division Name')),
                                              ),
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                items: listOfAcadYr,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select an Acad Yr",
                                                  labelText: "Academic Year *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueAcadYr = v;
                                                },
                                                // selectedItem: "2021-2022",
                                              ), //AACADEMIC YEAR
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                items: listOfClass,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select a Class",
                                                  labelText: "Class *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                onChanged: (v) {
                                                  _chosenValueClass = v;
                                                },
                                              ), //CLASS
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>.multiSelection(
                                                dialogMaxWidth: 100,
                                                maxHeight: 500,
                                                mode: Mode.DIALOG,
                                                items: listOfSubjects,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select Subjects",
                                                  labelText: "Subjects *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                                  // border: OutlineInputBorder(),
                                                ),
                                                // isFilteredOnline:true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueSubjects = v;
                                                },
                                              ), //SUBJECTS
                                              const SizedBox(height: 20),
                                              TextField(
                                                controller: _controllerAdmissionFees,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _chosenValueAdmissionFees = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: funcValEmptyOrNumberAdmissionFee(_chosenValueAdmissionFees, "Admission Fees"),
                                                    // divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Admission Fee')),
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                        //CREATE DIVISION
                                                        onPressed: () async {
                                                          bool isValid = true;
                                                          //---------------- VALIDATION --------------------
                                                          if (divisionName == null) {
                                                            isValid = false;
                                                            print("error1");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Division name cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueAcadYr == null) {
                                                            isValid = false;
                                                            print("error2");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Academic Year cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueClass == null) {
                                                            isValid = false;
                                                            print("error3");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Class cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (funcValEmptyOrNumberBool(_chosenValueAdmissionFees) == true) {
                                                            isValid = false;
                                                            print("error3");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Admission Fee cannot be empty or an invalid number'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueSubjects == null) {
                                                            isValid = false;
                                                            print("error4");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Subjects cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          //--------------------------- MAIN FEE VALIDATION --------------------------------------------------
                                                          else if (listOfMainFees[0][0] == "^" || listOfMainFees[0][0] == null) {
                                                            isValid = false;
                                                            print("error5");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Fee Title cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (listOfMainFees[0][1] == "^" || listOfMainFees[0][1] == null) {
                                                            isValid = false;
                                                            print("error6");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Total Fees cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (funcValEmptyOrNumberBool(listOfMainFees[0][1]) == true) {
                                                            isValid = false;
                                                            print("error6.1");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Total Fees cannot be empty or have invalid number'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                            if (listOfMainFees[0][i][0] == "^" || listOfMainFees[0][i][0] == "") {
                                                              isValid = false;
                                                              print("error7");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Title ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (listOfMainFees[0][i][1] == "^" || listOfMainFees[0][i][1] == "") {
                                                              isValid = false;
                                                              print("error8");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Amount ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][1]) == true) {
                                                              isValid = false;
                                                              print("error8");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text(
                                                                      'Sub Fee Amount ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (listOfMainFees[0][i][2] == "^" || listOfMainFees[0][i][2] == "") {
                                                              isValid = false;
                                                              print("error9");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Priority ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][2]) == true) {
                                                              isValid = false;
                                                              print("error9");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text(
                                                                      'Sub Fee Priority ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            }
                                                          }

                                                          double _balFee = functoChkBalFee(listOfMainFees[0][1], listOfMainFees, 0);
                                                          if (_balFee != 0) {
                                                            isValid = false;
                                                            print("error10");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('The Balance Fee for Main Fee has to be 0'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          //_______________________________ EXTRA FEE VALIDATION ________________________
                                                          if (listOfExtraFees.isNotEmpty) {
                                                            for (int i = 0; i < listOfExtraFees.length; i++) {
                                                              if (listOfExtraFees[i][0] == "^" || listOfExtraFees[i][0] == "") {
                                                                isValid = false;
                                                                print("error11");

                                                                setState(() {
                                                                  final snackBar = SnackBar(
                                                                    content: Text('Fee Title for Extra Fee ${i + 1} cannot be empty'),
                                                                    backgroundColor: (Colors.red),
                                                                    action: SnackBarAction(
                                                                      label: 'dismiss',
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                              } else if (listOfExtraFees[i][1] != "^" || listOfExtraFees[i][1] != "") {
                                                                String? _tempNotANummber = funcValEmptyOrNumber(listOfExtraFees[i][1], "Total Fee");
                                                                if (_tempNotANummber != null) {
                                                                  if (_tempNotANummber == "Total Fee has to be a number" ||
                                                                      _tempNotANummber == "Total Fee is an invalid number") {
                                                                    isValid = false;
                                                                    print("error12");
                                                                    setState(() {
                                                                      final snackBar = SnackBar(
                                                                        content: Text('Total Fee for Extra Fee ${i + 1} has to be a Valid Number'),
                                                                        backgroundColor: (Colors.red),
                                                                        action: SnackBarAction(
                                                                          label: 'dismiss',
                                                                          textColor: Colors.white,
                                                                          onPressed: () {},
                                                                        ),
                                                                      );
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    });
                                                                  } else if (_tempNotANummber == "Total Fee cannot be empty") {
                                                                    isValid = false;
                                                                    print("error13");
                                                                    setState(() {
                                                                      final snackBar = SnackBar(
                                                                        content: Text('Total Fee for Extra Fee ${i + 1} cannot be empty'),
                                                                        backgroundColor: (Colors.red),
                                                                        action: SnackBarAction(
                                                                          label: 'dismiss',
                                                                          textColor: Colors.white,
                                                                          onPressed: () {},
                                                                        ),
                                                                      );
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              for (int j = 2; j < listOfExtraFees[i].length; j++) {
                                                                if (listOfExtraFees[i][j][0] == "^" || listOfExtraFees[i][j][0] == "") {
                                                                  isValid = false;
                                                                  print("error14");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text('Sub Fee Title ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (listOfExtraFees[i][j][1] == "^" || listOfExtraFees[i][j][1] == "") {
                                                                  isValid = false;
                                                                  print("error15");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content:
                                                                          Text('Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][1]) == true) {
                                                                  isValid = false;
                                                                  print("error15");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text(
                                                                          'Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (listOfExtraFees[i][j][2] == "^" || listOfExtraFees[i][j][2] == "") {
                                                                  isValid = false;
                                                                  print("error16");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content:
                                                                          Text('Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][2]) == true) {
                                                                  isValid = false;
                                                                  print("error16");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text(
                                                                          'Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                }
                                                              }

                                                              double _balFee = functoChkBalFee(listOfExtraFees[i][1], listOfExtraFees, i);
                                                              if (_balFee != 0) {
                                                                isValid = false;
                                                                print("error17");
                                                                setState(() {
                                                                  final snackBar = SnackBar(
                                                                    content: Text('The Balance Fee for Extra Fee ${i + 1} has to be 0'),
                                                                    backgroundColor: (Colors.red),
                                                                    action: SnackBarAction(
                                                                      label: 'dismiss',
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                              }
                                                            }
                                                          }
                                                          //---------------- VALIDATION Closed --------------------

                                                          //_______________________________ FEE to Proper Map for Server ________________________
                                                          Map<String, dynamic> tempFeesCompiled = {};
                                                          print("%%%%%%%^^^^^^^^^&&&&&&$listOfMainFees%%%%%%%%%%##########@@@@@@@@@@@@");
                                                          List<Map<String, dynamic>> _tempMainFeesSubList = [];
                                                          if (listOfMainFees[0].length > 3) {
                                                            for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                              // MainFeesSub _tempMainFeesSub =
                                                              //     MainFeesSub(sub_fees_title: listOfMainFees[0][i][0],sub_amount:listOfMainFees[0][i][1] ,fee_priority:listOfMainFees[0][i][2] );
                                                              // _tempMainFeesSubList.add(_tempMainFeesSub);

                                                              Map<String, dynamic> _tempMainFeesSub = {
                                                                "sub_fees_title": listOfMainFees[0][i][0],
                                                                "sub_amount": listOfMainFees[0][i][1],
                                                                "fee_priority": listOfMainFees[0][i][2]
                                                              };
                                                              _tempMainFeesSubList.add(_tempMainFeesSub);
                                                            }
                                                          } else {
                                                            Map<String, dynamic> _tempMainFeesSub = {
                                                              "sub_fees_title": listOfMainFees[0][2][0],
                                                              "sub_amount": listOfMainFees[0][2][1],
                                                              "fee_priority": listOfMainFees[0][2][2]
                                                            };
                                                            _tempMainFeesSubList.add(_tempMainFeesSub);
                                                          }

                                                          Map<String, dynamic> _tempMainFees = {
                                                            "fee_title": listOfMainFees[0][0],
                                                            "total_fees": listOfMainFees[0][1],
                                                            "sub_of_fees": _tempMainFeesSubList
                                                          };
                                                          tempFeesCompiled["main_fees"] = [_tempMainFees];

                                                          List<Map<String, dynamic>> _tempExtraFeesList = [];

                                                          if (listOfExtraFees.isNotEmpty) {
                                                            for (List<dynamic> i in listOfExtraFees) {
                                                              List<Map<String, dynamic>> _tempExtraFeesSubList = [];
                                                              if (i.length > 3) {
                                                                for (int j = 2; j < i.length; j++) {
                                                                  Map<String, dynamic> _tempExtraFeesSub = {
                                                                    "extra_sub_fees_title": i[j][0],
                                                                    "extra_sub_amount": i[j][1],
                                                                    "extra_fee_priority": i[j][2]
                                                                  };
                                                                  _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                                }
                                                              } else {
                                                                Map<String, dynamic> _tempExtraFeesSub = {
                                                                  "extra_sub_fees_title": i[2][0],
                                                                  "extra_sub_amount": i[2][1],
                                                                  "extra_fee_priority": i[2][2]
                                                                };
                                                                _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                              }
                                                              Map<String, dynamic> _tempExtraFees = {
                                                                "extra_fee_title": i[0],
                                                                "extra_total_fee": i[1],
                                                                "extra_sub_of_fees": _tempExtraFeesSubList
                                                              };
                                                              _tempExtraFeesList.add(_tempExtraFees);
                                                            }
                                                          }

                                                          tempFeesCompiled["extra_fee"] = _tempExtraFeesList;
                                                          tempFeesCompiled["admission_fees"] = _chosenValueAdmissionFees;

                                                          print("**************************************************************************");
                                                          print("isValid == $isValid");
                                                          print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                                          print("**************************************************************************");

                                                          if (isValid == true) {
                                                            print("isValid == true");
                                                            createDivision_responseBody = await httpPost(
                                                              msgToSend: {
                                                                "division_name": divisionName,
                                                                "academic_year": _chosenValueAcadYr!,
                                                                "std": _chosenValueClass!,
                                                                "subjects": _chosenValueSubjects!,
                                                                "updatedBy": userName,
                                                                "fees": tempFeesCompiled,
                                                              },
                                                              destinationPort: 8080,
                                                              destinationPost: "/addDivision",
                                                              destinationUrl: mainDomain,
                                                            );
                                                            print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                                            setState(() {
                                                              addDivision = false;
                                                            });
                                                            if (editDivision_responseBody == "Saved") {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text("Division has been successfully created"),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                addDivision = false;
                                                                Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                              });
                                                            } else if (editDivision_responseBody == "Division Alread Exists") {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text("Division Alread Exists"),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                addDivision = false;
                                                                Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text('Sorry encountered a server error'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            }
                                                          } else {
                                                            print("isValid == false;");
                                                          }
                                                        },
                                                        child: const SizedBox(width: 200, height: 50, child: Center(child: Text("Create Division")))),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ), //Acad Yr, Class, Subject
                                      SizedBox(
                                        width: 300,
                                        child: SizedBox(
                                          width: 300,
                                          // height:750,
                                          child: FeesAddInDivisionMainFees(mainfeeNumber: 0),
                                        ),
                                      ), //Main Fees
                                      SizedBox(
                                          // height:750,
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ExtraFeesNumber = ExtraFeesNumber + 1;
                                                      setState(() {
                                                        listOfExtraFees.add([
                                                          "^",
                                                          "^",
                                                          ["^", "^", "^"]
                                                        ]);
                                                        ExtraFeesWig.add(FeesAddInDivisionExtraFees(
                                                          extrafeeNumber: ExtraFeesNumber - 1,
                                                        ));
                                                      });
                                                    },
                                                    child: const Text("Add Extra Fees")),
                                                const SizedBox(width: 10),
                                                ExtraFeesNumber > 0
                                                    ? ElevatedButton(
                                                        onPressed: () {
                                                          ExtraFeesNumber = ExtraFeesNumber - 1;
                                                          setState(() {
                                                            listOfExtraFees.remove(listOfExtraFees.last);
                                                            ExtraFeesWig.remove(ExtraFeesWig.last);
                                                          });
                                                        },
                                                        child: const Text("Remove Extra Fees"))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: ExtraFeesWig,
                                          )
                                          // Column(children:)
                                        ],
                                      )) //Extra Fees
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 20),
                                      SizedBox(
                                        //Acad Yr, Class, Subject
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Column(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    divisionName = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Division Name')),
                                              ),
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                items: listOfAcadYr,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select an Acad Yr",
                                                  labelText: "Academic Year *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueAcadYr = v;
                                                },
                                                // selectedItem: "2021-2022",
                                              ), //AACADEMIC YEAR
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                items: listOfClass,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select a Class",
                                                  labelText: "Class *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                onChanged: (v) {
                                                  _chosenValueClass = v;
                                                },
                                              ), //CLASS
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>.multiSelection(
                                                dialogMaxWidth: 100,
                                                maxHeight: 500,
                                                mode: Mode.DIALOG,
                                                items: listOfSubjects,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select Subjects",
                                                  labelText: "Subjects *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                                  // border: OutlineInputBorder(),
                                                ),
                                                // isFilteredOnline:true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueSubjects = v;
                                                },
                                              ), //SUBJECTS
                                              const SizedBox(height: 20),
                                              TextField(
                                                controller: _controllerAdmissionFees,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _chosenValueAdmissionFees = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: funcValEmptyOrNumberAdmissionFee(_chosenValueAdmissionFees, "Admission Fees"),
                                                    // divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Admission Fee')),
                                              ),
                                              const SizedBox(height: 20),
                                            ],
                                          ),
                                        ),
                                      ), //Acad Yr, Class, Subject
                                      SizedBox(
                                        width: 300,
                                        child: SizedBox(
                                          width: 300,
                                          // height:750,
                                          child: FeesAddInDivisionMainFees(mainfeeNumber: 0),
                                        ),
                                      ), //Main Fees
                                      SizedBox(
                                          // height:750,
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ExtraFeesNumber = ExtraFeesNumber + 1;
                                                      setState(() {
                                                        listOfExtraFees.add([
                                                          "^",
                                                          "^",
                                                          ["^", "^", "^"]
                                                        ]);
                                                        ExtraFeesWig.add(FeesAddInDivisionExtraFees(
                                                          extrafeeNumber: ExtraFeesNumber - 1,
                                                        ));
                                                      });
                                                    },
                                                    child: const Text("Add Extra Fees")),
                                                const SizedBox(width: 10),
                                                ExtraFeesNumber > 0
                                                    ? ElevatedButton(
                                                        onPressed: () {
                                                          ExtraFeesNumber = ExtraFeesNumber - 1;
                                                          setState(() {
                                                            listOfExtraFees.remove(listOfExtraFees.last);
                                                            ExtraFeesWig.remove(ExtraFeesWig.last);
                                                          });
                                                        },
                                                        child: const Text("Remove Extra Fees"))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: ExtraFeesWig,
                                          )
                                          // Column(children:)
                                        ],
                                      )), //Extra Fees
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            //CREATE DIVISION
                                            onPressed: () async {
                                              bool isValid = true;
                                              //---------------- VALIDATION --------------------
                                              if (divisionName == null) {
                                                isValid = false;
                                                print("error1");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Division name cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (_chosenValueAcadYr == null) {
                                                isValid = false;
                                                print("error2");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Academic Year cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (_chosenValueClass == null) {
                                                isValid = false;
                                                print("error3");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Class cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (funcValEmptyOrNumberBool(_chosenValueAdmissionFees) == true) {
                                                isValid = false;
                                                print("error3");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Admission Fee cannot be empty or an invalid number'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (_chosenValueSubjects == null) {
                                                isValid = false;
                                                print("error4");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Subjects cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              }

                                              //--------------------------- MAIN FEE VALIDATION --------------------------------------------------
                                              else if (listOfMainFees[0][0] == "^" || listOfMainFees[0][0] == null) {
                                                isValid = false;
                                                print("error5");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Fee Title cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (listOfMainFees[0][1] == "^" || listOfMainFees[0][1] == null) {
                                                isValid = false;
                                                print("error6");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Total Fees cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (funcValEmptyOrNumberBool(listOfMainFees[0][1]) == true) {
                                                isValid = false;
                                                print("error6.1");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Total Fees cannot be empty or have invalid number'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              }

                                              for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                if (listOfMainFees[0][i][0] == "^" || listOfMainFees[0][i][0] == "") {
                                                  isValid = false;
                                                  print("error7");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Sub Fee Title ${i - 1} of Main Fee cannot be empty'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                } else if (listOfMainFees[0][i][1] == "^" || listOfMainFees[0][i][1] == "") {
                                                  isValid = false;
                                                  print("error8");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Sub Fee Amount ${i - 1} of Main Fee cannot be empty'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][1]) == true) {
                                                  isValid = false;
                                                  print("error8");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Sub Fee Amount ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                } else if (listOfMainFees[0][i][2] == "^" || listOfMainFees[0][i][2] == "") {
                                                  isValid = false;
                                                  print("error9");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Sub Fee Priority ${i - 1} of Main Fee cannot be empty'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][2]) == true) {
                                                  isValid = false;
                                                  print("error9");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Sub Fee Priority ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                }
                                              }

                                              double _balFee = functoChkBalFee(listOfMainFees[0][1], listOfMainFees, 0);
                                              if (_balFee != 0) {
                                                isValid = false;
                                                print("error10");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('The Balance Fee for Main Fee has to be 0'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              }

                                              //_______________________________ EXTRA FEE VALIDATION ________________________
                                              if (listOfExtraFees.isNotEmpty) {
                                                for (int i = 0; i < listOfExtraFees.length; i++) {
                                                  if (listOfExtraFees[i][0] == "^" || listOfExtraFees[i][0] == "") {
                                                    isValid = false;
                                                    print("error11");

                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content: Text('Fee Title for Extra Fee ${i + 1} cannot be empty'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  } else if (listOfExtraFees[i][1] != "^" || listOfExtraFees[i][1] != "") {
                                                    String? _tempNotANummber = funcValEmptyOrNumber(listOfExtraFees[i][1], "Total Fee");
                                                    if (_tempNotANummber != null) {
                                                      if (_tempNotANummber == "Total Fee has to be a number" ||
                                                          _tempNotANummber == "Total Fee is an invalid number") {
                                                        isValid = false;
                                                        print("error12");
                                                        setState(() {
                                                          final snackBar = SnackBar(
                                                            content: Text('Total Fee for Extra Fee ${i + 1} has to be a Valid Number'),
                                                            backgroundColor: (Colors.red),
                                                            action: SnackBarAction(
                                                              label: 'dismiss',
                                                              textColor: Colors.white,
                                                              onPressed: () {},
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        });
                                                      } else if (_tempNotANummber == "Total Fee cannot be empty") {
                                                        isValid = false;
                                                        print("error13");
                                                        setState(() {
                                                          final snackBar = SnackBar(
                                                            content: Text('Total Fee for Extra Fee ${i + 1} cannot be empty'),
                                                            backgroundColor: (Colors.red),
                                                            action: SnackBarAction(
                                                              label: 'dismiss',
                                                              textColor: Colors.white,
                                                              onPressed: () {},
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                        });
                                                      }
                                                    }
                                                  }

                                                  for (int j = 2; j < listOfExtraFees[i].length; j++) {
                                                    if (listOfExtraFees[i][j][0] == "^" || listOfExtraFees[i][j][0] == "") {
                                                      isValid = false;
                                                      print("error14");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text('Sub Fee Title ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    } else if (listOfExtraFees[i][j][1] == "^" || listOfExtraFees[i][j][1] == "") {
                                                      isValid = false;
                                                      print("error15");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text('Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][1]) == true) {
                                                      isValid = false;
                                                      print("error15");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text(
                                                              'Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    } else if (listOfExtraFees[i][j][2] == "^" || listOfExtraFees[i][j][2] == "") {
                                                      isValid = false;
                                                      print("error16");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text('Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][2]) == true) {
                                                      isValid = false;
                                                      print("error16");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text(
                                                              'Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    }
                                                  }

                                                  double _balFee = functoChkBalFee(listOfExtraFees[i][1], listOfExtraFees, i);
                                                  if (_balFee != 0) {
                                                    isValid = false;
                                                    print("error17");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content: Text('The Balance Fee for Extra Fee ${i + 1} has to be 0'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  }
                                                }
                                              }
                                              //---------------- VALIDATION Closed --------------------

                                              //_______________________________ FEE to Proper Map for Server ________________________
                                              Map<String, dynamic> tempFeesCompiled = {};
                                              print("%%%%%%%^^^^^^^^^&&&&&&$listOfMainFees%%%%%%%%%%##########@@@@@@@@@@@@");
                                              List<Map<String, dynamic>> _tempMainFeesSubList = [];
                                              if (listOfMainFees[0].length > 3) {
                                                for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                  // MainFeesSub _tempMainFeesSub =
                                                  //     MainFeesSub(sub_fees_title: listOfMainFees[0][i][0],sub_amount:listOfMainFees[0][i][1] ,fee_priority:listOfMainFees[0][i][2] );
                                                  // _tempMainFeesSubList.add(_tempMainFeesSub);

                                                  Map<String, dynamic> _tempMainFeesSub = {
                                                    "sub_fees_title": listOfMainFees[0][i][0],
                                                    "sub_amount": listOfMainFees[0][i][1],
                                                    "fee_priority": listOfMainFees[0][i][2]
                                                  };
                                                  _tempMainFeesSubList.add(_tempMainFeesSub);
                                                }
                                              } else {
                                                Map<String, dynamic> _tempMainFeesSub = {
                                                  "sub_fees_title": listOfMainFees[0][2][0],
                                                  "sub_amount": listOfMainFees[0][2][1],
                                                  "fee_priority": listOfMainFees[0][2][2]
                                                };
                                                _tempMainFeesSubList.add(_tempMainFeesSub);
                                              }

                                              Map<String, dynamic> _tempMainFees = {
                                                "fee_title": listOfMainFees[0][0],
                                                "total_fees": listOfMainFees[0][1],
                                                "sub_of_fees": _tempMainFeesSubList
                                              };
                                              tempFeesCompiled["main_fees"] = [_tempMainFees];

                                              List<Map<String, dynamic>> _tempExtraFeesList = [];

                                              if (listOfExtraFees.isNotEmpty) {
                                                for (List<dynamic> i in listOfExtraFees) {
                                                  List<Map<String, dynamic>> _tempExtraFeesSubList = [];
                                                  if (i.length > 3) {
                                                    for (int j = 2; j < i.length; j++) {
                                                      Map<String, dynamic> _tempExtraFeesSub = {
                                                        "extra_sub_fees_title": i[j][0],
                                                        "extra_sub_amount": i[j][1],
                                                        "extra_fee_priority": i[j][2]
                                                      };
                                                      _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                    }
                                                  } else {
                                                    Map<String, dynamic> _tempExtraFeesSub = {
                                                      "extra_sub_fees_title": i[2][0],
                                                      "extra_sub_amount": i[2][1],
                                                      "extra_fee_priority": i[2][2]
                                                    };
                                                    _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                  }
                                                  Map<String, dynamic> _tempExtraFees = {
                                                    "extra_fee_title": i[0],
                                                    "extra_total_fee": i[1],
                                                    "extra_sub_of_fees": _tempExtraFeesSubList
                                                  };
                                                  _tempExtraFeesList.add(_tempExtraFees);
                                                }
                                              }

                                              tempFeesCompiled["extra_fee"] = _tempExtraFeesList;
                                              tempFeesCompiled["admission_fees"] = _chosenValueAdmissionFees;

                                              print("**************************************************************************");
                                              print("isValid == $isValid");
                                              print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                              print("**************************************************************************");

                                              if (isValid == true) {
                                                print("isValid == true");
                                                createDivision_responseBody = await httpPost(
                                                  msgToSend: {
                                                    "division_name": divisionName,
                                                    "academic_year": _chosenValueAcadYr!,
                                                    "std": _chosenValueClass!,
                                                    "subjects": _chosenValueSubjects!,
                                                    "updatedBy": userName,
                                                    "fees": tempFeesCompiled,
                                                  },
                                                  destinationPort: 8080,
                                                  destinationPost: "/addDivision",
                                                  destinationUrl: mainDomain,
                                                );
                                                print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                                setState(() {
                                                  addDivision = false;
                                                });
                                                if (editDivision_responseBody == "Saved") {
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: const Text("Division has been successfully created"),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    addDivision = false;
                                                    Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                  });
                                                } else if (editDivision_responseBody == "Division Alread Exists") {
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: const Text("Division Alread Exists"),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    addDivision = false;
                                                    Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                  });
                                                } else {
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: const Text('Sorry encountered a server error'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                }
                                              } else {
                                                print("isValid == false;");
                                              }
                                            },
                                            child: const SizedBox(width: 200, height: 50, child: Center(child: Text("Create Division")))),
                                      ), //Create Div Button
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    ), //ADD DIVISION MAIN BODY
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

//_______________________________________ EDIT __________________________________________________________

class DevisionCreateViewEDIT extends StatefulWidget {
  double screenW;

  DevisionCreateViewEDIT({required this.screenW});

  @override
  _DevisionCreateViewEDITState createState() => _DevisionCreateViewEDITState();
}

class _DevisionCreateViewEDITState extends State<DevisionCreateViewEDIT> {
  final ScrollController _controllerOne = ScrollController();
  late TextEditingController _controllerDivisionName;
  late TextEditingController _controllerAdmissionFees;

  funcAddExtraWigs() {
    ExtraFeesNumber = editListofExtraFeesToEdit.isNotEmpty ? editListofExtraFeesToEdit.length : 0;
    if (ExtraFeesNumber > 0) {
      for (int i = 0; i < listOfExtraFees.length; i++) {
        ExtraFeesWig.add(FeesAddInDivisionExtraFeesEDIT(
          extrafeeNumber: i,
        ));
      }
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    funcAddExtraWigs();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      funcGetDropDownInfo();
      _chosenValueAcadYr = editDivAcadYrToEdit;
      divisionName = editDivNameToEdit;
      _chosenValueClass = editDivClassToEdit;
      _chosenValueSubjects = editDivSubjectsToEdit;
      _chosenValueAdmissionFees = editAdmissionFeesToEdit;
    });
    _chosenValueAdmissionFees = editAdmissionFeesToEdit;
    _controllerDivisionName = TextEditingController(text: editDivNameToEdit);
    _controllerAdmissionFees = TextEditingController(text: editAdmissionFeesToEdit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
    _controllerDivisionName.dispose();
    _controllerAdmissionFees.dispose();
  }

  @override
  funcGetDropDownInfo() async {
    final progress = ProgressHUD.of(context);
    progress?.show();
    showAcadYr_responseBodyJSON = await httpPost(
      msgToSend: {"msg": "viewAcadYrinDB"},
      destinationPort: 8080,
      destinationPost: "/addAcademicYear/viewAcadYrinDB",
      destinationUrl: mainDomain,
    );
    showClass_responseBodyJSON = await httpPost(
      msgToSend: {"msg": "viewClassesinDB"},
      destinationPort: 8080,
      destinationPost: "/addClass/viewClassesinDB",
      destinationUrl: mainDomain,
    );
    showSubject_responseBodyJSON = await httpPost(
      msgToSend: {"msg": "viewSubjectinDB"},
      destinationPort: 8080,
      destinationPost: "/addsubject/viewSubjectinDB",
      destinationUrl: mainDomain,
    );

    showAcadYr_responseBody = json.decode(showAcadYr_responseBodyJSON!);
    showClass_responseBody = json.decode(showClass_responseBodyJSON!);
    showSubject_responseBody = json.decode(showSubject_responseBodyJSON!);
    listOfAcadYr.clear();
    for (var i in showAcadYr_responseBody) {
      listOfAcadYr.add(i["year"]);
    }
    listOfClass.clear();
    for (var i in showClass_responseBody) {
      listOfClass.add(i["standard_name"]);
    }
    listOfSubjects.clear();
    for (var i in showSubject_responseBody) {
      listOfSubjects.add(i["subject_name"]);
    }
    progress?.dismiss();
  }

  Widget build(BuildContext context) {
    return GlassContainer(
      width: (widget.screenW) - 2,
      child: Center(
        child: SizedBox(
          width: 700,
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        //TOP BAR
                        height: 30,
                        width: widget.screenW > 700 ? 700 : widget.screenW,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: widget.screenW > 700 ? 660 : widget.screenW - 40,
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "Edit Division",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  listOfMainFees = [
                                    [
                                      "^",
                                      "^",
                                      ["^", "^", "^"]
                                    ]
                                  ];
                                  setState(() {
                                    showEditDivision = false;
                                    Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                  });
                                },
                                splashColor: Colors.white,
                                // autofocus: true,
                                child: Ink(
                                    height: 30,
                                    width: 30,
                                    child: const Center(
                                        child: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    )
                                        // const Text("X",
                                        //   style: TextStyle(fontWeight: FontWeight.bold ,
                                        //       color: Colors.white),),
                                        // )
                                        )),
                              ),
                            )
                          ],
                        ),
                        color: Colors.blue), //TOP BAR
                    Scrollbar(
                      controller: _controllerOne,
                      child: SingleChildScrollView(
                        controller: _controllerOne,
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            widget.screenW > mobileBrkPoint
                                ? Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(width: 20),
                                      SizedBox(
                                        //Acad Yr, Class, Subject
                                        width: 200,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Column(
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 20),
                                              TextField(
                                                controller: _controllerDivisionName,
                                                onChanged: (val) {
                                                  setState(() {
                                                    divisionName = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Division Name')),
                                              ),
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                selectedItem: editDivAcadYrToEdit,
                                                mode: Mode.MENU,
                                                items: listOfAcadYr,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select an Acad Yr",
                                                  labelText: "Academic Year *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueAcadYr = v;
                                                },
                                                // selectedItem: "2021-2022",
                                              ), //AACADEMIC YEAR
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>(
                                                selectedItem: editDivClassToEdit,
                                                mode: Mode.MENU,
                                                items: listOfClass,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select a Class",
                                                  labelText: "Class *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                                  border: OutlineInputBorder(),
                                                ),
                                                isFilteredOnline: true,
                                                showSearchBox: true,
                                                onChanged: (v) {
                                                  _chosenValueClass = v;
                                                },
                                              ), //CLASS
                                              const SizedBox(height: 20),
                                              DropdownSearch<String>.multiSelection(
                                                selectedItems: editDivSubjectsToEdit!,
                                                dialogMaxWidth: 100,
                                                maxHeight: 500,
                                                mode: Mode.DIALOG,
                                                items: listOfSubjects,
                                                dropdownSearchDecoration: const InputDecoration(
                                                  hintText: "Select Subjects",
                                                  labelText: "Subjects *",
                                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                                  // border: OutlineInputBorder(),
                                                ),
                                                // isFilteredOnline:true,
                                                showSearchBox: true,
                                                // popupItemDisabled: (String s) => s.startsWith('I'),
                                                onChanged: (v) {
                                                  _chosenValueSubjects = v;
                                                },
                                              ), //SUBJECTS
                                              const SizedBox(height: 20),
                                              TextField(
                                                controller: _controllerAdmissionFees,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _chosenValueAdmissionFees = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: funcValEmptyOrNumber(_chosenValueAdmissionFees, "Admission Fees"),
                                                    // divisionName == "" ? "Division name cannot be empty" : null,
                                                    label: const Text('Admission Fee')),
                                              ),
                                              const SizedBox(height: 20),
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: ElevatedButton(
                                                        //UPDATE DIVISION
                                                        onPressed: () async {
                                                          bool isValid = true;
                                                          //---------------- VALIDATION --------------------
                                                          if (divisionName == null) {
                                                            isValid = false;
                                                            print("error1");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Division name cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueAcadYr == null) {
                                                            isValid = false;
                                                            print("error2");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Academic Year cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueClass == null) {
                                                            isValid = false;
                                                            print("error3");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Class cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (funcValEmptyOrNumberBool(_chosenValueAdmissionFees) == true) {
                                                            isValid = false;
                                                            print("error3");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Admission Fee cannot be empty or an invalid number'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (_chosenValueSubjects == null) {
                                                            isValid = false;
                                                            print("error4");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Subjects cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          //--------------------------- MAIN FEE VALIDATION --------------------------------------------------
                                                          else if (listOfMainFees[0][0] == "^" || listOfMainFees[0][0] == null) {
                                                            isValid = false;
                                                            print("error5");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Fee Title cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (listOfMainFees[0][1] == "^" || listOfMainFees[0][1] == null) {
                                                            isValid = false;
                                                            print("error6");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Total Fees cannot be empty'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          } else if (funcValEmptyOrNumberBool(listOfMainFees[0][1]) == true) {
                                                            isValid = false;
                                                            print("error6.1");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('Total Fees cannot be empty or have invalid number'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                            if (listOfMainFees[0][i][0] == "^" || listOfMainFees[0][i][0] == "") {
                                                              isValid = false;
                                                              print("error7");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Title ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (listOfMainFees[0][i][1] == "^" || listOfMainFees[0][i][1] == "") {
                                                              isValid = false;
                                                              print("error8");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Amount ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][1]) == true) {
                                                              isValid = false;
                                                              print("error8");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text(
                                                                      'Sub Fee Amount ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (listOfMainFees[0][i][2] == "^" || listOfMainFees[0][i][2] == "") {
                                                              isValid = false;
                                                              print("error9");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text('Sub Fee Priority ${i - 1} of Main Fee cannot be empty'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][2]) == true) {
                                                              isValid = false;
                                                              print("error9");
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: Text(
                                                                      'Sub Fee Priority ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            }
                                                          }

                                                          double _balFee = functoChkBalFee(listOfMainFees[0][1], listOfMainFees, 0);
                                                          if (_balFee != 0) {
                                                            isValid = false;
                                                            print("error10");
                                                            setState(() {
                                                              final snackBar = SnackBar(
                                                                content: const Text('The Balance Fee for Main Fee has to be 0'),
                                                                backgroundColor: (Colors.red),
                                                                action: SnackBarAction(
                                                                  label: 'dismiss',
                                                                  textColor: Colors.white,
                                                                  onPressed: () {},
                                                                ),
                                                              );
                                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                            });
                                                          }

                                                          //_______________________________ EXTRA FEE VALIDATION ________________________
                                                          if (listOfExtraFees.isNotEmpty) {
                                                            for (int i = 0; i < listOfExtraFees.length; i++) {
                                                              if (listOfExtraFees[i][0] == "^" || listOfExtraFees[i][0] == "") {
                                                                isValid = false;
                                                                print("error11");

                                                                setState(() {
                                                                  final snackBar = SnackBar(
                                                                    content: Text('Fee Title for Extra Fee ${i + 1} cannot be empty'),
                                                                    backgroundColor: (Colors.red),
                                                                    action: SnackBarAction(
                                                                      label: 'dismiss',
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                              } else if (listOfExtraFees[i][1] != "^" || listOfExtraFees[i][1] != "") {
                                                                String? _tempNotANummber = funcValEmptyOrNumber(listOfExtraFees[i][1], "Total Fee");
                                                                if (_tempNotANummber != null) {
                                                                  if (_tempNotANummber == "Total Fee has to be a number" ||
                                                                      _tempNotANummber == "Total Fee is an invalid number") {
                                                                    isValid = false;
                                                                    print("error12");
                                                                    setState(() {
                                                                      final snackBar = SnackBar(
                                                                        content: Text('Total Fee for Extra Fee ${i + 1} has to be a Valid Number'),
                                                                        backgroundColor: (Colors.red),
                                                                        action: SnackBarAction(
                                                                          label: 'dismiss',
                                                                          textColor: Colors.white,
                                                                          onPressed: () {},
                                                                        ),
                                                                      );
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    });
                                                                  } else if (_tempNotANummber == "Total Fee cannot be empty") {
                                                                    isValid = false;
                                                                    print("error13");
                                                                    setState(() {
                                                                      final snackBar = SnackBar(
                                                                        content: Text('Total Fee for Extra Fee ${i + 1} cannot be empty'),
                                                                        backgroundColor: (Colors.red),
                                                                        action: SnackBarAction(
                                                                          label: 'dismiss',
                                                                          textColor: Colors.white,
                                                                          onPressed: () {},
                                                                        ),
                                                                      );
                                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                    });
                                                                  }
                                                                }
                                                              }

                                                              for (int j = 2; j < listOfExtraFees[i].length; j++) {
                                                                if (listOfExtraFees[i][j][0] == "^" || listOfExtraFees[i][j][0] == "") {
                                                                  isValid = false;
                                                                  print("error14");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text('Sub Fee Title ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (listOfExtraFees[i][j][1] == "^" || listOfExtraFees[i][j][1] == "") {
                                                                  isValid = false;
                                                                  print("error15");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content:
                                                                          Text('Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][1]) == true) {
                                                                  isValid = false;
                                                                  print("error15");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text(
                                                                          'Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (listOfExtraFees[i][j][2] == "^" || listOfExtraFees[i][j][2] == "") {
                                                                  isValid = false;
                                                                  print("error16");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content:
                                                                          Text('Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][2]) == true) {
                                                                  isValid = false;
                                                                  print("error16");
                                                                  setState(() {
                                                                    final snackBar = SnackBar(
                                                                      content: Text(
                                                                          'Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                                      backgroundColor: (Colors.red),
                                                                      action: SnackBarAction(
                                                                        label: 'dismiss',
                                                                        textColor: Colors.white,
                                                                        onPressed: () {},
                                                                      ),
                                                                    );
                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                  });
                                                                }
                                                              }

                                                              double _balFee = functoChkBalFee(listOfExtraFees[i][1], listOfExtraFees, i);
                                                              if (_balFee != 0) {
                                                                isValid = false;
                                                                print("error17");
                                                                setState(() {
                                                                  final snackBar = SnackBar(
                                                                    content: Text('The Balance Fee for Extra Fee ${i + 1} has to be 0'),
                                                                    backgroundColor: (Colors.red),
                                                                    action: SnackBarAction(
                                                                      label: 'dismiss',
                                                                      textColor: Colors.white,
                                                                      onPressed: () {},
                                                                    ),
                                                                  );
                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                });
                                                              }
                                                            }
                                                          }
                                                          //---------------- VALIDATION Closed --------------------

                                                          //_______________________________ FEE to Proper Map for Server ________________________
                                                          Map<String, dynamic> tempFeesCompiled = {};

                                                          List<Map<String, dynamic>> _tempMainFeesSubList = [];
                                                          if (listOfMainFees[0].length > 3) {
                                                            for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                              // MainFeesSub _tempMainFeesSub =
                                                              //     MainFeesSub(sub_fees_title: listOfMainFees[0][i][0],sub_amount:listOfMainFees[0][i][1] ,fee_priority:listOfMainFees[0][i][2] );
                                                              // _tempMainFeesSubList.add(_tempMainFeesSub);

                                                              Map<String, dynamic> _tempMainFeesSub = {
                                                                "sub_fees_title": listOfMainFees[0][i][0],
                                                                "sub_amount": listOfMainFees[0][i][1],
                                                                "fee_priority": listOfMainFees[0][i][2]
                                                              };
                                                              _tempMainFeesSubList.add(_tempMainFeesSub);
                                                            }
                                                          } else {
                                                            Map<String, dynamic> _tempMainFeesSub = {
                                                              "sub_fees_title": listOfMainFees[0][2][0],
                                                              "sub_amount": listOfMainFees[0][2][1],
                                                              "fee_priority": listOfMainFees[0][2][2]
                                                            };
                                                            _tempMainFeesSubList.add(_tempMainFeesSub);
                                                          }

                                                          Map<String, dynamic> _tempMainFees = {
                                                            "fee_title": listOfMainFees[0][0],
                                                            "total_fees": listOfMainFees[0][1],
                                                            "sub_of_fees": _tempMainFeesSubList
                                                          };
                                                          tempFeesCompiled["main_fees"] = [_tempMainFees];

                                                          List<Map<String, dynamic>> _tempExtraFeesList = [];

                                                          if (listOfExtraFees.isNotEmpty) {
                                                            for (List<dynamic> i in listOfExtraFees) {
                                                              List<Map<String, dynamic>> _tempExtraFeesSubList = [];
                                                              if (i.length > 3) {
                                                                for (int j = 2; j < i.length; j++) {
                                                                  Map<String, dynamic> _tempExtraFeesSub = {
                                                                    "extra_sub_fees_title": i[j][0],
                                                                    "extra_sub_amount": i[j][1],
                                                                    "extra_fee_priority": i[j][2]
                                                                  };
                                                                  _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                                }
                                                              } else {
                                                                Map<String, dynamic> _tempExtraFeesSub = {
                                                                  "extra_sub_fees_title": i[2][0],
                                                                  "extra_sub_amount": i[2][1],
                                                                  "extra_fee_priority": i[2][2]
                                                                };
                                                                _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                              }
                                                              Map<String, dynamic> _tempExtraFees = {
                                                                "extra_fee_title": i[0],
                                                                "extra_total_fee": i[1],
                                                                "extra_sub_of_fees": _tempExtraFeesSubList
                                                              };
                                                              _tempExtraFeesList.add(_tempExtraFees);
                                                            }
                                                          }

                                                          tempFeesCompiled["extra_fee"] = _tempExtraFeesList;
                                                          tempFeesCompiled["admission_fees"] = _chosenValueAdmissionFees;
                                                          print("**************************************************************************");
                                                          print("isValid == $isValid");
                                                          print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                                          print("**************************************************************************");

                                                          if (isValid == true) {
                                                            print("isValid == true");
                                                            editDivision_responseBody = await httpPost(
                                                              msgToSend: {
                                                                "msg": "editDivisionInDB",
                                                                "idToEdit": editIdToEdit,
                                                                "division_name": divisionName,
                                                                "academic_year": _chosenValueAcadYr!,
                                                                "std": _chosenValueClass!,
                                                                "subjects": _chosenValueSubjects!,
                                                                "updatedBy": userName,
                                                                "fees": tempFeesCompiled,
                                                              },
                                                              destinationPort: 8080,
                                                              destinationPost: "/addDivision/editDivisionInDB",
                                                              destinationUrl: mainDomain,
                                                            );
                                                            print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                                            print("editDivision_responseBody = $editDivision_responseBody");
                                                            if (editDivision_responseBody == "Successfully Updated") {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text("Division has been successfully updated"),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                showEditDivision = false;
                                                                Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                              });
                                                            } else if (editDivision_responseBody == "Division Alread Exists") {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text("Division already exists with same Name, Acad Yr and Class"),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            } else {
                                                              setState(() {
                                                                final snackBar = SnackBar(
                                                                  content: const Text('Sorry encountered a server error'),
                                                                  backgroundColor: (Colors.red),
                                                                  action: SnackBarAction(
                                                                    label: 'dismiss',
                                                                    textColor: Colors.white,
                                                                    onPressed: () {},
                                                                  ),
                                                                );
                                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                              });
                                                            }
                                                          } else {
                                                            print("isValid == false;");
                                                          }
                                                        },
                                                        child: const SizedBox(width: 200, height: 50, child: Center(child: Text("Update Division")))),
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ), //Acad Yr, Class, Subject
                                      SizedBox(
                                        width: 300,
                                        child: SizedBox(
                                          width: 300,
                                          // height:750,
                                          child: FeesAddInDivisionMainFeesEDIT(mainfeeNumber: 0),
                                        ),
                                      ), //Main Fees
                                      SizedBox(
                                          // height:750,
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ExtraFeesNumber = ExtraFeesNumber + 1;
                                                      setState(() {
                                                        listOfExtraFees.add([
                                                          "^",
                                                          "^",
                                                          ["^", "^", "^"]
                                                        ]);
                                                        ExtraFeesWig.add(FeesAddInDivisionExtraFees(
                                                          extrafeeNumber: ExtraFeesNumber - 1,
                                                        ));
                                                      });
                                                    },
                                                    child: const Text("Add Extra Fees")),
                                                const SizedBox(width: 10),
                                                ExtraFeesNumber > 0
                                                    ? ElevatedButton(
                                                        onPressed: () {
                                                          ExtraFeesNumber = ExtraFeesNumber - 1;
                                                          setState(() {
                                                            listOfExtraFees.remove(listOfExtraFees.last);
                                                            ExtraFeesWig.remove(ExtraFeesWig.last);
                                                          });
                                                        },
                                                        child: const Text("Remove Extra Fees"))
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: ExtraFeesWig,
                                          )
                                          // Column(children:)
                                        ],
                                      )) //Extra Fees
                                    ],
                                  )
                                : Column(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 20),
                                SizedBox(
                                  //Acad Yr, Class, Subject
                                  width: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: _controllerDivisionName,
                                          onChanged: (val) {
                                            setState(() {
                                              divisionName = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: divisionName == "" ? "Division name cannot be empty" : null,
                                              label: const Text('Division Name')),
                                        ),
                                        const SizedBox(height: 20),
                                        DropdownSearch<String>(
                                          selectedItem: editDivAcadYrToEdit,
                                          mode: Mode.MENU,
                                          items: listOfAcadYr,
                                          dropdownSearchDecoration: const InputDecoration(
                                            hintText: "Select an Acad Yr",
                                            labelText: "Academic Year *",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          isFilteredOnline: true,
                                          showSearchBox: true,
                                          // popupItemDisabled: (String s) => s.startsWith('I'),
                                          onChanged: (v) {
                                            _chosenValueAcadYr = v;
                                          },
                                          // selectedItem: "2021-2022",
                                        ), //AACADEMIC YEAR
                                        const SizedBox(height: 20),
                                        DropdownSearch<String>(
                                          selectedItem: editDivClassToEdit,
                                          mode: Mode.MENU,
                                          items: listOfClass,
                                          dropdownSearchDecoration: const InputDecoration(
                                            hintText: "Select a Class",
                                            labelText: "Class *",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                            border: OutlineInputBorder(),
                                          ),
                                          isFilteredOnline: true,
                                          showSearchBox: true,
                                          onChanged: (v) {
                                            _chosenValueClass = v;
                                          },
                                        ), //CLASS
                                        const SizedBox(height: 20),
                                        DropdownSearch<String>.multiSelection(
                                          selectedItems: editDivSubjectsToEdit!,
                                          dialogMaxWidth: 100,
                                          maxHeight: 500,
                                          mode: Mode.DIALOG,
                                          items: listOfSubjects,
                                          dropdownSearchDecoration: const InputDecoration(
                                            hintText: "Select Subjects",
                                            labelText: "Subjects *",
                                            contentPadding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                                            // border: OutlineInputBorder(),
                                          ),
                                          // isFilteredOnline:true,
                                          showSearchBox: true,
                                          // popupItemDisabled: (String s) => s.startsWith('I'),
                                          onChanged: (v) {
                                            _chosenValueSubjects = v;
                                          },
                                        ), //SUBJECTS
                                        const SizedBox(height: 20),
                                        TextField(
                                          controller: _controllerAdmissionFees,
                                          onChanged: (val) {
                                            setState(() {
                                              _chosenValueAdmissionFees = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: funcValEmptyOrNumber(_chosenValueAdmissionFees, "Admission Fees"),
                                              // divisionName == "" ? "Division name cannot be empty" : null,
                                              label: const Text('Admission Fee')),
                                        ),
                                        const SizedBox(height: 20),

                                      ],
                                    ),
                                  ),
                                ), //Acad Yr, Class, Subject
                                SizedBox(
                                  width: 300,
                                  child: SizedBox(
                                    width: 300,
                                    // height:750,
                                    child: FeesAddInDivisionMainFeesEDIT(mainfeeNumber: 0),
                                  ),
                                ), //Main Fees
                                SizedBox(
                                  // height:750,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    ExtraFeesNumber = ExtraFeesNumber + 1;
                                                    setState(() {
                                                      listOfExtraFees.add([
                                                        "^",
                                                        "^",
                                                        ["^", "^", "^"]
                                                      ]);
                                                      ExtraFeesWig.add(FeesAddInDivisionExtraFees(
                                                        extrafeeNumber: ExtraFeesNumber - 1,
                                                      ));
                                                    });
                                                  },
                                                  child: const Text("Add Extra Fees")),
                                              const SizedBox(width: 10),
                                              ExtraFeesNumber > 0
                                                  ? ElevatedButton(
                                                  onPressed: () {
                                                    ExtraFeesNumber = ExtraFeesNumber - 1;
                                                    setState(() {
                                                      listOfExtraFees.remove(listOfExtraFees.last);
                                                      ExtraFeesWig.remove(ExtraFeesWig.last);
                                                    });
                                                  },
                                                  child: const Text("Remove Extra Fees"))
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: ExtraFeesWig,
                                        )
                                        // Column(children:)
                                      ],
                                    )),//Extra Fees
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        //UPDATE DIVISION
                                          onPressed: () async {
                                            bool isValid = true;
                                            //---------------- VALIDATION --------------------
                                            if (divisionName == null) {
                                              isValid = false;
                                              print("error1");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Division name cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (_chosenValueAcadYr == null) {
                                              isValid = false;
                                              print("error2");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Academic Year cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (_chosenValueClass == null) {
                                              isValid = false;
                                              print("error3");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Class cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (funcValEmptyOrNumberBool(_chosenValueAdmissionFees) == true) {
                                              isValid = false;
                                              print("error3");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Admission Fee cannot be empty or an invalid number'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (_chosenValueSubjects == null) {
                                              isValid = false;
                                              print("error4");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Subjects cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            }

                                            //--------------------------- MAIN FEE VALIDATION --------------------------------------------------
                                            else if (listOfMainFees[0][0] == "^" || listOfMainFees[0][0] == null) {
                                              isValid = false;
                                              print("error5");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Fee Title cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (listOfMainFees[0][1] == "^" || listOfMainFees[0][1] == null) {
                                              isValid = false;
                                              print("error6");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Total Fees cannot be empty'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (funcValEmptyOrNumberBool(listOfMainFees[0][1]) == true) {
                                              isValid = false;
                                              print("error6.1");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('Total Fees cannot be empty or have invalid number'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            }

                                            for (int i = 2; i < listOfMainFees[0].length; i++) {
                                              if (listOfMainFees[0][i][0] == "^" || listOfMainFees[0][i][0] == "") {
                                                isValid = false;
                                                print("error7");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: Text('Sub Fee Title ${i - 1} of Main Fee cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (listOfMainFees[0][i][1] == "^" || listOfMainFees[0][i][1] == "") {
                                                isValid = false;
                                                print("error8");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: Text('Sub Fee Amount ${i - 1} of Main Fee cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][1]) == true) {
                                                isValid = false;
                                                print("error8");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                        'Sub Fee Amount ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (listOfMainFees[0][i][2] == "^" || listOfMainFees[0][i][2] == "") {
                                                isValid = false;
                                                print("error9");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: Text('Sub Fee Priority ${i - 1} of Main Fee cannot be empty'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else if (funcValEmptyOrNumberBool(listOfMainFees[0][i][2]) == true) {
                                                isValid = false;
                                                print("error9");
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                        'Sub Fee Priority ${i - 1} of Main Fee cannot be empty or an invalid number'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              }
                                            }

                                            double _balFee = functoChkBalFee(listOfMainFees[0][1], listOfMainFees, 0);
                                            if (_balFee != 0) {
                                              isValid = false;
                                              print("error10");
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text('The Balance Fee for Main Fee has to be 0'),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            }

                                            //_______________________________ EXTRA FEE VALIDATION ________________________
                                            if (listOfExtraFees.isNotEmpty) {
                                              for (int i = 0; i < listOfExtraFees.length; i++) {
                                                if (listOfExtraFees[i][0] == "^" || listOfExtraFees[i][0] == "") {
                                                  isValid = false;
                                                  print("error11");

                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('Fee Title for Extra Fee ${i + 1} cannot be empty'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                } else if (listOfExtraFees[i][1] != "^" || listOfExtraFees[i][1] != "") {
                                                  String? _tempNotANummber = funcValEmptyOrNumber(listOfExtraFees[i][1], "Total Fee");
                                                  if (_tempNotANummber != null) {
                                                    if (_tempNotANummber == "Total Fee has to be a number" ||
                                                        _tempNotANummber == "Total Fee is an invalid number") {
                                                      isValid = false;
                                                      print("error12");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text('Total Fee for Extra Fee ${i + 1} has to be a Valid Number'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    } else if (_tempNotANummber == "Total Fee cannot be empty") {
                                                      isValid = false;
                                                      print("error13");
                                                      setState(() {
                                                        final snackBar = SnackBar(
                                                          content: Text('Total Fee for Extra Fee ${i + 1} cannot be empty'),
                                                          backgroundColor: (Colors.red),
                                                          action: SnackBarAction(
                                                            label: 'dismiss',
                                                            textColor: Colors.white,
                                                            onPressed: () {},
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                      });
                                                    }
                                                  }
                                                }

                                                for (int j = 2; j < listOfExtraFees[i].length; j++) {
                                                  if (listOfExtraFees[i][j][0] == "^" || listOfExtraFees[i][j][0] == "") {
                                                    isValid = false;
                                                    print("error14");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content: Text('Sub Fee Title ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  } else if (listOfExtraFees[i][j][1] == "^" || listOfExtraFees[i][j][1] == "") {
                                                    isValid = false;
                                                    print("error15");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content:
                                                        Text('Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][1]) == true) {
                                                    isValid = false;
                                                    print("error15");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            'Sub Fee Amount ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  } else if (listOfExtraFees[i][j][2] == "^" || listOfExtraFees[i][j][2] == "") {
                                                    isValid = false;
                                                    print("error16");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content:
                                                        Text('Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  } else if (funcValEmptyOrNumberBool(listOfExtraFees[i][j][2]) == true) {
                                                    isValid = false;
                                                    print("error16");
                                                    setState(() {
                                                      final snackBar = SnackBar(
                                                        content: Text(
                                                            'Sub Fee Priority ${j - 1} for Extra Fees ${i + 1} cannot be empty or an invalid number'),
                                                        backgroundColor: (Colors.red),
                                                        action: SnackBarAction(
                                                          label: 'dismiss',
                                                          textColor: Colors.white,
                                                          onPressed: () {},
                                                        ),
                                                      );
                                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    });
                                                  }
                                                }

                                                double _balFee = functoChkBalFee(listOfExtraFees[i][1], listOfExtraFees, i);
                                                if (_balFee != 0) {
                                                  isValid = false;
                                                  print("error17");
                                                  setState(() {
                                                    final snackBar = SnackBar(
                                                      content: Text('The Balance Fee for Extra Fee ${i + 1} has to be 0'),
                                                      backgroundColor: (Colors.red),
                                                      action: SnackBarAction(
                                                        label: 'dismiss',
                                                        textColor: Colors.white,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  });
                                                }
                                              }
                                            }
                                            //---------------- VALIDATION Closed --------------------

                                            //_______________________________ FEE to Proper Map for Server ________________________
                                            Map<String, dynamic> tempFeesCompiled = {};

                                            List<Map<String, dynamic>> _tempMainFeesSubList = [];
                                            if (listOfMainFees[0].length > 3) {
                                              for (int i = 2; i < listOfMainFees[0].length; i++) {
                                                // MainFeesSub _tempMainFeesSub =
                                                //     MainFeesSub(sub_fees_title: listOfMainFees[0][i][0],sub_amount:listOfMainFees[0][i][1] ,fee_priority:listOfMainFees[0][i][2] );
                                                // _tempMainFeesSubList.add(_tempMainFeesSub);

                                                Map<String, dynamic> _tempMainFeesSub = {
                                                  "sub_fees_title": listOfMainFees[0][i][0],
                                                  "sub_amount": listOfMainFees[0][i][1],
                                                  "fee_priority": listOfMainFees[0][i][2]
                                                };
                                                _tempMainFeesSubList.add(_tempMainFeesSub);
                                              }
                                            } else {
                                              Map<String, dynamic> _tempMainFeesSub = {
                                                "sub_fees_title": listOfMainFees[0][2][0],
                                                "sub_amount": listOfMainFees[0][2][1],
                                                "fee_priority": listOfMainFees[0][2][2]
                                              };
                                              _tempMainFeesSubList.add(_tempMainFeesSub);
                                            }

                                            Map<String, dynamic> _tempMainFees = {
                                              "fee_title": listOfMainFees[0][0],
                                              "total_fees": listOfMainFees[0][1],
                                              "sub_of_fees": _tempMainFeesSubList
                                            };
                                            tempFeesCompiled["main_fees"] = [_tempMainFees];

                                            List<Map<String, dynamic>> _tempExtraFeesList = [];

                                            if (listOfExtraFees.isNotEmpty) {
                                              for (List<dynamic> i in listOfExtraFees) {
                                                List<Map<String, dynamic>> _tempExtraFeesSubList = [];
                                                if (i.length > 3) {
                                                  for (int j = 2; j < i.length; j++) {
                                                    Map<String, dynamic> _tempExtraFeesSub = {
                                                      "extra_sub_fees_title": i[j][0],
                                                      "extra_sub_amount": i[j][1],
                                                      "extra_fee_priority": i[j][2]
                                                    };
                                                    _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                  }
                                                } else {
                                                  Map<String, dynamic> _tempExtraFeesSub = {
                                                    "extra_sub_fees_title": i[2][0],
                                                    "extra_sub_amount": i[2][1],
                                                    "extra_fee_priority": i[2][2]
                                                  };
                                                  _tempExtraFeesSubList.add(_tempExtraFeesSub);
                                                }
                                                Map<String, dynamic> _tempExtraFees = {
                                                  "extra_fee_title": i[0],
                                                  "extra_total_fee": i[1],
                                                  "extra_sub_of_fees": _tempExtraFeesSubList
                                                };
                                                _tempExtraFeesList.add(_tempExtraFees);
                                              }
                                            }

                                            tempFeesCompiled["extra_fee"] = _tempExtraFeesList;
                                            tempFeesCompiled["admission_fees"] = _chosenValueAdmissionFees;
                                            print("**************************************************************************");
                                            print("isValid == $isValid");
                                            print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                            print("**************************************************************************");

                                            if (isValid == true) {
                                              print("isValid == true");
                                              editDivision_responseBody = await httpPost(
                                                msgToSend: {
                                                  "msg": "editDivisionInDB",
                                                  "idToEdit": editIdToEdit,
                                                  "division_name": divisionName,
                                                  "academic_year": _chosenValueAcadYr!,
                                                  "std": _chosenValueClass!,
                                                  "subjects": _chosenValueSubjects!,
                                                  "updatedBy": userName,
                                                  "fees": tempFeesCompiled,
                                                },
                                                destinationPort: 8080,
                                                destinationPost: "/addDivision/editDivisionInDB",
                                                destinationUrl: mainDomain,
                                              );
                                              print("tempFeesCompiled.toString() = ${tempFeesCompiled.toString()}");
                                              print("editDivision_responseBody = $editDivision_responseBody");
                                              if (editDivision_responseBody == "Successfully Updated") {
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text("Division has been successfully updated"),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                  showEditDivision = false;
                                                  Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                                });
                                              } else if (editDivision_responseBody == "Division Alread Exists") {
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text("Division already exists with same Name, Acad Yr and Class"),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              } else {
                                                setState(() {
                                                  final snackBar = SnackBar(
                                                    content: const Text('Sorry encountered a server error'),
                                                    backgroundColor: (Colors.red),
                                                    action: SnackBarAction(
                                                      label: 'dismiss',
                                                      textColor: Colors.white,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                });
                                              }
                                            } else {
                                              print("isValid == false;");
                                            }
                                          },
                                          child: const SizedBox(width: 200, height: 50, child: Center(child: Text("Update Division")))),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),// UPDATE DIVISION
                              ],
                            ),
                          ],
                        ),
                      ),
                    ), //UPDATE DIVISION MAIN BODY
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

//_______________________________________ Delete __________________________________________________________

class DevisionCreateViewDELETE extends StatefulWidget {
  const DevisionCreateViewDELETE({Key? key}) : super(key: key);

  @override
  State<DevisionCreateViewDELETE> createState() => _DevisionCreateViewDELETEState();
}

class _DevisionCreateViewDELETEState extends State<DevisionCreateViewDELETE> {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        height: 500,
        child: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: Container(
              child: Column(
            children: [
              Container(
                  //TOP BAR
                  height: 30,
                  width: 250,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 220,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Delete Confirmation",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              delDivision = false;
                              Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                            });
                          },
                          splashColor: Colors.white,
                          // autofocus: true,
                          child: Ink(
                            height: 30,
                            width: 30,
                            child: const Center(
                                child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                  color: Colors.red),
              Center(
                child: Card(
                  child: Container(
                    color: Colors.grey.shade100,
                    height: 115,
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 75,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Are you sure you want to Delete $deleteDivisionName Division"),
                          )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  print("in it");
                                  deletDivision_responseBody = await httpPost(
                                    msgToSend: {"msg": "delDivisioninDB", "id": deleteDivision_id!},
                                    destinationPort: 8080,
                                    destinationPost: "/addDivision/deleteDivisioninDB",
                                    destinationUrl: mainDomain,
                                  );
                                  if (deletDivision_responseBody == "deleted successfully") {
                                    print("deletDivision_responseBody.toString() = ${deletDivision_responseBody.toString()}");
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Diision $deleteDivisionName has been deleted"),
                                        backgroundColor: (Colors.red),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  } else {
                                    setState(() {
                                      print("deletDivision_responseBody.toString() = ${deletDivision_responseBody.toString()}");
                                      final snackBar = SnackBar(
                                        content: const Text('Sorry encountered a server error'),
                                        backgroundColor: (Colors.red),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }
                                  setState(() {
                                    delDivision = false;
                                    Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                  });
                                },
                                child: Text("Yes Delete Confirm")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    delDivision = false;
                                    Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                                  });
                                },
                                child: Text("Cancel"))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )),
        ));
  }
}























//------------------------------- Main Fee Wig ----------------------------------------------------
class FeesAddInDivisionMainFees extends StatefulWidget {
  final int mainfeeNumber;

  FeesAddInDivisionMainFees({required this.mainfeeNumber});

  @override
  State<FeesAddInDivisionMainFees> createState() => _FeesAddInDivisionMainFeesState();
}

class _FeesAddInDivisionMainFeesState extends State<FeesAddInDivisionMainFees> {
  int subdivmainFees = 1;
  List<Widget> subdivmainFeesWig = [
    SubDivOfMainFees(
      subdivofMainfeeNumber: 1,
    )
  ];

  @override
  Widget build(BuildContext context) {
    double? totalFees =
        Provider.of<Data>(context, listen: true).refrashPage == true ? double.tryParse(listOfMainFees[0][1]) : double.tryParse(listOfMainFees[0][1]);
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20.0, left: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Main Fees",
                style: TextStyle(fontSize: 15),
              ),
              TextField(
                onChanged: (val) {
                  setState(() {
                    val == null ? val = "" : val;
                    listOfMainFees[0][0] = val;
                  });
                },
                decoration:
                    InputDecoration(errorText: listOfMainFees[0][0] == "" ? "Fee title is cannot be empty" : null, label: const Text('Fee Title*')),
              ),
              TextField(
                onChanged: (val) {
                  setState(() {
                    val == null ? val = "" : val;
                    listOfMainFees[0][1] = val;
                    Provider.of<Data>(context, listen: false).refPage(true);
                  });
                },
                decoration: InputDecoration(
                    errorText: funcValEmptyOrNumber(listOfMainFees[0][1], "Total Fees"),
                    // listOfMainFees[0][1] == "" ? "Fee title is cannot be empty":null ,
                    label: const Text('Total Fees')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      "Division of Fees in $subdivmainFees parts",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Fees: $totalFees",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Balance After Division : ${functoChkBalFee(listOfMainFees[widget.mainfeeNumber][1], listOfMainFees, widget.mainfeeNumber).toString()}",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  subdivmainFees = subdivmainFees + 1;
                                  if (subdivmainFees != 1) {
                                    listOfMainFees[widget.mainfeeNumber].add(["^", "^", "^"]);
                                  }
                                  subdivmainFeesWig.add(SubDivOfMainFees(
                                    subdivofMainfeeNumber: subdivmainFees,
                                  ));
                                });
                              },
                              child: const Text("Add")),
                        ), //add
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (subdivmainFees != 1) {
                                    listOfMainFees[widget.mainfeeNumber].remove(listOfMainFees[widget.mainfeeNumber].last);
                                    subdivmainFees = subdivmainFees - 1;
                                    subdivmainFeesWig.remove(subdivmainFeesWig.last);
                                  }
                                });
                              },
                              child: const Text("Remove")),
                        ), //remove
                      ],
                    ),
                    Container(
                      color: Colors.grey.shade50,
                      height: 430,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: subdivmainFeesWig,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubDivOfMainFees extends StatefulWidget {
  final int subdivofMainfeeNumber;

  SubDivOfMainFees({required this.subdivofMainfeeNumber});

  @override
  _SubDivOfMainFeesState createState() => _SubDivOfMainFeesState();
}

class _SubDivOfMainFeesState extends State<SubDivOfMainFees> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][0] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOnly(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][0], "Sub Fee Title"),
                  label: Text("Sub Fee Title  ${widget.subdivofMainfeeNumber}")),
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][1] = val;
                  Provider.of<Data>(context, listen: false).refPage(true);
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][1], "Sub Fee Amount"),
                  label: const Text("Sub Fee Amount")),
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][2] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][2], "Sub Fee Priority"),
                  label: const Text("Sub Fee Priority")),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

//_______________________ edit Wig _________________________

class FeesAddInDivisionMainFeesEDIT extends StatefulWidget {
  final int mainfeeNumber;

  FeesAddInDivisionMainFeesEDIT({required this.mainfeeNumber});

  @override
  State<FeesAddInDivisionMainFeesEDIT> createState() => _FeesAddInDivisionMainFeesEDITState();
}

class _FeesAddInDivisionMainFeesEDITState extends State<FeesAddInDivisionMainFeesEDIT> {
  int subdivmainFees = listOfMainFees[0].length - 2;
  List<dynamic> _tempMainFees = [];

  funcGetSubValueInList() {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@$listOfMainFees@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    for (int i = 2; i < listOfMainFees[0].length; i++) {
      _tempMainFees.add(listOfMainFees[0][i]);
    }
  }

  List<Widget> subdivmainFeesWig = [];

  funcAddSubtoList() {
    int j = 1;
    for (var element in _tempMainFees) {
      subdivmainFeesWig.add(SubDivOfMainFeesEDIT(
          subdivofMainfeeNumber: j, subfeeTitle: element[0].toString(), subfeeAmount: element[1].toString(), subfeepriority: element[2].toString()));
      j++;
    }
  }

  funcFinalAsync() {
    funcGetSubValueInList();
    funcAddSubtoList();
    print(subdivmainFeesWig);
  }

  late TextEditingController _controllerDivisionMainFeeTitle;
  late TextEditingController _controllerDivisionMainFeeAmount;

  void initState() {
    // TODO: implement initState
    super.initState();
    funcFinalAsync();
    _controllerDivisionMainFeeTitle = TextEditingController(text: listOfMainFees[0][0].toString());
    _controllerDivisionMainFeeAmount = TextEditingController(text: listOfMainFees[0][1].toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerDivisionMainFeeTitle.dispose();
    _controllerDivisionMainFeeAmount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? totalFees =
        Provider.of<Data>(context, listen: true).refrashPage == true ? double.tryParse(listOfMainFees[0][1]) : double.tryParse(listOfMainFees[0][1]);
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, right: 20.0, left: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Main Fees",
                style: TextStyle(fontSize: 15),
              ),
              TextField(
                controller: _controllerDivisionMainFeeTitle,
                onChanged: (val) {
                  setState(() {
                    val == null ? val = "" : val;
                    listOfMainFees[0][0] = val;
                  });
                },
                decoration:
                    InputDecoration(errorText: listOfMainFees[0][0] == "" ? "Fee title is cannot be empty" : null, label: const Text('Fee Title*')),
              ),
              TextField(
                controller: _controllerDivisionMainFeeAmount,
                onChanged: (val) {
                  setState(() {
                    val == null ? val = "" : val;
                    listOfMainFees[0][1] = val;
                    Provider.of<Data>(context, listen: false).refPage(true);
                  });
                },
                decoration: InputDecoration(
                    errorText: funcValEmptyOrNumber(listOfMainFees[0][1], "Total Fees"),
                    // listOfMainFees[0][1] == "" ? "Fee title is cannot be empty":null ,
                    label: const Text('Total Fees')),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      "Division of Fees in $subdivmainFees parts",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total Fees: $totalFees",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Balance After Division : ${functoChkBalFee(listOfMainFees[widget.mainfeeNumber][1], listOfMainFees, widget.mainfeeNumber).toString()}",
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  subdivmainFees = subdivmainFees + 1;
                                  if (subdivmainFees != 1) {
                                    listOfMainFees[widget.mainfeeNumber].add(["^", "^", "^"]);
                                  }
                                  subdivmainFeesWig.add(SubDivOfMainFees(
                                    subdivofMainfeeNumber: subdivmainFees,
                                  ));
                                });
                              },
                              child: const Text("Add")),
                        ), //add
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (subdivmainFees != 1) {
                                    listOfMainFees[widget.mainfeeNumber].remove(listOfMainFees[widget.mainfeeNumber].last);
                                    subdivmainFees = subdivmainFees - 1;
                                    subdivmainFeesWig.remove(subdivmainFeesWig.last);
                                  }
                                });
                              },
                              child: const Text("Remove")),
                        ), //remove
                      ],
                    ),
                    Container(
                      color: Colors.grey.shade50,
                      height: 430,
                      width: 300,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Column(
                              children: subdivmainFeesWig,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubDivOfMainFeesEDIT extends StatefulWidget {
  final int subdivofMainfeeNumber;
  String subfeeTitle;
  String subfeeAmount;
  String subfeepriority;

  SubDivOfMainFeesEDIT({required this.subdivofMainfeeNumber, required this.subfeeTitle, required this.subfeeAmount, required this.subfeepriority});

  @override
  _SubDivOfMainFeesEDITState createState() => _SubDivOfMainFeesEDITState();
}

class _SubDivOfMainFeesEDITState extends State<SubDivOfMainFeesEDIT> {
  late TextEditingController _controllerDivisionMainFeesubfeeTitle;
  late TextEditingController _controllerDivisionMainFeesubfeeAmount;
  late TextEditingController _controllerDivisionMainFeesubfeePriority;

  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    // print(listOfMainFees);
    // print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
    // print("oooooooooooooooooooooooooooooooo${widget.subfeeTitle}oooooooooooooooooooooooooooooooooooooooo");
    _controllerDivisionMainFeesubfeeTitle = TextEditingController(text: widget.subfeeTitle);
    _controllerDivisionMainFeesubfeeAmount = TextEditingController(text: widget.subfeeAmount);
    _controllerDivisionMainFeesubfeePriority = TextEditingController(text: widget.subfeepriority);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerDivisionMainFeesubfeeTitle.dispose();
    _controllerDivisionMainFeesubfeeAmount.dispose();
    _controllerDivisionMainFeesubfeePriority.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            TextField(
              controller: _controllerDivisionMainFeesubfeeTitle,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][0] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOnly(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][0], "Sub Fee Title"),
                  label: Text("Sub Fee Title  ${widget.subdivofMainfeeNumber}")),
            ),
            TextField(
              controller: _controllerDivisionMainFeesubfeeAmount,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][1] = val;
                  Provider.of<Data>(context, listen: false).refPage(true);
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][1], "Sub Fee Amount"),
                  label: const Text("Sub Fee Amount")),
            ),
            TextField(
              controller: _controllerDivisionMainFeesubfeePriority,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfMainFees[0][1 + widget.subdivofMainfeeNumber][2] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfMainFees[0][1 + widget.subdivofMainfeeNumber][2], "Sub Fee Priority"),
                  label: const Text("Sub Fee Priority")),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

//_______________________________________________________________________________________________

//------------------------------- Extra Fee Wig ----------------------------------------------------
class FeesAddInDivisionExtraFees extends StatefulWidget {
  final int extrafeeNumber;

  FeesAddInDivisionExtraFees({required this.extrafeeNumber});

  @override
  State<FeesAddInDivisionExtraFees> createState() => _FeesAddInDivisionExtraFeesState();
}

class _FeesAddInDivisionExtraFeesState extends State<FeesAddInDivisionExtraFees> {
  int subdivextraFees = 1;
  List<Widget> subdivextraFeeWig = [];

  @override
  @override
  Widget build(BuildContext context) {
    if (subdivextraFeeWig.isEmpty) {
      subdivextraFeeWig.add(SubDivOfExtraFees(
        subdivofExtrafeeNumber: 1,
        extraFeeNumber: widget.extrafeeNumber,
      ));
    }
    double? totalFees = Provider.of<Data>(context, listen: true).refPageEditDivision == true
        ? double.tryParse(listOfExtraFees[0][1])
        : double.tryParse(listOfExtraFees[0][1]);
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 20.0, left: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Extra Fees ${widget.extrafeeNumber + 1}",
                  style: const TextStyle(fontSize: 15),
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      val == null ? val = "" : val;
                      listOfExtraFees[widget.extrafeeNumber][0] = val;
                    });
                  },
                  decoration: InputDecoration(
                      errorText: listOfExtraFees[widget.extrafeeNumber][0] == "" ? "Fee title is cannot be empty" : null,
                      label: const Text('Fee Title*')),
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      val == null ? val = "" : val;
                      listOfExtraFees[widget.extrafeeNumber][1] = val;
                      Provider.of<Data>(context, listen: false).refPage(true);
                    });
                  },
                  decoration: InputDecoration(
                      errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extrafeeNumber][1], "Total Fees"),
                      // listOfMainFees[0][1] == "" ? "Fee title is cannot be empty":null ,
                      label: const Text('Total Fees')),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          "Division of Fees in $subdivextraFees parts",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Total Fees: $totalFees",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Balance After Division : ${functoChkBalFee(listOfExtraFees[widget.extrafeeNumber][1], listOfExtraFees, widget.extrafeeNumber).toString()}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      subdivextraFees = subdivextraFees + 1;
                                      if (subdivextraFees != 1) {
                                        listOfExtraFees[widget.extrafeeNumber].add(["^", "^", "^"]);
                                      }
                                      subdivextraFeeWig.add(SubDivOfExtraFees(
                                        subdivofExtrafeeNumber: subdivextraFees,
                                        extraFeeNumber: widget.extrafeeNumber,
                                      ));
                                    });
                                  },
                                  child: const Text("Add")),
                            ), //add
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (subdivextraFees != 1) {
                                        listOfExtraFees[widget.extrafeeNumber].remove(listOfExtraFees[widget.extrafeeNumber].last);
                                        subdivextraFees = subdivextraFees - 1;
                                        subdivextraFeeWig.remove(subdivextraFeeWig.last);
                                      }
                                    });
                                  },
                                  child: const Text("Remove")),
                            ), //remove
                          ],
                        ),
                        Container(
                          color: Colors.grey.shade50,
                          height: 385,
                          width: 300,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: subdivextraFeeWig,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubDivOfExtraFees extends StatefulWidget {
  final int extraFeeNumber;
  final int subdivofExtrafeeNumber;

  SubDivOfExtraFees({required this.subdivofExtrafeeNumber, required this.extraFeeNumber});

  @override
  _SubDivOfExtraFeesState createState() => _SubDivOfExtraFeesState();
}

class _SubDivOfExtraFeesState extends State<SubDivOfExtraFees> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][0] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOnly(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][0], "Sub Fee Title"),
                  label: Text("Sub Fee Title ${widget.subdivofExtrafeeNumber}")),
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][1] = val;
                  Provider.of<Data>(context, listen: false).refPage(true);
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][1], "Sub Fee Amount"),
                  label: const Text("Sub Fee Amount")),
            ),
            TextField(
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][2] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][2], "Sub Fee Priority"),
                  label: const Text("Sub Fee Priority")),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

//________________ EDIT Wig ______________________________
class FeesAddInDivisionExtraFeesEDIT extends StatefulWidget {
  final int extrafeeNumber;

  FeesAddInDivisionExtraFeesEDIT({required this.extrafeeNumber});

  @override
  State<FeesAddInDivisionExtraFeesEDIT> createState() => _FeesAddInDivisionExtraFeesEDITState();
}

class _FeesAddInDivisionExtraFeesEDITState extends State<FeesAddInDivisionExtraFeesEDIT> {
  late TextEditingController _controllerDivisionExtraFeeTitle;
  late TextEditingController _controllerDivisionExtraFeeAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    funcFinalAsync();
    _controllerDivisionExtraFeeTitle = TextEditingController(text: listOfExtraFees[widget.extrafeeNumber][0].toString());
    _controllerDivisionExtraFeeAmount = TextEditingController(text: listOfExtraFees[widget.extrafeeNumber][1].toString());
  }

  List<dynamic> _tempMainFees = [];
  int? subdivextraFees;

  funcGetSubValueInList() {
    print("@@@@@@@@@@@@@@@@@@@@@@@@@$listOfExtraFees@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    subdivextraFees = listOfExtraFees[widget.extrafeeNumber].length - 2;
    for (int i = 2; i < listOfExtraFees[widget.extrafeeNumber].length; i++) {
      _tempMainFees.add(listOfExtraFees[widget.extrafeeNumber][i]);
    }
  }

  List<Widget> subdivextraFeeWig = [];

  funcAddSubtoList() {
    int j = 1;
    print("_tempMainFees = $_tempMainFees");
    for (var element in _tempMainFees) {
      subdivextraFeeWig.add(SubDivOfExtraFeesEDIT(
          extraFeeNumber: widget.extrafeeNumber,
          subdivofExtrafeeNumber: j,
          subfeeTitle: element[0].toString(),
          subfeeAmount: element[1].toString(),
          subfeepriority: element[2].toString()));
      j++;
    }
  }

  funcFinalAsync() {
    funcGetSubValueInList();
    funcAddSubtoList();
    print(subdivextraFeeWig);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerDivisionExtraFeeTitle.dispose();
    _controllerDivisionExtraFeeAmount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (subdivextraFeeWig.isEmpty) {
      subdivextraFeeWig.add(SubDivOfExtraFees(
        subdivofExtrafeeNumber: 1,
        extraFeeNumber: widget.extrafeeNumber,
      ));
    }
    double? totalFees = Provider.of<Data>(context, listen: true).refrashPage == true
        ? double.tryParse(listOfExtraFees[0][1])
        : double.tryParse(listOfExtraFees[0][1]);
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, right: 20.0, left: 20, bottom: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Extra Fees ${widget.extrafeeNumber + 1}",
                  style: const TextStyle(fontSize: 15),
                ),
                TextField(
                  controller: _controllerDivisionExtraFeeTitle,
                  onChanged: (val) {
                    setState(() {
                      val == null ? val = "" : val;
                      listOfExtraFees[widget.extrafeeNumber][0] = val;
                    });
                  },
                  decoration: InputDecoration(
                      errorText: listOfExtraFees[widget.extrafeeNumber][0] == "" ? "Fee title is cannot be empty" : null,
                      label: const Text('Fee Title*')),
                ),
                TextField(
                  controller: _controllerDivisionExtraFeeAmount,
                  onChanged: (val) {
                    setState(() {
                      val == null ? val = "" : val;
                      listOfExtraFees[widget.extrafeeNumber][1] = val;
                      Provider.of<Data>(context, listen: false).refPage(true);
                    });
                  },
                  decoration: InputDecoration(
                      errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extrafeeNumber][1], "Total Fees"),
                      // listOfMainFees[0][1] == "" ? "Fee title is cannot be empty":null ,
                      label: const Text('Total Fees')),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          "Division of Fees in $subdivextraFees parts",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Total Fees: $totalFees",
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          "Balance After Division : ${functoChkBalFee(listOfExtraFees[widget.extrafeeNumber][1], listOfExtraFees, widget.extrafeeNumber).toString()}",
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      subdivextraFees = subdivextraFees! + 1;
                                      if (subdivextraFees != 1) {
                                        listOfExtraFees[widget.extrafeeNumber].add(["^", "^", "^"]);
                                      }
                                      subdivextraFeeWig.add(SubDivOfExtraFees(
                                        subdivofExtrafeeNumber: subdivextraFees!,
                                        extraFeeNumber: widget.extrafeeNumber,
                                      ));
                                    });
                                  },
                                  child: const Text("Add")),
                            ), //add
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (subdivextraFees != 1) {
                                        listOfExtraFees[widget.extrafeeNumber].remove(listOfExtraFees[widget.extrafeeNumber].last);
                                        subdivextraFees = subdivextraFees! - 1;
                                        subdivextraFeeWig.remove(subdivextraFeeWig.last);
                                      }
                                    });
                                  },
                                  child: const Text("Remove")),
                            ), //remove
                          ],
                        ),
                        Container(
                          color: Colors.grey.shade50,
                          height: 385,
                          width: 300,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Column(
                                  children: subdivextraFeeWig,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubDivOfExtraFeesEDIT extends StatefulWidget {
  final int extraFeeNumber;
  final int subdivofExtrafeeNumber;
  String subfeeTitle;
  String subfeeAmount;
  String subfeepriority;

  SubDivOfExtraFeesEDIT(
      {required this.subdivofExtrafeeNumber,
      required this.extraFeeNumber,
      required this.subfeeTitle,
      required this.subfeeAmount,
      required this.subfeepriority});

  @override
  _SubDivOfExtraFeesEDITState createState() => _SubDivOfExtraFeesEDITState();
}

class _SubDivOfExtraFeesEDITState extends State<SubDivOfExtraFeesEDIT> {
  late TextEditingController _controllerDivisionExtraFeesubfeeTitle;
  late TextEditingController _controllerDivisionExtraFeesubfeeAmount;
  late TextEditingController _controllerDivisionExtraFeesubfeePriority;

  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_){
    // print(listOfExtraFees);
    // print("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj");
    // print("oooooooooooooooooooooooooooooooo${widget.subfeeTitle}oooooooooooooooooooooooooooooooooooooooo");
    _controllerDivisionExtraFeesubfeeTitle = TextEditingController(text: widget.subfeeTitle);
    _controllerDivisionExtraFeesubfeeAmount = TextEditingController(text: widget.subfeeAmount);
    _controllerDivisionExtraFeesubfeePriority = TextEditingController(text: widget.subfeepriority);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerDivisionExtraFeesubfeeTitle.dispose();
    _controllerDivisionExtraFeesubfeeAmount.dispose();
    _controllerDivisionExtraFeesubfeePriority.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: [
            TextField(
              controller: _controllerDivisionExtraFeesubfeeTitle,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][0] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOnly(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][0], "Sub Fee Title"),
                  label: Text("Sub Fee Title ${widget.subdivofExtrafeeNumber}")),
            ),
            TextField(
              controller: _controllerDivisionExtraFeesubfeeAmount,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][1] = val;
                  Provider.of<Data>(context, listen: false).refPage(true);
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][1], "Sub Fee Amount"),
                  label: const Text("Sub Fee Amount")),
            ),
            TextField(
              controller: _controllerDivisionExtraFeesubfeePriority,
              onChanged: (val) {
                setState(() {
                  val == null ? val = "" : val;
                  listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][2] = val;
                });
              },
              decoration: InputDecoration(
                  errorText: funcValEmptyOrNumber(listOfExtraFees[widget.extraFeeNumber][1 + widget.subdivofExtrafeeNumber][2], "Sub Fee Priority"),
                  label: const Text("Sub Fee Priority")),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

//_______________________________________________________________________________________________
