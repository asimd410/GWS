import 'package:dropdown_search/dropdown_search.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:provider/provider.dart';
import 'dataTable/DataTableForAcadYrView.dart';

bool showAddAcadYr = false;
String? addAcadYrFrom;
bool addAcadYrErrorFrom = false;
String addAcadYrErrorTextFrom = "";
String? addAcadYrTo;
bool addAcadYrErrorTo = false;
String addAcadYrErrorTextTo = "";

class AcademicYrCreateView extends StatefulWidget {
  const AcademicYrCreateView({Key? key}) : super(key: key);

  @override
  _AcademicYrCreateViewState createState() => _AcademicYrCreateViewState();
}

class _AcademicYrCreateViewState extends State<AcademicYrCreateView> {
  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Container(
        height: 500,
        color: Colors.grey.shade50,
        width: (screenW) - 2,
        child: Provider.of<Data>(context, listen: true).refrashPageEditAcadyr == true
            ? AcademicYrCreateViewSUB(
                screenW: screenW,
              )
            : AcademicYrCreateViewSUB(
                screenW: screenW,
              ));
  }
}

//------------------------------------------------------ Main Sub ------------------------------------------------------------------------------------
class AcademicYrCreateViewSUB extends StatefulWidget {
  double screenW;

  AcademicYrCreateViewSUB({required this.screenW});

  @override
  _AcademicYrCreateViewSUBState createState() => _AcademicYrCreateViewSUBState();
}

class _AcademicYrCreateViewSUBState extends State<AcademicYrCreateViewSUB> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text("Academic Year Details", style:TextStyle(fontSize: 18)),
            // SizedBox(height:10),
            ElevatedButton(
                child: const Text("Add Academic Year"),
                onPressed: () {
                  setState(() {
                    showAddAcadYr = true;
                  });
                }),
            SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: 400,
                width: widget.screenW,
                child: showAddAcadYr == true
                    ? Container()
                    : showEditAcadYr == true
                        ? Container()
                        : delAcadYr == true
                            ? Container()
                            : DataPageAcadYr(width: widget.screenW < 499 ? 499 : widget.screenW),
              ),
            ),
            // DataTABLE
          ],
        ),
        showAddAcadYr == true
            ? AcademicYrCreateViewADD(
                screenW: widget.screenW,
              )
            : Container(),
        showEditAcadYr == true
            ? AcademicYrCreateViewEdit(
                screenW: widget.screenW,
              )
            : Container(),
        delAcadYr == true ? AcadYrCreateViewDELETE() : Container(),
      ],
    );
  }
}

//------------------------------------------------------ Add Academic Year ------------------------------------------------------------------------------------

class AcademicYrCreateViewADD extends StatefulWidget {
  double screenW;

  AcademicYrCreateViewADD({required this.screenW});

  @override
  State<AcademicYrCreateViewADD> createState() => _AcademicYrCreateViewADDState();
}

class _AcademicYrCreateViewADDState extends State<AcademicYrCreateViewADD> {
  String? _chosenValueAcadYrOne;
  int? _int_chosenValueAcadYr;

