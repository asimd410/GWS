import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/screens/classList/divisionCreateView.dart';
import 'package:responsive_table/responsive_table.dart';
import 'dart:math';
import 'dart:convert';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:provider/provider.dart';

class DataPageDivision extends StatefulWidget {
  double width;

  DataPageDivision({required this.width});
  @override
  _DataPageDivisionState createState() => _DataPageDivisionState();
}

class _DataPageDivisionState extends State<DataPageDivision> {
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
    showDivision_responseBodyJSON = await httpPost(
      msgToSend: {"msg":"viewDivisionInDB"},
      destinationPort:8080 ,
      destinationPost: "/addDivision/viewDivisionInDB",
      destinationUrl:mainDomain,
    );
    // print("showDivision_responseBodyJSON  = ${showDivision_responseBodyJSON}");
    var showDivision_responseBody = json.decode(showDivision_responseBodyJSON!);
    // print("showDivision_responseBody.runtimeType = ${showDivision_responseBody.runtimeType}");

    List<Map<String,dynamic>> showDivision_responseBodyTemp = [];
    showDivision_responseBody.forEach((e){ showDivision_responseBodyTemp.add(e);});
    for(int i =  0 ; i <  showDivision_responseBodyTemp.length; i++){
      showDivision_responseBodyTemp[i]["ShowID"] = i+1;
      showDivision_responseBodyTemp[i].remove("__v") ;



    }
    _expanded = List.generate(_currentPerPage!, (index) => false);
    setState(() {

      if(showDivision_responseBodyTemp.length <= 10){
        _perPages = [showDivision_responseBodyTemp.length];
        _currentPerPage = showDivision_responseBodyTemp.length;
      }else if(showDivision_responseBodyTemp.length > 10 && showDivision_responseBodyTemp.length < 20){
        _perPages = [10,showDivision_responseBodyTemp.length];
        _currentPerPage = 10;
      }else if(showDivision_responseBodyTemp.length >= 20 && showDivision_responseBodyTemp.length < 50){
        _perPages = [10,20,showDivision_responseBodyTemp.length];
        _currentPerPage = 10;
      }else if(showDivision_responseBodyTemp.length >= 50 && showDivision_responseBodyTemp.length < 100){
        _perPages = [10,20,50,showDivision_responseBodyTemp.length];
        _currentPerPage = 10;
      }

    });
    // _currentPerPage = 10;

    // _currentPerPage =  showClass_responseBodyTemp.length;



    setState(() => _isLoading = true);

