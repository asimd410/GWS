
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:provider/provider.dart';

import 'dataTable/DataTableForSubjectsView.dart';

bool showAddSubject = false;
String addSubjectName = "";
bool addSubjectNameError = false;
String addSubjectNameErrorText = "";

class SubjectCreateViewWig extends StatefulWidget {
  const SubjectCreateViewWig({Key? key}) : super(key: key);

  @override
  _SubjectCreateViewWigState createState() => _SubjectCreateViewWigState();
}

class _SubjectCreateViewWigState extends State<SubjectCreateViewWig> {
  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Container(
        height: 500,
        color: Colors.grey.shade50,
        width: (screenW) - 2,
        child: Provider.of<Data>(context, listen: true).refrashPageEditSubject == true
            ? SubjectCreateViewSUB(
                screenW: screenW,
              )
            : SubjectCreateViewSUB(
                screenW: screenW,
              ));
  }
}

//---------------------------------------------------------------------------------------------
class SubjectCreateViewSUB extends StatefulWidget {
  double screenW;

  SubjectCreateViewSUB({required this.screenW});

  @override
  _SubjectCreateViewSUBState createState() => _SubjectCreateViewSUBState();
}

class _SubjectCreateViewSUBState extends State<SubjectCreateViewSUB> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text("Add Subject"),
                onPressed: () {
                  setState(() {
                    showAddSubject = true;
                  });
                }),
            SizedBox(height: 15),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    height: 400, width: widget.screenW,
                    child: showAddSubject == true?Container():showEditSubject==true?Container():delSubject==true? Container():DataPageSubjeect(width: widget.screenW < 499 ? 499 : widget.screenW))), // DataTABLE
          ],
        ),
        showAddSubject == true
            ? GlassContainer(
                height: 500,
                width: (widget.screenW) - 2,
                child: Center(
                  child: SizedBox(
                    height: 280,
                    width: 260,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
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
                                          "Add Academic Year Name",
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
                                          showAddSubject = false;
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
                              color: Colors.blue),
                          Center(
                            child: SizedBox(
                                height: 240,
                                width: 200,
                                child: Column(
                                  children: [
                                    TextField(
                                      onChanged: (val) {
                                        setState(() {
                                          addSubjectName = val;
                                        });
                                      },
                                      decoration: InputDecoration(
                                          errorText: addSubjectName == "" ? "Subject name cannot be empty" : null, label: const Text('Subject Name')),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (addSubjectName == "") {
                                            setState(() {
                                              final snackBar = SnackBar(
                                                content: const Text(' Subject name cannot be empty'),
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
                                            createSubject_responseBody = await httpPost(
                                              msgToSend: {"subject": addSubjectName.toString().toLowerCase(), "updatedBy": userName},
                                              destinationPort: 8080,
                                              destinationPost: "/addSubject",
                                              destinationUrl: mainDomain,
                                            );
                                            print("responseBody = $createSubject_responseBody");
                                            if (createSubject_responseBody == "Subject Already Exists") {
                                              setState(() {
                                                final snackBar = SnackBar(
                                                  content: const Text("Subject name Already Exists"),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (createSubject_responseBody == "Saved") {
                                              setState(() {
                                                showAddSubject = false;
                                                final snackBar = SnackBar(
                                                  content: const Text('Subject name has been added in the System'),
                                                  backgroundColor: (Colors.black),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
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
                                          }
                                        },
                                        child: const Text("Create"))
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            : Container(),
        delSubject == true ? SubjectCreateViewDELETE() : Container(),
        showEditSubject == true
            ? SubjectCreateViewEDIT(
                screenW: widget.screenW,
              )
            : Container()
      ],
    );
  }
}

//---------------------------------------------------------------------------------------------
class SubjectCreateViewDELETE extends StatefulWidget {
  const SubjectCreateViewDELETE({Key? key}) : super(key: key);

  @override
  _SubjectCreateViewDELETEState createState() => _SubjectCreateViewDELETEState();
}

class _SubjectCreateViewDELETEState extends State<SubjectCreateViewDELETE> {
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
                              delSubject = false;
                              Provider.of<Data>(context, listen: false).refPageEditSubject(true);
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
                            child: Text("Are you sure you want to Delete $deleteSubject Subject"),
                          )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  print("in it");
                                  deleteSubject_responseBody = await httpPost(
                                    msgToSend: {"msg": "delSubjectinDB", "id": deleteSubject_id!},
                                    destinationPort: 8080,
                                    destinationPost: "/addsubject/deleteSubjectinDB",
                                    destinationUrl: mainDomain,
                                  );
                                  if (deleteSubject_responseBody == "deleted successfully") {
                                    print("deleteSubject_responseBody.toString() = ${deleteSubject_responseBody.toString()}");
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Subject $deleteSubject has been deleted"),
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
                                      print("deleteSubject_responseBody.toString() = ${deleteSubject_responseBody.toString()}");
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
                                    delSubject = false;
                                    Provider.of<Data>(context, listen: false).refPageEditSubject(true);
                                  });
                                },
                                child: Text("Yes Delete Confirm")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    delSubject = false;
                                    Provider.of<Data>(context, listen: false).refPageEditSubject(true);
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

//---------------------------------------------------------------------------------------------
class SubjectCreateViewEDIT extends StatefulWidget {
  double screenW;

  SubjectCreateViewEDIT({required this.screenW});

  @override
  _SubjectCreateViewEDITState createState() => _SubjectCreateViewEDITState();
}

class _SubjectCreateViewEDITState extends State<SubjectCreateViewEDIT> {
  late TextEditingController _controllerSubjectName;

  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerSubjectName = TextEditingController(text: editSubjectToEdit);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerSubjectName.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        height: 500,
        width: (widget.screenW) - 2,
        child: Center(
          child: SizedBox(
            height: 280,
            width: 260,
            child: Card(
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
                                  "Edit Subject Name",
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
                                  showEditSubject = false;
                                  Provider.of<Data>(context, listen: false).refPageEditSubject(true);
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
                                  ))),
                            ),
                          )
                        ],
                      ),
                      color: Colors.blue), //Top Bar
                  Center(
                    child: SizedBox(
                        height: 240,
                        width: 200,
                        child: Column(
                          children: [
                            TextField(
                              controller: _controllerSubjectName,
                              onChanged: (val) {
                                setState(() {
                                  editSubjectToSave = val;
                                });
                              },
                              decoration: InputDecoration(
                                  errorText: editSubjectToSave == "" ? "Subject name cannot be empty" : null, label: const Text('Subject Name')),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                onPressed: () async {
                                  if (editSubjectToSave == "") {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: const Text(' Subject name cannot be empty'),
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
                                    print("************** editSubjectToSave = $editSubjectToSave");
                                    editSubject_responseBody = await httpPost(
                                      msgToSend: {
                                        "msg": "editSubjectinDB",
                                        "subject": editSubjectToSave.toString().toLowerCase(),
                                        "updatedBy": userName,
                                        "subjecttoEdit": editSubjectToEdit!
                                      },
                                      destinationPort: 8080,
                                      destinationPost: "/addsubject/editSubjectinDB",
                                      destinationUrl: mainDomain,
                                    );
                                    print("responseBody = ${editSubject_responseBody.toString()}");
                                    if (editSubject_responseBody == "Successfully Updated") {
                                      setState(() {
                                        final snackBar = SnackBar(
                                          content: const Text("Subject Name has been successfully updated"),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            label: 'dismiss',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        showEditSubject = false;
                                        Provider.of<Data>(context, listen: false).refPageEditSubject(true);
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
                                  }
                                },
                                child: const Text("Update"))
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
