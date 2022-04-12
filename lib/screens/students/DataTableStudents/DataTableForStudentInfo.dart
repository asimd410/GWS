import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/screens/students/add_student_page.dart';
import 'package:responsive_table/responsive_table.dart';
import 'dart:math';
import 'dart:convert';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:provider/provider.dart';

import '../FilteredPanelStudent.dart';

class DataPageStudentInfo extends StatefulWidget {
  double width;
  double height;

  DataPageStudentInfo({required this.width, required this.height});

  @override
  _DataPageStudentInfoState createState() => _DataPageStudentInfoState();
}

class _DataPageStudentInfoState extends State<DataPageStudentInfo> {
  late List<DatatableHeader> _headers;

  List<int> _perPages = [10, 20, 50, 100];
  int _total = 100;
  int? _currentPerPage = 10;
  List<bool>? _expanded;
  String? _searchKey = "id";

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selecteds = [];

  // ignore: unused_field
  String _selectableKey = "id";

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = true;
  var random = new Random();

  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    showStudentFilteredSearch_responseBodyJSON = await httpPost(
      msgToSend: {
        "msg": "viewStudentsInDBFiltered",
        "nameStudent": studentNameFilteredSearch,
        "acadYrStudent": acadYrFilteredSearch,
        "classStudent": classFilteredSearch,
        "divStudent": divisionFilteredSearch,
        "enableStatusStudent": enabledStatusFilteredSearch
      },
      destinationPort: 8080,
      destinationPost: "/addStudent/viewStudentsInDBFiltered",
      destinationUrl: mainDomain,
    );
    var showStudentFilteredSearch_responseBody = json.decode(showStudentFilteredSearch_responseBodyJSON!);

    List<Map<String, dynamic>> showStudentFilteredSearch_responseBodyTemp = [];

    showStudentFilteredSearch_responseBody.forEach((e) {
      showStudentFilteredSearch_responseBodyTemp.add(e);
    });

    for (int i = 0; i < showStudentFilteredSearch_responseBodyTemp.length; i++) {
      showStudentFilteredSearch_responseBodyTemp[i]["ShowID"] = i + 1;
      showStudentFilteredSearch_responseBodyTemp[i].remove("__v");
    }
    _expanded = List.generate(_currentPerPage!, (index) => false);
    setState(() {
      if (showStudentFilteredSearch_responseBodyTemp.length <= 10) {
        _perPages = [showStudentFilteredSearch_responseBodyTemp.length];
        _currentPerPage = showStudentFilteredSearch_responseBodyTemp.length;
      } else if (showStudentFilteredSearch_responseBodyTemp.length > 10 && showStudentFilteredSearch_responseBodyTemp.length < 20) {
        _perPages = [10, showStudentFilteredSearch_responseBodyTemp.length];
        _currentPerPage = 10;
      } else if (showStudentFilteredSearch_responseBodyTemp.length >= 20 && showStudentFilteredSearch_responseBodyTemp.length < 50) {
        _perPages = [10, 20, showStudentFilteredSearch_responseBodyTemp.length];
        _currentPerPage = 10;
      } else if (showStudentFilteredSearch_responseBodyTemp.length >= 50 && showStudentFilteredSearch_responseBodyTemp.length < 100) {
        _perPages = [10, 20, 50, showStudentFilteredSearch_responseBodyTemp.length];
        _currentPerPage = 10;
      }
    });
    // _currentPerPage = 10;

    // _currentPerPage =  showClass_responseBodyTemp.length;

    setState(() => _isLoading = true);

    Future.delayed(Duration(seconds: 3)).then((value) {
      _expanded = List.generate(_currentPerPage!, (index) => false);
      _sourceOriginal.clear();
      _sourceOriginal.addAll(showStudentFilteredSearch_responseBodyTemp
          // _generateData(n: random.nextInt(10000))
          );
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen = _total - start < _currentPerPage! ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen as int, (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      setState(() => _isLoading = false);
    });
  }

