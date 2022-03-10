import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
String? abc;
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
        height: 100,
        width: widget.screenW - screenWMinus,
        color: expansionPanelMainBodyColor,
        child: Wrap(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Student Name",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Academic Year",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Class",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Division",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Enable Status",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Notification Status",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(width:250,height:50,
              child: DropdownSearch<String>(
                dropdownSearchDecoration: const InputDecoration(
                  labelText:  "Notification Profile",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) {
                  print(data);
                },
                onFind: (filter) => getDataStudentName(filter),
              ),
            ),
          ),
        ],)
    );
  }
}


Future<List<String>> getDataStudentName(filter) async {
  getdataStudentsNames_responseBodyJSON = await  httpPost(
      destinationUrl: mainDomain, destinationPort: 8080, destinationPost: "/addStudent/stdentsGetData", msgToSend:{"student_name":filter});
  var getdataStudentsNames_responseBody= await json.decode(await getdataStudentsNames_responseBodyJSON!);
  print(await getdataStudentsNames_responseBody["msg"][1]);
  List<String> toStringList =[];
   await getdataStudentsNames_responseBody["msg"].forEach((v){
    toStringList.add(v.toString());
  });
return await toStringList;
}
