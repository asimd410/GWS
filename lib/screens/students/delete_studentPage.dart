import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:provider/provider.dart';
import 'add_student_page.dart';

class Delete_StudentPage extends StatefulWidget {
  const Delete_StudentPage({Key? key}) : super(key: key);

  @override
  _Delete_StudentPageState createState() => _Delete_StudentPageState();
}

class _Delete_StudentPageState extends State<Delete_StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                  funcMakeVarNullStudents();
                                  showDeleteStudentPage = false;
                                  refreshStudentTable = true;
                                  Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
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
                                    child: Text("Are you sure you want to Delete \"$studentFirstNameAdd $fathersNameAdd $studentLastNameAdd\" "),
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      print("in it");
                                      deleteStudent_http_responseBodyJSON = await httpPost(
                                        msgToSend: {"msg": "delStudentinDB", "id": delete_ID},
                                        destinationPort: 8080,
                                        destinationPost: "/addStudent/deleteStudentsInDB",
                                        destinationUrl: mainDomain,
                                      );
                                      if (deleteStudent_http_responseBodyJSON == "deleted successfully") {
                                        setState(() {
                                          final snackBar = SnackBar(
                                            content: Text("$studentFirstNameAdd $fathersNameAdd $studentLastNameAdd has been deleted"),
                                            backgroundColor: (Colors.red),
                                            action: SnackBarAction(
                                              label: 'dismiss',
                                              textColor: Colors.white,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        });

                                        setState(() {
                                          funcMakeVarNullStudents();
                                          showDeleteStudentPage = false;
                                          refreshStudentTable = true;
                                          Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                                        });

                                      }
                                      // else if (deleteStudent_http_responseBodyJSON  == "Academic year is in use in one or more of the divisions") {
                                      //   setState(() {
                                      //     final snackBar = SnackBar(
                                      //       content: Text("Academic Year $deleteAcadYrYear is in use in one or more of the Divisions"),
                                      //       backgroundColor: (Colors.red),
                                      //       action: SnackBarAction(
                                      //         label: 'dismiss',
                                      //         textColor: Colors.white,
                                      //         onPressed: () {},
                                      //       ),
                                      //     );
                                      //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      //   });
                                      // }
                                      else {
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
                                      setState(() {
                                        funcMakeVarNullStudents();
                                        showDeleteStudentPage = false;
                                        refreshStudentTable = true;
                                        Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                                      });
                                    },
                                    child: Text("Yes Delete Confirm")),
                                ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        funcMakeVarNullStudents();
                                        showDeleteStudentPage = false;
                                        refreshStudentTable = true;
                                        Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
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