  _filterData(value) {
    setState(() => _isLoading = true);

    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered =
            _sourceOriginal.where((data) => data[_searchKey!].toString().toLowerCase().contains(value.toString().toLowerCase())).toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage! ? _total : _currentPerPage!;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    /// set headers
    _headers = [
      DatatableHeader(text: "Sr No.", value: "ShowID", flex: 1, show: true, sortable: true, textAlign: TextAlign.center),
      DatatableHeader(
          text: widget.width < 800?"Name": "Student Name",
          value: "name",
          show: true,
          flex: 1,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: widget.width < 800?"Div":"Division",
          value: "student_current_divison",
          show: true,
          flex: 2,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: widget.width < 800?"Ph.":"Contact Number",
          value: "student_fathers_ph_no",
          show: true,
          flex: 2,
          sortable: true,
          sourceBuilder: (v, r) {
            List<Widget> _divList = [];
            Widget finaldivWig = Column(
              children: _divList,
            );

            _divList.add(Center(
              child: Column(
                children: [
                  Center(child: Text(r["student_fathers_ph_no"] == null ? "-" : r["student_fathers_ph_no"].toString())),
                  Center(child: Text(r["student_mothers_ph_no"] == null ? "-" : r["student_mothers_ph_no"].toString())),
                  Center(child: Text(r["student_guardians_ph_no"] == null ? "-" : r["student_guardians_ph_no"].toString())),
                  // Divider(),
                ],
              ),
            ));

            return finaldivWig;
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: widget.width < 800?"In Sch.":"In School Status",
          value: "student_InSchool",
          show: true,
          flex: 1,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text:widget.width < 800?"Enable": "Enable Status",
          value: "student_enable_status",
          show: true,
          flex: 1,
          sortable: true,
          textAlign: TextAlign.center),


      DatatableHeader(text: "Updated By", value: "updated_by", flex: 1, show: true, sortable: true, textAlign: TextAlign.center),
      DatatableHeader(text: "Updated", value: "date_time", flex: 1, show: true, sortable: true, textAlign: TextAlign.center),
    ];

    _initializeData();
  }
  final ScrollController _controllerOne = ScrollController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
  }
  @override


  @override


  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _controllerOne,
        child: SingleChildScrollView(
          controller: _controllerOne,
          scrollDirection: Axis.horizontal,
          child: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(0),
                    height: widget.height,
                    // constraints: const BoxConstraints(
                    //   maxHeight:  ,
                    // ),
                    child: Card(
                      elevation: 1,
                      shadowColor: Colors.black,
                      clipBehavior: Clip.none,
                      child: Container(
                        width:widget.width < 800?800: widget.width ,
                        child: ResponsiveDatatable(
                          title: TextButton.icon(
                            onPressed: () {
                              _initializeData();
                            },
                            icon: Icon(Icons.refresh),
                            label: Text("Refresh"),
                          ),
                          commonMobileView: true,
                          reponseScreenSizes: [ScreenSize.xs],
                          actions: [
                            if (_isSearch)
                              Expanded(
                                  child: TextField(
                                decoration: InputDecoration(
                                    hintText: 'Enter search term based on ' + _searchKey!.replaceAll(new RegExp('[\\W_]+'), ' ').toUpperCase(),
                                    prefixIcon: IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: () {
                                          setState(() {
                                            _isSearch = false;
                                          });
                                          _initializeData();
                                        }),
                                    suffixIcon: IconButton(icon: Icon(Icons.search), onPressed: () {})),
                                onSubmitted: (value) {
                                  _filterData(value);
                                },
                              )),
                            if (!_isSearch)
                              IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      _isSearch = true;
                                    });
                                  })
                          ],
                          headers: _headers,
                          source: _source,
                          // selecteds: _selecteds,
                          // showSelect: _showSelect,
                          autoHeight: false,
                          dropContainer: (data) {
                            // if (int.tryParse(data['id'].toString())!.isEven) {
                            //   return Text("is Even");
                            // }
                            return _DropDownContainer(data: data);
                          },
                          onChangedRow: (value, header) {
                            ///print(value);
                            /// print(header);
                          },
                          onSubmittedRow: (value, header) {
                            /// print(value);
                            /// print(header);
                          },
                          onTabRow: (data) {
                            // print(data);
                          },

                          onSort: (value) {
                            setState(() => _isLoading = true);

                            setState(() {
                              _sortColumn = value;
                              _sortAscending = !_sortAscending;
                              if (_sortAscending) {
                                _sourceFiltered.sort((a, b) => b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                              } else {
                                _sourceFiltered.sort((a, b) => a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                              }
                              var _rangeTop = _currentPerPage! < _sourceFiltered.length ? _currentPerPage! : _sourceFiltered.length;
                              _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                              _searchKey = value;

                              _isLoading = false;
                            });
                          },
                          expanded: _expanded,
                          sortAscending: _sortAscending,
                          sortColumn: _sortColumn,
                          isLoading: _isLoading,
                          onSelect: (value, item) {
                            // print("$value  $item ");
                            if (value!) {
                              setState(() => _selecteds.add(item));
                            } else {
                              setState(() => _selecteds.removeAt(_selecteds.indexOf(item)));
                            }
                          },
                          onSelectAll: (value) {
                            if (value!) {
                              setState(() => _selecteds = _source.map((entry) => entry).toList().cast());
                            } else {
                              setState(() => _selecteds.clear());
                            }
                          },
                          footers: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("Rows per page:"),
                            ),
                            if (_perPages.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: DropdownButton<int>(
                                  value: _currentPerPage,
                                  items: _perPages
                                      .map((e) => DropdownMenuItem<int>(
                                            child: Text("$e"),
                                            value: e,
                                          ))
                                      .toList(),
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      _currentPerPage = value;
                                      _currentPage = 1;
                                      _resetData();
                                    });
                                  },
                                  isExpanded: false,
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("$_currentPage - $_currentPerPage of $_total"),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: 16,
                              ),
                              onPressed: _currentPage == 1
                                  ? null
                                  : () {
                                      var _nextSet = _currentPage - _currentPerPage!;
                                      setState(() {
                                        _currentPage = _nextSet > 1 ? _nextSet : 1;
                                        _resetData(start: _currentPage - 1);
                                      });
                                    },
                              padding: EdgeInsets.symmetric(horizontal: 15),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios, size: 16),
                              onPressed: _currentPage + _currentPerPage! - 1 > _total
                                  ? null
                                  : () {
                                      var _nextSet = _currentPage + _currentPerPage!;

                                      setState(() {
                                        _currentPage = _nextSet < _total ? _nextSet : _total - _currentPerPage!;
                                        _resetData(start: _nextSet - 1);
                                      });
                                    },
                              padding: EdgeInsets.symmetric(horizontal: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _initializeData,
      //   child: Icon(Icons.refresh_sharp),
      // ),
    );
  }
}