  String? _chosenValueAcadYrTwo;
  List<String> listOfAcadYrforCV = [
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
    '2034',
    '2035',
    '2036',
    '2037',
    '2038',
    '2039',
    '2040',
    '2041',
    '2042',
    '2043',
    '2044',
    '2045',
    '2046',
    '2047',
    '2048',
    '2049',
    '2050',
    '2051',
    '2052',
    '2053',
    '2054',
    '2055'
  ];
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
                                  showAddAcadYr = false;
                                  Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
                                });
                              },
                              splashColor: Colors.white,
                              child: Ink(
                                height: 30,
                                width: 30,
                                child: const Center(
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                ),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                items: listOfAcadYrforCV,
                                dropdownSearchDecoration: const InputDecoration(
                                  hintText: "Select an Acad Yr From",
                                  labelText: "Academic Year From*",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                                isFilteredOnline: true,
                                showSearchBox: true,
                                onChanged: (v) {
                                  setState(() {
                                    _chosenValueAcadYrOne = v;
                                    _int_chosenValueAcadYr = _chosenValueAcadYrOne != null ? int.parse(_chosenValueAcadYrOne!) : null;
                                    _chosenValueAcadYrTwo = _chosenValueAcadYrOne != null ? (_int_chosenValueAcadYr! + 1).toString() : null;
                                  });
                                },
                                // selectedItem: "2021-2022",
                              ),
                            ), //AACADEMIC YEAR
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Academic Year To"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(child: Text(_chosenValueAcadYrTwo ?? "-")),
                                height: 40,
                                width: 200,
                                decoration:
                                    BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4.0)), border: Border.all(color: containerBorderColor)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_chosenValueAcadYrOne == null) {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: const Text(' Academic Year from or to cannot be empty'),
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
                                    String tempAcadYr = "$_chosenValueAcadYrOne-$_chosenValueAcadYrTwo";
                                    createAcadYr_responseBody = await httpPost(
                                      msgToSend: {"acadYr": tempAcadYr.toString().toLowerCase(), "updatedBy": userName},
                                      destinationPort: 8080,
                                      destinationPost: "/addAcademicYear",
                                      destinationUrl: mainDomain,
                                    );
                                    print("responseBody = $createAcadYr_responseBody");
                                    if (createAcadYr_responseBody == "Academic Year Alread Exists") {
                                      setState(() {
                                        final snackBar = SnackBar(
                                          content: const Text("Academic Year Alread Exists"),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            label: 'dismiss',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });
                                    } else if (createAcadYr_responseBody == "Saved") {
                                      setState(() {
                                        showAddAcadYr = false;
                                        Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
                                        final snackBar = SnackBar(
                                          content: const Text('Academic Year has been added in the System'),
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
        ));
  }
}

//____________________________________________________ DELETE CONFIRMATION BOX _____________________________________________________________________

class AcadYrCreateViewDELETE extends StatefulWidget {
  const AcadYrCreateViewDELETE({Key? key}) : super(key: key);

  @override
  _AcadYrCreateViewDELETEState createState() => _AcadYrCreateViewDELETEState();
}

class _AcadYrCreateViewDELETEState extends State<AcadYrCreateViewDELETE> {
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
                              delAcadYr = false;
                              Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
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
                            child: Text("Are you sure you want to Delete $deleteAcadYrYear Academic Year"),
                          )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  print("in it");
                                  deleteAcadYr_responseBody = await httpPost(
                                    msgToSend: {"msg": "delAcadYrinDB", "id": deleteAcadYr_id!},
                                    destinationPort: 8080,
                                    destinationPost: "/addAcademicYear/deleteAcadYrinDB",
                                    destinationUrl: mainDomain,
                                  );
                                  if (deleteAcadYr_responseBody == "deleted successfully") {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Academic Year $deleteAcadYrYear has been deleted"),
                                        backgroundColor: (Colors.red),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  }else if (deleteAcadYr_responseBody == "Academic year is in use in one or more of the divisions") {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: Text("Academic Year $deleteAcadYrYear is in use in one or more of the Divisions"),
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
                                  setState(() {
                                    delAcadYr = false;
                                    Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
                                  });
                                },
                                child: Text("Yes Delete Confirm")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    delAcadYr = false;
                                    Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
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

//____________________________________________________ EDIT _____________________________________________________________________

class AcademicYrCreateViewEdit extends StatefulWidget {
  double screenW;

  AcademicYrCreateViewEdit({required this.screenW});

  @override
  _AcademicYrCreateViewEditState createState() => _AcademicYrCreateViewEditState();
}

class _AcademicYrCreateViewEditState extends State<AcademicYrCreateViewEdit> {
  @override
  late TextEditingController _controllerAcadYrFROM;
  late TextEditingController _controllerAcadYrTO;

  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerAcadYrFROM = new TextEditingController(text: editAcadYrFrom);
    _controllerAcadYrTO = new TextEditingController(text: editAcadYrTo);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerAcadYrFROM.dispose();
    _controllerAcadYrTO.dispose();
  }
  String? _chosenValueAcadYrOne;
  int? _int_chosenValueAcadYr;

  String? _chosenValueAcadYrTwo;
  List<String> listOfAcadYrforCV = [
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
    '2031',
    '2032',
    '2033',
    '2034',
    '2035',
    '2036',
    '2037',
    '2038',
    '2039',
    '2040',
    '2041',
    '2042',
    '2043',
    '2044',
    '2045',
    '2046',
    '2047',
    '2048',
    '2049',
    '2050',
    '2051',
    '2052',
    '2053',
    '2054',
    '2055'
  ];
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
                                  "Edit Academic Year Name",
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
                                  showEditAcadYr = false;
                                  Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
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
                      color: Colors.blue), //Top Bar
                  Center(
                    child: SizedBox(
                        height: 240,
                        width: 200,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                items: listOfAcadYrforCV,
                                dropdownSearchDecoration: const InputDecoration(
                                  hintText: "Select an Acad Yr From",
                                  labelText: "Academic Year From*",
                                  contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  border: OutlineInputBorder(),
                                ),
                                isFilteredOnline: true,
                                showSearchBox: true,
                                onChanged: (v) {
                                  setState(() {
                                    _chosenValueAcadYrOne = v;
                                    _int_chosenValueAcadYr = _chosenValueAcadYrOne != null ? int.parse(_chosenValueAcadYrOne!) : null;
                                    _chosenValueAcadYrTwo = _chosenValueAcadYrOne != null ? (_int_chosenValueAcadYr! + 1).toString() : null;
                                  });
                                },
                                // selectedItem: "2021-2022",
                              ),
                            ), //AACADEMIC YEAR
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text("Academic Year To"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(child: Text(_chosenValueAcadYrTwo ?? "-")),
                                height: 40,
                                width: 200,
                                decoration:
                                BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(4.0)), border: Border.all(color: containerBorderColor)),
                              ),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                                onPressed: () async {
                                  if (editAcadYrFrom == "" || editAcadYrTo == "") {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: const Text(' Academic Year from or to cannot be empty'),
                                        backgroundColor: (Colors.red),
                                        action: SnackBarAction(
                                          label: 'dismiss',
                                          textColor: Colors.white,
                                          onPressed: () {},
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    });
                                  } else if (editAcadYrFrom!.contains("-") || editAcadYrTo!.contains("-")) {
                                    setState(() {
                                      final snackBar = SnackBar(
                                        content: const Text(' Academic Year from or to cannot contain " - "'),
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
                                    String tempAcadYr = "$_chosenValueAcadYrOne-$_chosenValueAcadYrTwo";
                                    editAcadYr_responseBody = await httpPost(
                                      msgToSend: {
                                        "msg": "editAcadYrinDB",
                                        "acadYr": tempAcadYr.toString().toLowerCase(),
                                        "updatedBy": userName,
                                        "yeartoEdit": editAcadYrFromAndTo!
                                      },
                                      destinationPort: 8080,
                                      destinationPost: "/addAcademicYear/editAcadYrinDB",
                                      destinationUrl: mainDomain,
                                    );
                                    print("responseBody = ${editAcadYr_responseBody.toString()}");
                                    if (editAcadYr_responseBody == "Successfully Updated") {
                                      setState(() {
                                        final snackBar = SnackBar(
                                          content: const Text("Academic Year has been successfully updated"),
                                          backgroundColor: (Colors.red),
                                          action: SnackBarAction(
                                            label: 'dismiss',
                                            textColor: Colors.white,
                                            onPressed: () {},
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        showEditAcadYr = false;
                                        Provider.of<Data>(context, listen: false).refPageEditAcadyr(true);
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
