
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:provider/provider.dart';

import 'dataTable/DataTableForClassView.dart';

bool showAddClass = false;
String addClassName = "";
bool addClassNameError = false;
String addClassNameErrorText = "";


class ClassCreateViewWig extends StatefulWidget {
  const ClassCreateViewWig({Key? key}) : super(key: key);

  @override
  _ClassCreateViewWigState createState() => _ClassCreateViewWigState();
}

class _ClassCreateViewWigState extends State<ClassCreateViewWig> {
  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Container(
        height: 500,
        color: Colors.grey.shade50,
        width: (screenW) - 2,
        child: Provider.of<Data>(context, listen: true).refrashPageEditClass == true
            ? ClassCreateViewSUB(
                screenW: screenW,
              )
            : ClassCreateViewSUB(
                screenW: screenW,
              ));
  }
}

class ClassCreateViewSUB extends StatefulWidget {
  double screenW;

  ClassCreateViewSUB({required this.screenW});

  @override
  _ClassCreateViewSUBState createState() => _ClassCreateViewSUBState();
}

class _ClassCreateViewSUBState extends State<ClassCreateViewSUB> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text("Add Class"),
                onPressed: () {
                  setState(() {
                    showAddClass = true;
                    addClassNameError = false;
                  });
                }),
            SizedBox(height: 15),
            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                    height: 400,
                    width: widget.screenW,
                    child: showAddClass == true?Container():showEditClass==true?Container():delClass==true? Container():DataPageClassView(
                      width: widget.screenW < 499 ? 499 : widget.screenW,
                    ))),
          ],
        ),
        showAddClass == true
            ? GlassContainer(
                height: 500,
                width: (widget.screenW) - 2,
                child: Center(
                  child: SizedBox(
                    height: 210,
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
                                          "Add Class",
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
                                          showAddClass = false;
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
                              color: Colors.blue),
                          SizedBox(height: 20),
                          Center(
                            child: Container(
                                height: 150,
                                width: 200,
                                child: Column(
                                  children: [
                                    TextField(
                                      onChanged: (value) {
                                        addClassName = value;
                                      },
                                      decoration: InputDecoration(
                                          errorText: addClassNameError == false ? null : addClassNameErrorText, label: const Text('Class Name')),
                                    ),
                                    const SizedBox(height: 30),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (addClassName == "") {
                                            setState(() {
                                              addClassNameError = true;
                                              addClassNameErrorText = "Class name cannot be empty";
                                              final snackBar = SnackBar(
                                                content: const Text('Class name cannot be empty'),
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
                                            createClass_responseBody = await httpPost(
                                              msgToSend: {"className": addClassName.toString().toLowerCase()},
                                              destinationPort: 8080,
                                              destinationPost: "/addClass",
                                              destinationUrl: mainDomain,
                                            );
                                            print("responseBody = $createClass_responseBody");
                                            if (createClass_responseBody == "Class Name Alread Exists") {
                                              setState(() {
                                                addClassNameError = true;
                                                addClassNameErrorText = "Class Name Alread Exists";
                                                final snackBar = SnackBar(
                                                  content: const Text("Class Name Alread Exists"),
                                                  backgroundColor: (Colors.red),
                                                  action: SnackBarAction(
                                                    label: 'dismiss',
                                                    textColor: Colors.white,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            } else if (createClass_responseBody == "Saved") {
                                              setState(() {
                                                addClassNameError = false;
                                                showAddClass = false;
                                                final snackBar = SnackBar(
                                                  content: const Text('Class has been added in the System'),
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
        showEditClass == true
            ? ClassCreateViewEdit(screenW: widget.screenW,)
            : Container(),
        delClass == true ?
        ClassCreateViewDELETE(): Container(),

      ],
    );
  }
}




//____________________________________________________ DELETE CONFIRMATION BOX _____________________________________________________________________
class ClassCreateViewDELETE extends StatefulWidget {
  const ClassCreateViewDELETE({Key? key}) : super(key: key);

  @override
  _ClassCreateViewDELETEState createState() => _ClassCreateViewDELETEState();
}

class _ClassCreateViewDELETEState extends State<ClassCreateViewDELETE> {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        height:500,
        child:  Padding(
          padding: const EdgeInsets.only(top:150.0),
          child: Container(
              child:Column(children: [
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
                                delClass = false;
                                Provider.of<Data>(context, listen: false).refPageEditClass(true);
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
                    color: Colors.red),
                Center(
                  child: Card(
                    child: Container(
                      color:Colors.grey.shade100,
                      height: 115, width:250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  [
                          SizedBox(height:75,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Are you sure you want to Delete $deleteClass Class"),
                            )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(onPressed: ()async{
                                print("in it");
                                deleteClass_responseBody = await httpPost(
                                  msgToSend: {"msg": "delClassinDB", "id": deleteClass_id!},
                                  destinationPort: 8080,
                                  destinationPost: "/addClass/deleteClassinDB",
                                  destinationUrl: mainDomain,
                                );
                                if (deleteClass_responseBody == "deleted successfully") {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text("Class $deleteClass has been deleted"),
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
                                  setState((){
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
                                  delClass = false;
                                  Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
                                });
                              }, child: Text("Yes Delete Confirm")),
                              ElevatedButton(onPressed: (){
                                setState(() {
                                  delClass = false;
                                  Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
                                });
                              }, child: Text("Cancel"))
                            ],
                          ),

                        ],),
                    ),
                  ),
                )
              ],
              )
          ),
        )
    );
  }
}



//____________________________________________________ EDIT _____________________________________________________________________
class ClassCreateViewEdit extends StatefulWidget {

  double screenW;
  ClassCreateViewEdit({required this.screenW});

  @override
  _ClassCreateViewEditState createState() => _ClassCreateViewEditState();
}

class _ClassCreateViewEditState extends State<ClassCreateViewEdit> {
  late TextEditingController _controllerClassName;
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerClassName = TextEditingController(text: editClassToEdit);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerClassName.dispose();
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
                                  "Edit Class Name",
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
                                  showEditClass = false;
                                  Provider.of<Data>(context, listen: false).refPageEditClass(true);
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
                                  )),
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
                              controller: _controllerClassName,
                              onChanged: (val) {
                                setState(() {
                                  editClassToSave = val;
                                });
                              },
                              decoration: InputDecoration(
                                  errorText: editClassToSave == "" ? "Class name cannot be empty" : null,
                                  label: const Text('Class Name')),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                onPressed: () async {
                                  if (editClassToSave == "") {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: const Text(' Class name cannot be empty'),
                                        backgroundColor: (Colors.red),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }  else {
                                    print("************** editClassToSave = $editClassToSave" );
                                    editClass_responseBody = await httpPost(
                                      msgToSend: {
                                        "msg": "editClassinDB",
                                        "class": editClassToSave.toString().toLowerCase(),
                                        "updatedBy": userName,
                                        "classtoEdit": editClassToEdit!
                                      },
                                      destinationPort: 8080,
                                      destinationPost: "/addClass/editClassinDB",
                                      destinationUrl: mainDomain,
                                    );
                                    print("responseBody = ${editClass_responseBody.toString()}");
                                    if (editClass_responseBody == "Successfully Updated") {
                                      setState(() {
                                        final snackBar = SnackBar(
                                          content: const Text("Class Name has been successfully updated"),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            label: 'dismiss',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        showEditClass = false;
                                        Provider.of<Data>(context, listen: false).refPageEditClass(true);
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



