class _DropDownContainer extends StatefulWidget {
  final Map<String, dynamic> data;

  const _DropDownContainer({Key? key, required this.data}) : super(key: key);

  @override
  State<_DropDownContainer> createState() => _DropDownContainerState();
}

class _DropDownContainerState extends State<_DropDownContainer> {
  @override
  Widget build(BuildContext context) {
    // widget.data.removeWhere((key, value) => key == '_id');
    // List<Widget> _children = widget.data.entries.map<Widget>((entry) {
    //   Widget w = Column(children: [
    //     Row(
    //       children: [
    //         Text(
    //             entry.key.toString() == "ShowID"
    //                 ? "Sr. No."
    //                 : entry.key.toString() == "year"
    //                     ? "Academic Year"
    //                     : entry.key.toString() == "date_time"
    //                         ? "Updated on"
    //                         : entry.key.toString() == "updated_by" ? "Updated By":"",
    //             style: TextStyle(fontWeight: FontWeight.bold)),
    //         Text(":---"),
    //         Text(entry.value.toString() ),
    //       ],
    //     )
    //   ]);
    //   return w;
    // }).toList();
    Widget _child = Column(
      children: [
        Row(
          children: [
            const Text("Sr.No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["ShowID"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Full Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("First Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["first_Name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Middle Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["middle_Name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Last Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["last_name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Gender :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_gender"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("UDISE ID :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_ID_UDISE"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Gr No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_GR_No"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Nationality :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_nationality"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Mother Tongue :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_mother_tongue"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Sibling :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Column(children: [
              if (widget.data["sibling"].isNotEmpty)
                for (int i = 0; i < widget.data["sibling"].length; i++) Text(widget.data["sibling"][i]["name"])
              else
                Text("   - ")
            ])
          ],
        ),
        Row(
          children: [
            const Text("Father's Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_fathers_name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Mother's Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_mothers_name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Guardian's Name :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_guardians_name"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Address :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_address"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Father's Ph. No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_fathers_ph_no"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Mother's Ph. No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_mothers_ph_no"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Guardian's Ph. No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_guardians_ph_no"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Aadhar Nummber :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_aadhar_no"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Religion :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_religion"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Caste :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_caste"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("SubCaste :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_subcaste"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("RTE :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_RTE"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Date Of Birth :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_date_of_birth"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Place Of Birth Village/City :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_place_of_birth_villagecity"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Place Of Birth Taluka :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_place_of_birth_taluka"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Place Of Birth District :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_place_of_birth_district"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Place Of Birth State :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_place_of_birth_state"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Place Of Birth Country :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_place_of_birth_country"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Current Division :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_current_divison"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("All Divisions :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            // Text(widget.data["student_divisions"].toString()),
            Column(children: [
              if (widget.data["student_divisions"].isNotEmpty)
                for (int i = 0; i < widget.data["student_divisions"].length; i++) Text(widget.data["student_divisions"][i]["division_name"])
              else
                Text("   - ")
            ])
          ],
        ),
        Row(
          children: [
            const Text("Different Abled :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_differently_abled_bool"].toString()),
          ],
        ),
        widget.data["student_differently_abled_bool"] == true
            ? Row(
                children: [
                  const Text("Different Abled Details :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  widget.data["student_differently_abled_bool"] == false ? Text("NA") : Text(widget.data["student_differently_abled"].toString()),
                ],
              )
            : Container(),
        Row(
          children: [
            const Text("Total Fees :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Null"),
          ],
        ),
        Row(
          children: [
            const Text("Pending Fees :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["Null"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Next Reminder :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["Null"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("In School Status :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_InSchool"] == true ? "Is Still a Student" : "Left School No More a Student"),
          ],
        ),
        widget.data["student_InSchool"] == false
            ? Row(
                children: [
                  const Text("Leaving Date :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.data["year"].toString()),
                ],
              )
            : Container(),
        widget.data["student_InSchool"] == false
            ? Row(
                children: [
                  const Text("Leaving from Division :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.data["year"].toString()),
                ],
              )
            : Container(),
        widget.data["student_InSchool"] == false
            ? Row(
                children: [
                  const Text("Reason For Leaving :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.data["year"].toString()),
                ],
              )
            : Container(),
        widget.data["student_InSchool"] == false
            ? Row(
                children: [
                  const Text("Student Progress :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.data["year"].toString()),
                ],
              )
            : Container(),
        widget.data["student_InSchool"] == false
            ? Row(
                children: [
                  const Text("Student Conduct :-----", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.data["year"].toString()),
                ],
              )
            : Container(),
        Row(
          children: [
            const Text("Date Of Admission :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_DateOfAdmission"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Admitted in Acad Yr :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_AdmittedinAcadYr"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Admitted in Standard :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_AdmittedtoStandard"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Admitted in Division :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_AdmittedtoDiv"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Last School Attended :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_LastSchoolAttended"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Last School Attended Standard :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_LastSchoolStandard"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Last School Attended UDISE No. :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_LastSchoolUdiseNo"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Enabled Status :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_enable_status"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Notification Status :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_notification_status"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Notification Profile :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_notification_profile"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Username :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_username"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Password :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["student_password"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Updated By :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["updated_by"].toString()),
          ],
        ),
        Row(
          children: [
            const Text("Updated On :-----", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.data["date_time"].toString()),
          ],
        )
      ],
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(//EDIT
                  onPressed: () async {
                    refreshStudentTable = false;
                //-----------------------------------------------------------------------------------------------
                    //--------- main ID ------------
                    edit_ID = widget.data["_id"];

                    studentFirstNameAdd = widget.data["first_Name"];
                    studentLastNameAdd = widget.data["last_name"];
                    gender = widget.data["student_gender"] == null ? "Male" : widget.data["student_gender"];
                    studentID = widget.data["student_ID_UDISE"];
                    grNumber = widget.data["student_GR_No"];
                    nationalityNameAdd = widget.data["student_nationality"];
                    motherTongueNameAdd = widget.data["student_mother_tongue"];
                    fathersNameAdd = widget.data["student_fathers_name"];
                    mothersNameAdd = widget.data["student_mothers_name"];
                    guardiansNameAdd = widget.data["student_guardians_name"];
                    addressNameAdd = widget.data["student_address"];
                    aadharNumberAdd = widget.data["student_aadhar_no"];
                    rTE = widget.data["student_RTE"];
                    placeOfBirthAddVillageorCity = widget.data["student_place_of_birth_villagecity"];
                    placeOfBirthAddTaluka = widget.data["student_place_of_birth_taluka"];
                    placeOfBirthAddDistrict = widget.data["student_place_of_birth_district"];
                    placeOfBirthAddState = widget.data["student_place_of_birth_state"];
                    placeOfBirthAddCountry = widget.data["student_place_of_birth_country"];
                    inSchool = widget.data["student_InSchool"];
                    reasonForLeavingAdd = widget.data["reason_for_leaving_school"];
                    progressAdd = widget.data["student_progress"];
                    conductAdd = widget.data["student_conduct"];
                    lastSchoolAttended = widget.data["student_LastSchoolAttended"];
                    lastSchoolStandardAttended = widget.data["student_LastSchoolStandard"];
                    uDISEpreviousSchool = widget.data["student_LastSchoolUdiseNo"];
                    enableStatus = widget.data["student_enable_status"];
                    initialValueUserName = widget.data["student_username"];
                    initialValuePassword = widget.data["student_password"];


                    //--------- Sibling ------------
                    if (widget.data["sibling"] != []) {
                      for (int i = 0; i < widget.data["sibling"].length; i++) {
                        siblingsList!.add(widget.data["sibling"][i]["name"]);
                      }
                    } else {
                      siblingsList = [];
                    }





                    //--------- Father Mother Guardian Ph no. ------------
                    fathersPhoneNoMain = widget.data["student_fathers_ph_no"].length > 10
                        ? widget.data["student_fathers_ph_no"]
                            .substring(widget.data["student_fathers_ph_no"].length - 10, widget.data["student_fathers_ph_no"].length)
                        : null;
                    fathersPhoneNoEXT = widget.data["student_fathers_ph_no"].length > 10
                        ? widget.data["student_fathers_ph_no"].substring(0, widget.data["student_fathers_ph_no"].length - 10)
                        : "+91";
                    mothersPhoneNoMain = widget.data["student_mothers_ph_no"].length > 10
                        ? widget.data["student_mothers_ph_no"]
                            .substring(widget.data["student_mothers_ph_no"].length - 10, widget.data["student_mothers_ph_no"].length)
                        : null;
                    mothersPhoneNoEXT = widget.data["student_mothers_ph_no"].length > 10
                        ? widget.data["student_mothers_ph_no"].substring(0, widget.data["student_mothers_ph_no"].length - 10)
                        : "+91";
                    guardiansPhoneNoMain = widget.data["student_guardians_ph_no"].length > 10
                        ? widget.data["student_guardians_ph_no"]
                            .substring(widget.data["student_guardians_ph_no"].length - 10, widget.data["student_guardians_ph_no"].length)
                        : null;
                    guardiansPhoneNoEXT = widget.data["student_guardians_ph_no"].length > 10
                        ? widget.data["student_guardians_ph_no"].substring(0, widget.data["student_guardians_ph_no"].length - 10)
                        : "+91";



                    //--------- Religion Cast SubCaste ------------
                    religionAdd.clear();
                    if (widget.data["student_religion"] != null) {
                      religionAdd.add(widget.data["student_religion"]);
                    }

                    casteListAdd.clear();
                    if (widget.data["student_caste"] != null) {
                      casteListAdd.add(widget.data["student_caste"]);
                    }

                    subcasteListAdd.clear();
                    if (widget.data["student_subcaste"] != null) {
                      subcasteListAdd.add(widget.data["student_subcaste"]);
                    }


                    //--------- Date Of Birth ------------
                    selectedDateofBirth.clear();
                    List<String> dateofBirthDividedList = widget.data["student_date_of_birth"].split("/");
                    selectedDateofBirth.add(DateTime.parse(
                        '${dateofBirthDividedList[2]}-${dateofBirthDividedList[1].length < 2 ? '0' + dateofBirthDividedList[1] : dateofBirthDividedList[1]}-${dateofBirthDividedList[0].length < 2 ? '0' + dateofBirthDividedList[0] : dateofBirthDividedList[0]} 00:00:00.000'));


                    //--------- Date Of Leaving ------------
                    if(widget.data["student_Leaving_Date"] != null) {
                      selectedSchoolLeavingDate.clear();
                      List<String> selectedSchoolLeavingDateList = widget.data["student_Leaving_Date"].split("/");
                      selectedSchoolLeavingDate.add(DateTime.parse(
                          "${selectedSchoolLeavingDateList[2]}-${selectedSchoolLeavingDateList[1].length < 2
                              ? '0' + selectedSchoolLeavingDateList[1]
                              : selectedSchoolLeavingDateList[1]}-${selectedSchoolLeavingDateList[0].length < 2 ? '0' +
                              selectedSchoolLeavingDateList[0] : selectedSchoolLeavingDateList[0]} 00:00:00.000"));
                    }
                    else{
                      selectedSchoolLeavingDate.clear();
                      selectedSchoolLeavingDate.add(DateTime.now());
                    }


                    //--------- Date Of Admission ------------

                    if(widget.data["student_DateOfAdmission"] != null){
                      selectedDateofAdmission.clear();
                      List<String> selectedDateofAdmissionList = widget.data["student_DateOfAdmission"].split("/");
                      selectedDateofAdmission.add(DateTime.parse(
                          "${selectedDateofAdmissionList[2]}-${selectedDateofAdmissionList[1].length < 2
                              ? '0' + selectedDateofAdmissionList[1]
                              : selectedDateofAdmissionList[1]}-${selectedDateofAdmissionList[0].length < 2 ? '0' +
                              selectedDateofAdmissionList[0] : selectedDateofAdmissionList[0]} 00:00:00.000"));
                    }else{
                      selectedDateofAdmission.clear();
                      selectedDateofAdmission.add(DateTime.now());
                    }







                    //--------- Differently Abled ------------
                    differentlyAbledBool = widget.data["student_differently_abled_bool"];
                    if (widget.data["student_differently_abled"] != null) {
                      differentlyAbledListAdd.add(widget.data["student_differently_abled"]);
                    }






                    //--------- Division ------------
                    if(widget.data["student_divisions"] != null ){
                      divList!.clear();
                      for(var i in widget.data["student_divisions"]){
                        divList!.add(i["division_name"]);
                      }
                      divData = await getDatadivisionDataDetials(divList) as List;
                      acadYearNClassAdd = await funcGetClassAndAcadYrFromDiv();
                      if (acadYearNClassAdd != null) {
                        divList!.forEach((element) {
                          if (element.contains(acadYearNClassAdd![1]["currentClass"]) &&
                              element.contains(
                                  "${acadYearNClassAdd![0][acadYearNClassAdd![0].lastKey()]}-${acadYearNClassAdd![0][acadYearNClassAdd![0].lastKey()] + 1}")) {
                            currentDivision = element;
                          }
                        });
                      }

                    }else{
                      divList!.clear();
                    }

                    if(divList!.isNotEmpty) {
                      for (var e in divList!) {
                        if (e.contains(firstAcadYrInSystem)) {
                          setState(() {
                            firstAcadYrISSelected = true;
                            firstNlastClassDetials = funcGetAdmittedClassAnddiv();
                            firstAcadYr = firstNlastClassDetials[2].substring(1, 10);
                            firstClass = firstNlastClassDetials[1];
                            firstDiv = firstNlastClassDetials[0];

                            lastAcadYr = firstNlastClassDetials[5].substring(1, 10);
                            lastClass = firstNlastClassDetials[4];
                            lastDiv = firstNlastClassDetials[3];

                            newAdmissioninFirstAcadYrinsystem = widget.data["student_AdmittedinAcadYr"] != null ? widget.data["student_AdmittedinAcadYr"] == firstAcadYrInSystem? true:false:false;
                          });
                        }
                      }
                    }



                    // edit_student_AdmittedtoStandard = widget.data["student_AdmittedtoStandard"];
                    // edit_div_from_which_student_left = widget.data["div_from_which_student_left"];
                    // edit_student_notification_status = widget.data["student_notification_status"];
                    // edit_student_notification_profile = widget.data["student_notification_profile"];

//-----------------------------------------------------------------------------------------------

                    setState(() {
                      showEditStudentDetials = true;
                      Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                      // print(showEditStudentDetials);
                    });
                  },
                  child: Text("Edit"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(editButtonAll)),
                ),//EDIT
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(//DELETE
                  onPressed: () async {
                    refreshStudentTable = false;
                    delete_ID = widget.data["_id"];
                    studentFirstNameAdd = widget.data["first_Name"];
                    studentLastNameAdd = widget.data["last_name"];
                    fathersNameAdd = widget.data["student_fathers_name"];

                    setState(() {
                      showDeleteStudentPage = true;
                      Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                    });
                  },
                  child: const Text("Delete"),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(deleteButtonAll)),
                )//DELETE
              ],
            ),
          ),
          Container(

              /// height: 100,
              child: _child
              // Column(
              /// children: [
              ///   Expanded(
              ///       child: Container(
              ///     color: Colors.red,
              ///     height: 50,
              ///   )),

              /// ],
              // children: _children,
              // ),
              ),
        ],
      ),
    );
  }
}