    Future.delayed(Duration(seconds: 3)).then((value) {
      _expanded = List.generate(_currentPerPage!, (index) => false);
      _sourceOriginal.clear();
      _sourceOriginal.addAll(showDivision_responseBodyTemp
      );
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered.getRange(0, _currentPerPage!).toList();
      setState(() => _isLoading = false);
    });
  }

  _resetData({start: 0}) async {
    setState(() => _isLoading = true);
    var _expandedLen =
    _total - start < _currentPerPage! ? _total - start : _currentPerPage;
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
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey!]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
            .toList();
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
      DatatableHeader(
          text: "Sr. No.",
          value: "ShowID",
          flex: 1,
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Division Name",
          value: "division_name",
          show: true,
          flex: 1,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Academic Yr",
          value: "academic_year",
          show: true,
          flex: 1,
          sortable: true,
          sourceBuilder: (v,r){
            return Center(child: Text(v["year"].toString()));
          },
          textAlign: TextAlign.center),

       DatatableHeader(
          text: "Class",
          value: "std",
          show: true,
          flex: 1,
          sortable: true,
           sourceBuilder: (v,r){
             return Center(child: Text(v["standard_name"].toString()));
           },
          textAlign: TextAlign.center),
       DatatableHeader(
          text: "Subjects",
          value: "subjects",
          show: true,
          flex: 1,
          sortable: true,
           sourceBuilder: (v,r){
             if(v.length > 1){
             List<Widget> subjectNamesWig = [];
            Widget columoofSubjects = Column(children: subjectNamesWig,);

              for(var i in v){
                subjectNamesWig.add(Text(i["subject_name"].toString()));
              };
             return columoofSubjects;
            }
             else{ return Text("-");}
           },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Admission Fee",
          value: "fees",
          show: true,
          flex: 1,
          sortable: true,
          sourceBuilder: (v,r){
            return Center(child: Text((v["admission_fees"]??"-").toString()));
          },
          textAlign: TextAlign.center),
       DatatableHeader(
          text: "Main Fees",
          value: "fees",
          show: true,
          flex: 1,
          sortable: true,
          sourceBuilder: (v,r){

            String mainFeeTitle = v["main_fees"][0]["fee_title"].toString();
            String mainFeeAmount = v["main_fees"][0]["total_fees"].toString();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("₹${mainFeeAmount.toString()}"),
              ],
            );
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Extra Fees",
          value: "fees",
          show: true,
          flex: 1,
          sortable: true,
          sourceBuilder: (v,r){

            List<Widget> extraFeeList = [];
            Widget extraFeeWig = Column(children: extraFeeList,);

            if(v["extra_fee"].isNotEmpty){
              for(var i in v["extra_fee"]){
                extraFeeList.add(Center(
                  child: Column(
                    children: [
                      Center(child: Text(i["extra_fee_title"] == null ? "-":i["extra_fee_title"].toString())),
                      Center(child: Text(i["extra_total_fee"] == null ? "-":i["extra_total_fee"].toString())),
                      Divider(),
                    ],
                  ),
                ));
              }
              return extraFeeWig;
            }
            else{return Center(child: Text("-"));}
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Updated By",
          value: "updated_by",
          flex: 1,
          show: true,
          sortable: true,
          sourceBuilder: (v,r){
            return Center(child: Text((v??"-").toString()));
          },
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Updated",
          value: "date_time",
          flex: 1,
          show: true,
          sortable: true,
          sourceBuilder: (v,r){
            return Center(child: Text((v??"-").toString()));
          },
          textAlign: TextAlign.center),
    ];

    _initializeData();
  }
  final ScrollController _controllerOne = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _controllerOne.dispose();
  }

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
                        constraints: BoxConstraints(
                          maxHeight: 680  ,
                        ),
                        child: Card(
                          elevation: 1,
                          shadowColor: Colors.black,
                          clipBehavior: Clip.none,
                          child: Container(
                            width: widget.width,
                            child: ResponsiveDatatable(
                              title: TextButton.icon(
                                onPressed: _initializeData,
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
                                            hintText: 'Enter search term based on ' +
                                                _searchKey!
                                                    .replaceAll(new RegExp('[\\W_]+'), ' ')
                                                    .toUpperCase(),
                                            prefixIcon: IconButton(
                                                icon: Icon(Icons.cancel),
                                                onPressed: () {
                                                  setState(() {
                                                    _isSearch = false;
                                                  });
                                                  _initializeData();
                                                }),
                                            suffixIcon: IconButton(
                                                icon: Icon(Icons.search), onPressed: () {})),
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
                                print(data);
                              },
                              onSort: (value) {
                                setState(() => _isLoading = true);

                                setState(() {
                                  _sortColumn = value;
                                  _sortAscending = !_sortAscending;
                                  if (_sortAscending) {
                                    _sourceFiltered.sort((a, b) =>
                                        b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                                  } else {
                                    _sourceFiltered.sort((a, b) =>
                                        a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                                  }
                                  var _rangeTop = _currentPerPage! < _sourceFiltered.length
                                      ? _currentPerPage!
                                      : _sourceFiltered.length;
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
                                print("$value  $item ");
                                if (value!) {
                                  setState(() => _selecteds.add(item));
                                } else {
                                  setState(
                                          () => _selecteds.removeAt(_selecteds.indexOf(item)));
                                }
                              },
                              onSelectAll: (value) {
                                if (value!) {
                                  setState(() => _selecteds =
                                      _source.map((entry) => entry).toList().cast());
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
                                  child:
                                  Text("$_currentPage - $_currentPerPage of $_total"),
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
                                      _currentPage = _nextSet < _total
                                          ? _nextSet
                                          : _total - _currentPerPage!;
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
  List<Widget> funcgetSubOfFees(mORe){
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^widget.data^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ = ${widget.data}"
        'widget.data["fees"][mORe][0]["sf"] = ${widget.data["fees"][mORe][0]["sub_of_fees"]}');
   List<dynamic> listofSubs = widget.data["fees"][mORe][0]["sub_of_fees"];
   List<Widget> listofSubsWigs = [];
   int j = 1;
   for(var i in listofSubs){
     Widget _tempSubWig = Column(children: [
       Row(
         children: [
           Text("Sub Fee Title $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["sub_fees_title"].toString()),
         ],
       ),Row(
         children: [
           Text("Sub Fee Amount $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["sub_amount"].toString()),
         ],
       ),Row(
         children: [
           Text("Sub Fee Priority $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["fee_priority"].toString()),
         ],
       ),
       Divider(),
     ],);

     listofSubsWigs.add(_tempSubWig);
     j++;
   }
   return listofSubsWigs;
  }

  List<Widget> funcgetSubOfFeesExtra(mORe){
    print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^widget.data^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ = ${widget.data}"
        'mORe["extra_sub_of_fees"] = ${mORe["extra_sub_of_fees"]}');
    List<dynamic> listofSubs = mORe["extra_sub_of_fees"];
    List<Widget> listofSubsWigs = [];
    int j = 1;
    for(var i in listofSubs){
      Widget _tempSubWig = Container(width:300, child:Column(children: [
        Row(
          children: [
            Text("Sub Fee Title $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["extra_sub_fees_title"].toString()),
          ],
        ),
        Row(
          children: [
            Text("Sub Fee Amount $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["extra_sub_amount"].toString()),
          ],
        ),Row(
          children: [
            Text("Sub Fee Priority $j :-----", style:const TextStyle(fontWeight: FontWeight.bold)),Text(i["extra_fee_priority"].toString()),
          ],
        ),
        const Divider(),
      ],));

      listofSubsWigs.add(_tempSubWig);
      j++;
    }
    return listofSubsWigs;
  }





  List<Widget> funcgetSubFeeExtra(e){
    List<dynamic> listofExtrasData = widget.data["fees"][e];
    List<Widget> listofExtrasWig = [];
    int j = 0;
    for(var i in listofExtrasData){
      Widget _tempExtraWig =  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width:300,
          child: Column(children: [
            Row(
              children: [
                Text("Extra Fee Title $j :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(i["extra_fee_title"].toString()),
              ],
            ),Row(
              children: [
                Text("Extra Fee Amount $j :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(i["extra_total_fee"].toString()),
              ],
            ),Divider(),
            Container(
              width: 300,
                child: Column(
                  children: funcgetSubOfFeesExtra(i),
                )
            ),
          ],),
        ),
      );
      j++;
      listofExtrasWig.add(_tempExtraWig);
    }
    return listofExtrasWig;
  }
  late final ScrollController _controllerTwo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerTwo = ScrollController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerTwo.dispose();
  }
  @override
  Widget build(BuildContext context) {

    Widget _child = Column(children: [
      Row(
        children: [
          const Text("Sr.No. :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["ShowID"].toString()),
        ],
      ),Row(
        children: [
          const Text("Division Name :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["division_name"].toString()),
        ],
      ),Row(
        children: [
          const Text("Academic Year :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["academic_year"]["year"].toString()),
        ],
      ),Row(
        children: [
          const Text("Class :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["std"]["standard_name"].toString()),
        ],
      ),Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Subjects :-----", style:TextStyle(fontWeight: FontWeight.bold)),funcGetSubjectList((widget.data["subjects"])),
        ],
      ),Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Admission Fees :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text((widget.data["fees"]["admission_fees"] ?? 0).toString()),
        ],
      ),
     Scrollbar(
       isAlwaysShown: true,
       controller: _controllerTwo,
       child: SingleChildScrollView(
         controller: _controllerTwo ,
         scrollDirection: Axis.horizontal,
         child: Row(children: [
           //-------------------------------Main Fee---------------------------------
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               width:300,
               child: Column(children: [
                 Row(
                   children: [
                       const Text("Main Fee Title :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["fees"]["main_fees"][0]["fee_title"].toString()),
                   ],
                 ),Row(
                   children: [
                     const Text("Main Fee Amount :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["fees"]["main_fees"][0]["total_fees"].toString()),
                   ],
                 ),
                 Divider(),
                 Padding(
                   padding: const EdgeInsets.only(top: 8.0, bottom:8, right:8),
                   child: Container(
                     width:300,
                     child: Container(
                      child: Column(
                        children: funcgetSubOfFees("main_fees"),
                      )
                     ),
                   ),
                 ),
               ],),
             ),
           ),
           //-------------------------------Extra Fee---------------------------------
           Column(children: [Row(children: funcgetSubFeeExtra("extra_fee"),)],)
         ],),
       ),
     ),




      Row(
        children: [
          const Text("Updated By :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text((widget.data["updated_by"]??" - ").toString()),
        ],
      ),Row(
        children: [
          const Text("Updated On :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text((widget.data["date_time"] ?? " - ").toString()),
        ],
      )
    ],);
    print('funcgetSubFeeExtra("extra_fee") = ${funcgetSubFeeExtra("extra_fee")}');
    double widthofFEEs = funcgetSubFeeExtra("extra_fee").isEmpty ? 301:600;
    print(widthofFEEs);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: widthofFEEs,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      editIdToEdit = widget.data["_id"].toString();
                      editDivNameToEdit = widget.data["division_name"].toString();
                      editDivAcadYrToEdit = widget.data["academic_year"]["year"].toString();
                      editDivClassToEdit = widget.data["std"]["standard_name"].toString();
                      editAdmissionFeesToEdit = (widget.data["fees"]["admission_fees"]??0).toString();
                      List<String>_tempListofSubj = [];
                      editListofMainFeeSubsToEdit.clear();
                      widget.data["subjects"].forEach((e){
                        print('e["subject_name"] = ${e["subject_name"]}');
                        _tempListofSubj.add(e["subject_name"]);
                      });
                      editDivSubjectsToEdit =_tempListofSubj;

                      listOfMainFeesEDIT.clear();
                      widget.data["fees"]["main_fees"].forEach((e){
                        editDivMainFee_idToEdit = e["_id"].toString();
                        editDivMainFeeTitleToEdit = e["fee_title"];
                        editDivMainFeeAmountToEdit = e["total_fees"].toString();
                        listOfMainFeesEDIT.add(editDivMainFeeTitleToEdit);
                        listOfMainFeesEDIT.add(editDivMainFeeAmountToEdit.toString());
                        listOfMainFeesEDIT.add(editDivMainFee_idToEdit);
                        e["sub_of_fees"].forEach((b){
                          List<dynamic> _sub_fees = [
                            b["sub_fees_title"] ,
                            b["sub_amount"].toString(),
                            b["fee_priority"],
                            b["_id"].toString(),
                          ];
                          // editListofMainFeeSubsToEdit.add(_sub_fees);
                          listOfMainFeesEDIT.add(_sub_fees);
                        });
                      });


                      listOfMainFees.clear();
                      listOfMainFees.add(listOfMainFeesEDIT);


                      //---------- Extra Fee EDIT ---------------
                      print("^^^^^^^^^^^^^^^^^ widget.data =  ${widget.data}");
                      editListofExtraFeesToEdit.clear();
                      listOfExtraFees.clear();
                      widget.data["fees"]["extra_fee"].forEach((e){
                        List<dynamic>_tempExtraFee = [];
                        List<dynamic>_tempExtraFeeSubs = [];

                        _tempExtraFee.add(e["extra_fee_title"]);
                        _tempExtraFee.add(e["extra_total_fee"].toString());
                        _tempExtraFee.add(e["_id"].toString());
                        e["extra_sub_of_fees"].forEach((b){
                        List<dynamic> _sub_fees = [
                           b["extra_sub_fees_title"] ,
                           b["extra_sub_amount"].toString(),
                           b["extra_fee_priority"].toString(),
                           b["_id"].toString(),
                          ];
                          _tempExtraFeeSubs.add(_sub_fees);
                        });
                        _tempExtraFeeSubs.forEach((element) {_tempExtraFee.add(element); });


                        editListofExtraFeesToEdit.add(_tempExtraFee);
                      });
                      editListofExtraFeesToEdit.forEach((element) {
                        listOfExtraFees.add(element); });

                      print("editListofExtraFees = $editListofExtraFeesToEdit");

                      setState(() {
                        showEditDivision = true;
                        Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                      });
                    },
                    child: Text("Edit"),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(editButtonAll)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // print("can Delete");
                      deleteDivision_id = widget.data["_id"];
                      // print("widget.data['_id'] = ${widget.data["_id"]}");
                      deleteDivisionName = widget.data["division_name"];
                      setState(() {
                        delDivision = true;
                        Provider.of<Data>(context, listen: false).refPageEditDivision(true);
                      });
                    },
                    child: const Text("Delete"),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(deleteButtonAll)),
                  )
                ],
              ),
            ),
            Container(
                child: _child
            ),
          ],
        ),
      ),
    );
  }
}










