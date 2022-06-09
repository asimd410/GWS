import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:provider/provider.dart';

import 'StudentsMain.dart';

String? studentNameFilteredSearch;
String? acadYrFilteredSearch;
String? classFilteredSearch;
String? divisionFilteredSearch;
String? enabledStatusFilteredSearch;

class FilteredPanelDesktop extends StatefulWidget {
  FilteredPanelDesktop({required this.screenW});

  double screenW;

  @override
  State<FilteredPanelDesktop> createState() => _FilteredPanelDesktopState();
}

class _FilteredPanelDesktopState extends State<FilteredPanelDesktop> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: expansionPanelMainBodyColor,
        child: Column(
          children: [
            Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      showClearButton: true,
                      enabled: functoenableStudentNamefilteredSearch(),
                      dialogMaxWidth: 300,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Student Name",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        setState(() {
                          studentNameFilteredSearch = data;
                        });
                      },
                      onFind: (filter) => getDataUniversalForStudent(filter: filter, postlink: "stdentsGetData", keytosend: "student_name"),
                    ),
                  ),
                ), //NAME
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: studentNameFilteredSearch == null ? true : false,
                      dialogMaxWidth: 300,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Academic Year",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        setState(() {
                          acadYrFilteredSearch = data;
                          functoenableStudentNamefilteredSearch();
                        });
                      },
                      onFind: (filter) => getDataUniversalForStudent(filter: filter, postlink: "AcademicYr", keytosend: "acadYr"),
                    ),
                  ),
                ), //ACAD YR
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: studentNameFilteredSearch == null ? true : false,
                      dialogMaxWidth: 300,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Class",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        setState(() {
                          classFilteredSearch = data;
                          functoenableStudentNamefilteredSearch();
                        });
                      },
                      onFind: (filter) => getDataUniversalForStudent(filter: filter, postlink: "studentClass", keytosend: "studentClass"),
                    ),
                  ),
                ), //CLASS
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: studentNameFilteredSearch == null ? true : false,
                      dialogMaxWidth: 300,
                      // maxHeight: 300,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Division",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        setState(() {
                          divisionFilteredSearch = data;
                          print("divisionFilteredSearch = $divisionFilteredSearch");
                          functoenableStudentNamefilteredSearch();
                        });
                      },
                      onFind: (filter) => funcGetSortedDivs(filter),
                    ),
                  ),
                ), //DIVISION
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: studentNameFilteredSearch == null ? true : false,
                      dialogMaxWidth: 300,
                      maxHeight: 300,
                      items: const ["Enabled", "Disabled"],
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Enable Status",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        setState(() {
                          enabledStatusFilteredSearch = data;
                          functoenableStudentNamefilteredSearch();
                        });
                      },
                    ),
                  ),
                ), //ENABLE STATUSa
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: false,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Notification Status",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        print("data  = $data");
                      },
                      onFind: (filter) => getDataUniversalForStudent(filter: filter, postlink: "studentClass", keytosend: "studentClass"),
                    ),
                  ),
                ), //NOTIFICATION STATUS
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 250,
                    height: 75,
                    child: DropdownSearch<String>(
                      showClearButton: true,
                      clearButtonBuilder: (_) =>Text("   Clear", style:TextStyle(color: Theme.of(context).primaryColor)),
                      enabled: false,
                      dropdownSearchDecoration: const InputDecoration(
                        labelText: "Notification Profile",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) {
                        print("data  = $data");
                      },
                      onFind: (filter) => getDataUniversalForStudent(filter: filter, postlink: "studentClass", keytosend: "studentClass"),
                    ),
                  ),
                ), //NOTIFICATION PROFILE
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () async{
                        showStudentFilteredSearch_responseBodyJSON= await httpPost(
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
                        refreshStudentTable = false;
                        Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            refreshStudentTable = true;
                            Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);
                            // Here you can write your code for open new view
                          });
                        });
                        },
                      child: Text("Search"))),
            )
          ],
        ));
  }
}

//
// Future<List<String>> getDataStudentName(filter) async {
//   getdataStudentsNames_responseBodyJSON = await  httpPost(
//       destinationUrl: mainDomain, destinationPort: 8080, destinationPost: "/addStudent/stdentsGetData", msgToSend:{"student_name":filter});
//   var getdataStudentsNames_responseBody= await json.decode(await getdataStudentsNames_responseBodyJSON!);
//   print(await getdataStudentsNames_responseBody["msg"][1]);
//   List<String> toStringList =[];
//    await getdataStudentsNames_responseBody["msg"].forEach((v){
//     toStringList.add(v.toString());
//   });
// return await toStringList;
// }
