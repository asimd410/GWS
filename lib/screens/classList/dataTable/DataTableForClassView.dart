import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/responsive_table.dart';
import 'dart:math';
import 'dart:convert';
import 'package:gws/functionAndVariables/funcCust.dart';


class DataPageClassView extends StatefulWidget {
  double width;

  DataPageClassView({required this.width});
  @override
  _DataPageClassViewState createState() => _DataPageClassViewState();
}

class _DataPageClassViewState extends State<DataPageClassView> {
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

  // List<Map<String, dynamic>> _generateData({int n: 100}) {
  //   final List source = List.filled(n, Random.secure());
  //   List<Map<String, dynamic>> temps = [];
  //   var i = 1;
  //   print(i);
  //   // ignore: unused_local_variable
  //   for (var data in source) {
  //     temps.add({
  //       "id": "_id",
  //       "standard_name": "standard_name",
  //       "date_time":"date_time"
  //     });
  //     i++;
  //   }
  //   return temps;
  // }


  _initializeData() async {
    _mockPullData();
  }

  _mockPullData() async {
    showClass_responseBodyJSON = await httpPost(
      msgToSend: {"msg":"viewClassesinDB"},
      destinationPort:8080 ,
      destinationPost: "/addClass/viewClassesinDB",
      destinationUrl:mainDomain,
    );
    var showClass_responseBody = await json.decode(showClass_responseBodyJSON!);
    print("showClass_responseBody.runtimeType = ${showClass_responseBody.runtimeType}");
    print("showClass_responseBody = ${showClass_responseBody[0]["_id"]}");
    List<Map<String,dynamic>> showClass_responseBodyTemp = [];
    await showClass_responseBody.forEach((e){showClass_responseBodyTemp.add(e);});
    for(int i =  0 ; i < showClass_responseBodyTemp.length; i++){
      showClass_responseBodyTemp[i]["ShowID"] = i+1;
      showClass_responseBodyTemp[i].remove("__v") ;
      // showClass_responseBodyTemp[i]["Updated By"] = userName ;
    }
    _expanded = List.generate(_currentPerPage!, (index) => false);
    setState(() {

      if(showClass_responseBodyTemp.length <= 10){
        _perPages = [showClass_responseBodyTemp.length];
        _currentPerPage = showClass_responseBodyTemp.length;
      }else if(showClass_responseBodyTemp.length > 10 && showClass_responseBodyTemp.length < 20){
        _perPages = [10,showClass_responseBodyTemp.length];
        _currentPerPage = 10;
      }else if(showClass_responseBodyTemp.length >= 20 && showClass_responseBodyTemp.length < 50){
        _perPages = [10,20,showClass_responseBodyTemp.length];
        _currentPerPage = 10;
      }else if(showClass_responseBodyTemp.length >= 50 && showClass_responseBodyTemp.length < 100){
        _perPages = [10,20,50,showClass_responseBodyTemp.length];
        _currentPerPage = 10;
      }

    });
    // _currentPerPage = 10;

    // _currentPerPage =  showClass_responseBodyTemp.length;



    setState(() => _isLoading = true);

    Future.delayed(Duration(seconds: 3)).then((value) {
      _expanded = List.generate(_currentPerPage!, (index) => false);
      _sourceOriginal.clear();
      _sourceOriginal.addAll(showClass_responseBodyTemp
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
          text: "ID",
          value: "ShowID",
          flex: 2,
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Class Name",
          value: "standard_name",
          show: true,
          flex: 1,
          sortable: true,
          // editable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Updated By",
          value: "Updated By",
          flex: 2,
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
      DatatableHeader(
          text: "Updated",
          value: "date_time",
          flex: 2,
          show: true,
          sortable: true,
          textAlign: TextAlign.center),
    ];

    _initializeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  final ScrollController _controllerOne = ScrollController();


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
                          maxHeight: 380  ,
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
                                  icon: const Icon(
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
    Widget _child = Column(children: [
      Row(
        children: [
          const Text("Sr.No. :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["ShowID"].toString()),
        ],
      ),Row(
        children: [
          const Text("Class :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["standard_name"].toString()),
        ],
      ),Row(
        children: [
          const Text("Updated By :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["updated_by"].toString()),
        ],
      ),Row(
        children: [
          const Text("Updated On :-----", style:TextStyle(fontWeight: FontWeight.bold)),Text(widget.data["date_time"].toString()),
        ],
      )
    ],);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    editClassToEdit = widget.data["standard_name"];
                    setState(() {
                      showEditClass = true;
                      Provider.of<Data>(context, listen: false).refPageEditClass(true);
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
                    print("can Delete");
                    deleteClass_id = widget.data["_id"];
                    deleteClass = widget.data["standard_name"];
                    setState(() {
                      delClass = true;
                      Provider.of<Data>(context, listen: false).refPageEditClass(true);
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
    );
  }
}
