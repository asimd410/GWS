import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:glassmorphism_widgets/glassmorphism_widgets.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'StudentsMain.dart';
String firstAcadYrInSystem = "2018-2019";
bool firstAcadYrISSelected = false;
String? studentFirstNameAdd;
String? studentLastNameAdd;
String? fathersNameAdd;
String? mothersNameAdd;
String? guardiansNameAdd;
String? addressNameAdd;
//---- Father's ----------
String? fathersPhoneNoEXT = "+91";
String? fathersPhoneNoMain;

bool fathersPhoneNofisttime = true;
//---- Mother's ----------
String? mothersPhoneNoEXT = "+91";
String? mothersPhoneNoMain;

bool mothersPhoneNofisttime = true;
//---- Guardian's ----------
String? guardiansPhoneNoEXT = "+91";
String? guardiansPhoneNoMain;

bool guardiansPhoneNofisttime = true;

String? studentNameAdd = "$studentFirstNameAdd $fathersNameAdd $studentLastNameAdd";

String gender = "Male";

String? studentID;

String? grNumber;
bool grNumberAddfirstTime = true;

String? nationalityNameAdd = "Indian";
String? motherTongueNameAdd;

//------------------------------------
String? userNameAdd;
String? initialValueUserName;
String? usernameErrorString;

String? passwordAdd;
String? passwordErrorString;
bool passwordnotTyped = true;
String? initialValuePassword;

List<String>? siblingsList = [];

//------------- Aadhar -----------------------
String? aadharNumberAdd;
bool aadharNumberAddfirstTime = true;

//------------- First Class -----------------------
List<String> firstNlastClassDetials = [];
String? firstAcadYr;
String? firstClass;
String? firstDiv;

//------------- Last Class -----------------------
String? lastAcadYr;
String? lastClass;
String? lastDiv;

//------------- Enum ---------------------------
enum Status {
  dropdown,
  add,
  delete,
}

//------------- Religion -----------------------
List<String> religionAdd = [];
List<dynamic> religionAddasStringList = [Status.dropdown];

//------------- Caste -----------------------
List<String> casteListAdd = [];
List<dynamic> casteAddasStringList = [Status.dropdown];

//------------- SubCaste -----------------------
List<String> subcasteListAdd = [];
List<dynamic> subcasteAddasStringList = [Status.dropdown];

//------------- Different Abeled -----------------------
List<String> differentlyAbledListAdd = [];
List<dynamic> differentlyAbledAddasStringList = [Status.dropdown];
bool differentlyAbledBool = false;

bool newAdmissioninFirstAcadYrinsystem = false;



bool rTE = false;
bool enableStatus = true;
bool inSchool = true;

//------------- Date of Birth -----------------------
var selectedDateofBirth = [DateTime.now()];

//------------- Place of Birth -----------------------
String? placeOfBirthAddVillageorCity;
String? placeOfBirthAddTaluka;
String? placeOfBirthAddDistrict;
String? placeOfBirthAddState;
String? placeOfBirthAddCountry;

//------------- Last School Attended -----------------------
String? lastSchoolAttended;
String? lastSchoolStandardAttended;
String? uDISEpreviousSchool;
bool uDISEpreviousSchoolAddfirstTime = true;

//--------------- Date Of Admission -----------------------
var selectedDateofAdmission = [DateTime.now()];

//--------------- Leaving ---------------------------------
String? progressAdd;
String? conductAdd;
String? reasonForLeavingAdd;
var selectedSchoolLeavingDate = [DateTime.now()];


List<String>? divList = [];
List<dynamic>? divData;
List<dynamic>? acadYearNClassAdd;
String? currentDivision;
bool refDivGetter = true;

//-------------------------------------------------------------------------------------------------------
class AddStudentPage extends StatefulWidget {
  const AddStudentPage({Key? key}) : super(key: key);

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  //---------- Function for Picking Date -----------------
  Future<void> _selectDate(BuildContext context, selectedDateVar) async {
    final DateTime? pickedDate =
        await showDatePicker(context: context, initialDate: selectedDateVar[0], firstDate: DateTime(2010), lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != selectedDateVar[0]) {
      print("&&&&&&&&&&& pickedDate = $pickedDate &&&&&&&&&&&&&&&&& selectedDateVar = ${selectedSchoolLeavingDate[0]}");
      setState(() {
        selectedDateVar.clear();
        selectedDateVar.add(pickedDate);
      });
      print("AFTER &&&&&&&&&&& pickedDate = $pickedDate &&&&&&&&&&&&&&&&& initialDate = $selectedSchoolLeavingDate");
    }
  }

//---------- Function for Picking Date CLOSED -----------------
  late ScrollController _controllerOne = ScrollController();

  @override
  initState() {
    // TODO: implement initState
    super.initState();
  }

  //

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          controller: _controllerOne,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: screenW > 1000 ? 1000 : screenW,
                child: Card(
                  child: Column(
                    children: [
                      Container(
                          //TOP BAR
                          height: 30,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      "Add Student",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    funcMakeVarNullStudents();
                                    setState(() {
                                      showAddStudent = false;
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
                                      ))),
                                ),
                              )
                            ],
                          ),
                          color: Colors.blue), //TOP BAR
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                child: Wrap(
                                  runSpacing: 50,
                                  alignment: screenW < 600 ? WrapAlignment.center : WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              studentFirstNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorMaxLines: 3,
                                              errorText: studentFirstNameAdd == "" ? "Student first name cannot be empty" : null,
                                              label: const Text('Student First Name*')),
                                        ),
                                      ),
                                    ), //STUDENT NAME //ValidateD
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              studentLastNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorMaxLines: 3,
                                              errorText: studentLastNameAdd == "" ? "Student last name cannot be empty" : null,
                                              label: const Text('Student Last Name*')),
                                        ),
                                      ),
                                    ), //LAST NAME //ValidateD
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: DropdownSearch<String>.multiSelection(
                                          dropdownSearchDecoration: const InputDecoration(
                                            labelText: "Choose Sibling",
                                            border: OutlineInputBorder(),
                                          ),
                                          showSearchBox: true,
                                          onChanged: (data) {
                                            siblingsList = data;
                                          },
                                          onFind: (filter) =>
                                              getDataUniversalForStudent(filter: filter, postlink: "stdentsGetData", keytosend: "student_name"),
                                        ),
                                      ),
                                    ), //SIBLING
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              fathersNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: fathersNameAdd == "" ? "Student father's name cannot be empty" : null,
                                              label: const Text("Father's First Name*")),
                                        ),
                                      ),
                                    ), //FATHER'S NAME //ValidateD
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              mothersNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: mothersNameAdd == "" ? "Student mother's name cannot be empty" : null,
                                              label: const Text("Mother's First Name*")),
                                        ),
                                      ),
                                    ), //MOTHER'S NAME
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              guardiansNameAdd = val;
                                            });
                                          },
                                          decoration: const InputDecoration(label: Text("Guardian's Name")),
                                        ),
                                      ),
                                    ), //GUARDIAN'S NAME
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text("Gender"),
                                            ),
                                            Container(
                                              width: 120,
                                              child: ListTile(
                                                title: Text("M"),
                                                leading: Radio(
                                                    value: "Male",
                                                    groupValue: gender,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        gender = "Male";
                                                      });
                                                      print("gender = $gender");
                                                    }),
                                              ),
                                            ),
                                            Container(
                                              width: 105,
                                              child: ListTile(
                                                title: Text("F"),
                                                leading: Radio(
                                                    value: "Female",
                                                    groupValue: gender,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        gender = "Female";
                                                      });
                                                      print("gender = $gender");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //GENDER
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: CountryCodePicker(
                                                initialSelection: 'IN',
                                                onChanged: (v) {
                                                  fathersPhoneNoEXT = v.toString();
                                                  print("fathersPhoneNoEXT = $fathersPhoneNoEXT    v = $v");
                                                },
                                              ),
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 150),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    fathersPhoneNofisttime = false;
                                                    fathersPhoneNoMain = val;
                                                    print("fathersPhoneNoMain = $fathersPhoneNoMain");
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    // counter: Text("${fathersPhoneNoMain== null ?0:fathersPhoneNoMain!.length}/10"),
                                                    errorText: fathersPhoneNofisttime == true
                                                        ? null
                                                        : ValidityFuncTenDigOnlyNumber(fathersPhoneNoMain!, "Father's PhNo"),
                                                    label: const Text("Father's Phone No.")),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), //FATHER's PHONE NUMBER
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: CountryCodePicker(
                                                initialSelection: 'IN',
                                                onChanged: (v) {
                                                  mothersPhoneNoEXT = v.toString();
                                                },
                                              ),
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 150),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    mothersPhoneNofisttime = false;
                                                    mothersPhoneNoMain = val;
                                                    print(mothersPhoneNoMain);
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    // counter: Text("${fathersPhoneNoMain== null ?0:fathersPhoneNoMain!.length}/10"),
                                                    errorText: mothersPhoneNofisttime == true
                                                        ? null
                                                        : ValidityFuncTenDigOnlyNumber(mothersPhoneNoMain!, "Mother's PhNo"),
                                                    label: const Text("Mother's Phone No.")),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), //MOTHER's PHONE NUMBER
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 300,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: CountryCodePicker(
                                                initialSelection: 'IN',
                                                onChanged: (v) {
                                                  guardiansPhoneNoEXT = v.toString();
                                                },
                                              ),
                                            ),
                                            Container(
                                              constraints: const BoxConstraints(maxWidth: 150),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    guardiansPhoneNofisttime = false;
                                                    guardiansPhoneNoMain = val;
                                                    print(guardiansPhoneNoMain);
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    // counter: Text("${fathersPhoneNoMain== null ?0:fathersPhoneNoMain!.length}/10"),
                                                    errorText: guardiansPhoneNofisttime == true
                                                        ? null
                                                        : ValidityFuncTenDigOnlyNumber(guardiansPhoneNoMain!, "Guardian's PhNo"),
                                                    label: const Text("Guardian's Phone No.")),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), //GUARDIAN's PHONE NUMBER
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              studentID = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: studentID == "" ? "Student ID cannot be empty" : null,
                                              label: const Text("Student ID (UDISE)")),
                                        ),
                                      ),
                                    ), //STUDENT ID
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              grNumber = val;
                                              grNumberAddfirstTime = false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: grNumberAddfirstTime == true ? null : ValidityFuncOnlyNumber(grNumber, "G.R. Number"),
                                              label: const Text("G.R. Number")),
                                        ),
                                      ),
                                    ), //GR NUMBER
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              addressNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: addressNameAdd == "" ? "Student's address cannot be empty" : null,
                                              label: const Text("Student's Address")),
                                        ),
                                      ),
                                    ), //ADDRESS
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextFormField(
                                          initialValue: "Indian",
                                          onChanged: (val) {
                                            setState(() {
                                              nationalityNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: nationalityNameAdd == "" ? "Student's nationality cannot be empty" : null,
                                              label: const Text("Student's Nationality*")),
                                        ),
                                      ),
                                    ), //NATIONALITY
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              motherTongueNameAdd = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: motherTongueNameAdd == "" ? "Student's mother tongue cannot be empty" : null,
                                              label: const Text("Student's Mother Tongue")),
                                        ),
                                      ),
                                    ), //MOTHER TONGUE
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              aadharNumberAdd = val;
                                              aadharNumberAddfirstTime = false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: aadharNumberAddfirstTime == true
                                                  ? null
                                                  : ValidityFuncTenDigOnlyNumber(aadharNumberAdd!, "Aadhar No."),
                                              labelText: "Aadhar Number"),
                                        ),
                                      ),
                                    ), //AADHAR NUMBER
                                    DropDownAndTextFieldWig(
                                      status: religionAddasStringList,
                                      postLinkDel: "/getReligionData/delReligion",
                                      postLink: "/getReligionData",
                                      valueHolderVar: religionAdd,
                                      keyTosend: "religion_name",
                                      fieldName: "Religion",
                                    ), //RELIGION
                                    DropDownAndTextFieldWig(
                                      status: casteAddasStringList,
                                      valueHolderVar: casteListAdd,
                                      keyTosend: "caste_name",
                                      postLink: "/getDataCaste",
                                      fieldName: "Caste",
                                      postLinkDel: "/getDataCaste/delCaste",
                                    ), //CASTE
                                    DropDownAndTextFieldWig(
                                      status: subcasteAddasStringList,
                                      valueHolderVar: subcasteListAdd,
                                      keyTosend: "subcaste_name",
                                      postLink: "/getDataSubcaste",
                                      fieldName: "Subcaste",
                                      postLinkDel: "/getDataSubcaste/delSubcaste",
                                    ), //SUBCASTE
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text("RTE"),
                                            ),
                                            Container(
                                              width: 120,
                                              child: ListTile(
                                                title: Text("Y"),
                                                leading: Radio(
                                                    value: true,
                                                    groupValue: rTE,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        rTE = true;
                                                      });
                                                      print("rTE = $rTE");
                                                    }),
                                              ),
                                            ),
                                            Container(
                                              width: 105,
                                              child: ListTile(
                                                title: Text("N"),
                                                leading: Radio(
                                                    value: false,
                                                    groupValue: rTE,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        rTE = false;
                                                      });
                                                      print("rTE = $rTE");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //RTE Bool
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 34),
                                      child: SizedBox(
                                        width: 300,
                                        child: InkWell(
                                          onTap: () {
                                            _selectDate(context, selectedDateofBirth);
                                            print("selectedDateofBirth = ${selectedDateofBirth}");
                                          },
                                          child: Container(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Text("Date Of Birth "),
                                                selectedDateofBirth == null
                                                    ? Text("__/__/____")
                                                    : Text(
                                                        "${selectedDateofBirth[0].day}/${selectedDateofBirth[0].month}/${selectedDateofBirth[0].year}"),
                                                Icon(Icons.calendar_today),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), //DATE OF BIRTH
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              placeOfBirthAddVillageorCity = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: placeOfBirthAddVillageorCity == "" ? "Place of Birth Village/City cannot be empty" : null,
                                              label: const Text("Place of Birth Village/City")),
                                        ),
                                      ),
                                    ), //PLACE OF BIRTH VLLAGE CITY
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              placeOfBirthAddTaluka = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: placeOfBirthAddTaluka == "" ? "Place of Birth Taluka cannot be empty" : null,
                                              label: const Text("Place of Birth Taluka")),
                                        ),
                                      ),
                                    ), //PLACE OF BIRTH TALUKA
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              placeOfBirthAddDistrict = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: placeOfBirthAddDistrict == "" ? "Place of Birth District cannot be empty" : null,
                                              label: const Text("Place of Birth District")),
                                        ),
                                      ),
                                    ), //PLACE OF BIRTH DISTRICT
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              placeOfBirthAddState = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: placeOfBirthAddState == "" ? "Place of Birth State cannot be empty" : null,
                                              label: const Text("Place of Birth State")),
                                        ),
                                      ),
                                    ), //PLACE OF BIRTH STATE
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              placeOfBirthAddCountry = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: placeOfBirthAddCountry == "" ? "Place of Birth Country cannot be empty" : null,
                                              label: const Text("Place of Birth Country")),
                                        ),
                                      ),
                                    ), //PLACE OF BIRTH COUNTRY
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              lastSchoolAttended = val;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: lastSchoolAttended == "" ? "Last School Attended cannot be empty" : null,
                                              label: const Text("Last School Attended")),
                                        ),
                                      ),
                                    ), //LAST SCHOOL ATTENDED
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            lastSchoolStandardAttended = val;
                                          },
                                          decoration: InputDecoration(
                                              errorText: lastSchoolStandardAttended == "" ? "Last School Standard Attended cannot be empty" : null,
                                              label: const Text("Last School Standard & Div Attended")),
                                        ),
                                      ),
                                    ), //LAST SCHOOL STANDARD ATTENDED
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: TextField(
                                          onChanged: (val) {
                                            setState(() {
                                              uDISEpreviousSchool = val;
                                              uDISEpreviousSchoolAddfirstTime = false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              errorText: uDISEpreviousSchoolAddfirstTime == false
                                                  ? ValidityFuncOnlyNumber(uDISEpreviousSchool, "Previous School UDISE No.")
                                                  : null,
                                              // errorText: lastSchoolStandardAttended == "" ? "Last School Standard Attended cannot be empty" : null,
                                              label: const Text("Last School Attended UDISE NO.")),
                                        ),
                                      ),
                                    ), //LAST SCHOOL UDISE NO.
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 34),
                                      child: SizedBox(
                                        width: 300,
                                        child: InkWell(
                                          onTap: () {
                                            _selectDate(context, selectedDateofAdmission);
                                            print("selectedDateofAdmission = ${selectedDateofAdmission[0]}");
                                          },
                                          child: Container(
                                            width: 200,
                                            child: Row(
                                              children: [
                                                Text("Date Of Admission "),
                                                selectedDateofAdmission == null
                                                    ? Text("__/__/____")
                                                    : Text(
                                                        "${selectedDateofAdmission[0].day}/${selectedDateofAdmission[0].month}/${selectedDateofAdmission[0].year}"),
                                                Icon(Icons.calendar_today),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ), //DATE OF ADMISSION
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: DropdownSearch<String>.multiSelection(
                                          dropdownSearchDecoration: const InputDecoration(
                                            labelText: "Choose Division",
                                            border: OutlineInputBorder(),
                                          ),
                                          showSearchBox: true,
                                          onChanged: (data) async {
                                            divList = data;
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
                                           for (var e in divList!) {
                                             if(e.contains(firstAcadYrInSystem)){
                                               setState(() {
                                                 firstAcadYrISSelected = true;
                                               });
                                             }
                                           }
                                            firstNlastClassDetials = funcGetAdmittedClassAnddiv();

                                            firstAcadYr = firstNlastClassDetials[2].substring(1, 10);
                                            firstClass = firstNlastClassDetials[1];
                                            firstDiv = firstNlastClassDetials[0];

                                            lastAcadYr = firstNlastClassDetials[5].substring(1, 10);
                                            lastClass = firstNlastClassDetials[4];
                                            lastDiv = firstNlastClassDetials[3];

                                            setState(() {
                                              divData = divData;
                                              refDivGetter = !refDivGetter;
                                            });
                                          },
                                          onFind: (filter) => refDivGetter == true ?getDatadivision(filter):getDatadivision(filter),
                                        ),
                                      ),
                                    ), //SELECT DIVISIONS
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 34),
                                      child: SizedBox(
                                          width: 300,
                                          child: Text("Current Class: ${acadYearNClassAdd == null ? "" : acadYearNClassAdd![1]["currentClass"]}")),
                                    ), //Class
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 34),
                                      child: SizedBox(
                                        width: 300,
                                        child: Text(
                                            "Academic Year: ${acadYearNClassAdd == null ? "" : acadYearNClassAdd![0][acadYearNClassAdd![0].lastKey()]}-${acadYearNClassAdd == null ? "" : acadYearNClassAdd![0][acadYearNClassAdd![0].lastKey()] + 1}"),
                                      ),
                                    ), //ACADEMIC YEAR
                                    firstAcadYrISSelected == true?
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                             Padding(
                                               padding: const EdgeInsets.all(8.0),
                                               child: Column(
                                                 children: [
                                                   Text("New Admission"),
                                                   Text("in $firstAcadYrInSystem"),
                                                 ],
                                               ),
                                             ),
                                            SizedBox(
                                              width: 70,
                                              child: ListTile(
                                                title: const Text("Y"),
                                                leading: Radio(
                                                    value: true,
                                                    groupValue: newAdmissioninFirstAcadYrinsystem,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        newAdmissioninFirstAcadYrinsystem = true;
                                                      });
                                                      print("newAdmissioninFirstAcadYrinsystem = $newAdmissioninFirstAcadYrinsystem");
                                                    }),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 70,
                                              child: ListTile(
                                                title: const Text("N"),
                                                leading: Radio(
                                                    value: false,
                                                    groupValue: newAdmissioninFirstAcadYrinsystem,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        newAdmissioninFirstAcadYrinsystem = false;
                                                      });
                                                      print("newAdmissioninFirstAcadYrinsystem = $newAdmissioninFirstAcadYrinsystem");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                        :
                                    Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text("Enable"),
                                            ),
                                            Container(
                                              width: 120,
                                              child: ListTile(
                                                title: Text("Y"),
                                                leading: Radio(
                                                    value: true,
                                                    groupValue: enableStatus,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        enableStatus = true;
                                                      });
                                                      print("enableStatus = $enableStatus");
                                                    }),
                                              ),
                                            ),
                                            Container(
                                              width: 105,
                                              child: ListTile(
                                                title: Text(
                                                  "N",
                                                  style: TextStyle(color: rTE == true ? Colors.red : null),
                                                ),
                                                leading: Radio(
                                                    value: false,
                                                    groupValue: enableStatus,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        if (rTE == true) {
                                                          enableStatus = true;
                                                        } else {
                                                          enableStatus = false;
                                                        }
                                                      });
                                                      print("enableStatus = $enableStatus");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //Enable Bool
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: DropdownSearch<String>.multiSelection(
                                          enabled: false,
                                          dropdownSearchDecoration: const InputDecoration(
                                            labelText: "Choose Notification Profile",
                                            border: OutlineInputBorder(),
                                          ),
                                          showSearchBox: true,
                                          onChanged: (data) async {
                                            setState(() {});

                                            // print("divData = $divData");
                                          },
                                          onFind: (filter) => getDatadivision(filter),
                                        ),
                                      ),
                                    ), //SELECT NOTIFICATION PROFILE
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                        top: 20,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text("In school"),
                                            ),
                                            Container(
                                              width: 120,
                                              child: ListTile(
                                                title: Text("Y"),
                                                leading: Radio(
                                                    value: true,
                                                    groupValue: inSchool,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        inSchool = true;
                                                      });
                                                      print("inSchool = $inSchool");
                                                    }),
                                              ),
                                            ),
                                            Container(
                                              width: 105,
                                              child: ListTile(
                                                title: Text("N"),
                                                leading: Radio(
                                                    value: false,
                                                    groupValue: inSchool,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        inSchool = false;
                                                      });
                                                      print("inSchool = $inSchool");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //InSCHOOL Bool
                                    funcIfElseWidgetReturnFalse(
                                      inSchool,
                                      Wrap(
                                        // runSpacing: 50,
                                        alignment: screenW < 600 ? WrapAlignment.center : WrapAlignment.spaceBetween,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0, left: 8, top: 34),
                                            child: InkWell(
                                              onTap: () {
                                                _selectDate(context, selectedSchoolLeavingDate);
                                                print("selectedDateofBirth = $selectedSchoolLeavingDate");
                                              },
                                              child: Container(
                                                width: 300,
                                                child: Row(
                                                  children: [
                                                    Text("School Leaving Date "),
                                                    selectedSchoolLeavingDate == null
                                                        ? Text("__/__/____")
                                                        : Text(
                                                            "${selectedSchoolLeavingDate[0].day}/${selectedSchoolLeavingDate[0].month}/${selectedSchoolLeavingDate[0].year}"),
                                                    Icon(Icons.calendar_today),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ), //Choose LEAVING DATE
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              constraints: const BoxConstraints(maxWidth: 300),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    progressAdd = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: progressAdd == "" ? "Progress cannot be empty" : null, label: const Text("Progress")),
                                              ),
                                            ),
                                          ), //PROGRESS
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              constraints: const BoxConstraints(maxWidth: 300),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    conductAdd = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: conductAdd == "" ? "Conduct cannot be empty" : null, label: const Text("Conduct")),
                                              ),
                                            ),
                                          ), //CONDUCT
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 60),
                                            child: Container(
                                              constraints: const BoxConstraints(maxWidth: 300),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    reasonForLeavingAdd = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    errorText: reasonForLeavingAdd == "" ? "Reason for Leaving cannot be empty" : null,
                                                    label: const Text("Reason for Leaving")),
                                              ),
                                            ),
                                          ), //REASON FOR LEAVING
                                        ],
                                      ),
                                    ), //If LEAVING SCHOOL
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                        left: 8,
                                      ),
                                      child: Container(
                                        width: 300,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(3))),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8,
                                              ),
                                              child: Text("Differently Abled"),
                                            ),
                                            Container(
                                              width: 70,
                                              child: ListTile(
                                                title: Text("Y"),
                                                leading: Radio(
                                                    value: true,
                                                    groupValue: differentlyAbledBool,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        differentlyAbledBool = true;
                                                      });
                                                      print("differentlyAbled = $differentlyAbledBool");
                                                    }),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              child: ListTile(
                                                title: Text("N"),
                                                leading: Radio(
                                                    value: false,
                                                    groupValue: differentlyAbledBool,
                                                    onChanged: (v) {
                                                      setState(() {
                                                        differentlyAbledBool = false;
                                                      });
                                                      print("differentlyAbled = $differentlyAbledBool");
                                                    }),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), //DIFFERENTLY ABLED Bool
                                    funcIfElseWidgetReturnTrue(
                                      differentlyAbledBool,
                                      DropDownAndTextFieldWig(
                                        status: differentlyAbledAddasStringList,
                                        valueHolderVar: differentlyAbledListAdd,
                                        keyTosend: "student_differently_abled",
                                        postLink: "/getDataDifferentlyAbled",
                                        fieldName: "Differently Abled",
                                        postLinkDel: "/getDataDifferentlyAbled/delDifferentlyAbled",
                                      ), //DIFFERENTLY ABLED DROPDOWN
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              initialValue: initialValueUserName,
                                              onChanged: (val) async {
                                                await functionToCheckValidUserName(val);
                                                setState(() {
                                                  userNameAdd = val;
                                                  usernameErrorString = usernameErrorString;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  errorText: userNameAdd == "" ? "UserName cannot be empty" : usernameErrorString,
                                                  label: const Text("UserName Name*")),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), //USERNAME
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        constraints: const BoxConstraints(maxWidth: 300),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              initialValue: initialValuePassword,
                                              onChanged: (val) {
                                                functionToCheckPassword(val);
                                                setState(() {
                                                  passwordAdd = val;
                                                  passwordErrorString = passwordErrorString;
                                                });
                                              },
                                              decoration: InputDecoration(errorText: passwordErrorString, label: const Text("Password*")),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ), //PASSWORD
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                height: 50,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      bool isValid = true;
                                      //----- reusable function for validation --------------
                                      funcforValidation(functhatValidates) {
                                        if (functhatValidates != null) {
                                          isValid = false;
                                          String? _errMsg = functhatValidates;
                                          setState(() {
                                            final snackBar = SnackBar(
                                              content: Text(_errMsg!),
                                              backgroundColor: (snackbarErrorBg),
                                              action: SnackBarAction(
                                                label: 'dismiss',
                                                textColor: snackbarErrorTxt,
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                          });
                                        }
                                      }

                                      // --------------- Functions to validate individual Fields ---------------
                                      funcforValidation(ValidityFuncStringNotEmpty(studentFirstNameAdd, "Student First Name"));
                                      funcforValidation(ValidityFuncStringNotEmpty(studentLastNameAdd, "Student Last Name"));
                                      funcforValidation(ValidityFuncStringNotEmpty(fathersNameAdd, "Father's Name"));
                                      // funcforValidation(ValidityFuncOnlyNumber(grNumber, "G.R. Number"));
                                      // funcforValidation(ValidityFuncStringNotEmpty(mothersNameAdd, "Mother's Name"));
                                      // funcforValidation(ValidityFuncStringNotEmpty(guardiansNameAdd, "Guardian's Name"));
                                      // funcforValidation(ValidityFuncStringNotEmpty(addressNameAdd, "Student's Address*"));
                                      // funcforValidation(ValidityFuncTenDigOnlyNumber(fathersPhoneNoMain, "Father's Ph. no.*"));
                                      // funcforValidation(ValidityFuncTenDigOnlyNumber(mothersPhoneNoMain, "Mother's Ph. no.*"));
                                      // funcforValidation(ValidityFuncTenDigOnlyNumber(guardiansPhoneNoMain, "Guardian's Ph. no.*"));
                                      // funcforValidation(ValidityFuncTenDigOnlyNumber(aadharNumberAdd, "Aadhar Number"));
                                      // funcforValidation(ValidityFuncStringNotEmpty(religionAdd, "Religion"));
                                      // funcforValidation(ValidityFuncStringNotEmpty(casteAdd, "Caste"));
                                      //  funcforValidation(ValidityFuncStringNotEmpty(placeOfBirthAdd, "Place Of Birth"));
                                      //  funcforValidation(ValidityFuncListNotEmpty(divList, "Division"));
                                      if(divList!.isNotEmpty) {
                                        divList!.forEach((e) {
                                          int _count = 0;
                                          List<String> _tempSplitofE = e.split(" ");
                                          String _tempAcadYear = _tempSplitofE[2];
                                          divList!.forEach((j) {
                                            if (j.contains(_tempAcadYear)) {
                                              _count++;
                                            }
                                          });
                                          if (_count > 1) {
                                            setState(() {
                                              final snackBar = SnackBar(
                                                content: Text("Two or more Divisions have the same Academic Year"),
                                                backgroundColor: (snackbarErrorBg),
                                                action: SnackBarAction(
                                                  label: 'dismiss',
                                                  textColor: snackbarErrorTxt,
                                                  onPressed: () {},
                                                ),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            });
                                            isValid = false;
                                          }
                                          else{
                                            isValid = true;
                                          }
                                        });
                                      }else{
                                        isValid = false;
                                        setState(() {
                                          final snackBar = SnackBar(
                                            content: const Text("Select Division cannot be Empty"),
                                            backgroundColor: (snackbarErrorBg),
                                            action: SnackBarAction(
                                              label: 'dismiss',
                                              textColor: snackbarErrorTxt,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        });
                                      }

                                     if (isValid == true) {
                                       addStudent_http_responseBodyJSON = await httpPost(
                                         msgToSend: {
                                           "msg": "addStudent",
                                           "student_first_name": studentFirstNameAdd,
                                           "student_last_name": studentLastNameAdd,
                                           "student_middle_name": fathersNameAdd,
                                           "student_name": "$studentFirstNameAdd $fathersNameAdd $studentLastNameAdd",
                                           "student_gender": gender,
                                           "student_ID_UDISE": studentID,
                                           "student_GR_No": grNumber,
                                           "student_nationality": nationalityNameAdd,
                                           "student_mother_tongue": motherTongueNameAdd,
                                           "sibling": siblingsList,
                                           "student_fathers_name": fathersNameAdd,
                                           "student_mothers_name": mothersNameAdd,
                                           "student_guardians_name": guardiansNameAdd,
                                           "student_address_name": addressNameAdd,
                                           "student_fathers_ph_no": "$fathersPhoneNoEXT$fathersPhoneNoMain",
                                           "student_mothers_ph_no": "$mothersPhoneNoEXT$mothersPhoneNoMain",
                                           "student_guardians_ph_no": "$guardiansPhoneNoEXT$guardiansPhoneNoMain",
                                           "student_aadhar_no": aadharNumberAdd,
                                           "student_RTE": rTE,
                                           "student_date_of_birth":
                                           "${selectedDateofBirth[0].day}/${selectedDateofBirth[0].month}/${selectedDateofBirth[0].year}",
                                           "student_religion": religionAdd.isEmpty ? null : religionAdd[0],
                                           "student_caste": casteListAdd.isEmpty ? null : casteListAdd[0],
                                           "student_subcaste": subcasteListAdd.isEmpty ? null : subcasteListAdd[0],
                                           "student_differently_abled": differentlyAbledListAdd.isEmpty ? null : differentlyAbledListAdd[0],
                                           "student_differently_abled_bool": differentlyAbledBool,
                                           "student_place_of_birth_villageorcity": placeOfBirthAddVillageorCity,
                                           "student_place_of_birth_taluka": placeOfBirthAddTaluka,
                                           "student_place_of_birth_district": placeOfBirthAddDistrict,
                                           "student_place_of_birth_state": placeOfBirthAddState,
                                           "student_place_of_birth_country": placeOfBirthAddCountry,
                                           "student_current_division": currentDivision,
                                           "student_LastSchoolAttended": lastSchoolAttended,
                                           "student_LastSchoolStandardAttended": lastSchoolStandardAttended,
                                           "student_UDISEpreviousSchool": uDISEpreviousSchool,
                                           "student_date_of_admission":
                                           "${selectedDateofAdmission[0].day}/${selectedDateofAdmission[0].month}/${selectedDateofAdmission[0].year}",
                                           "student_progress": progressAdd,
                                           "student_conduct": conductAdd,
                                           "student_reasonForLeaving": reasonForLeavingAdd,
                                           "student_divisions": divList,
                                           "student_divisionsData": "afds",
                                           "student_username": userNameAdd ?? initialValueUserName,
                                           "student_password": passwordAdd ?? initialValuePassword,
                                           "student_enable_status": enableStatus.toString(),
                                           "student_Leaving_Date":
                                           "${selectedSchoolLeavingDate[0].day}/${selectedSchoolLeavingDate[0].month}/${selectedSchoolLeavingDate[0].year}",
                                           "student_InSchool": inSchool,
                                           "updatedBy": userName,
                                           "student_firstAcadYr_Attended": firstAcadYr,
                                           "student_firstClass_Attended": firstClass,
                                           "student_firstDiv_Attended": firstDiv,
                                           "student_lastAcadYr_Attended": lastAcadYr,
                                           "student_lastClass_Attended": lastClass,
                                           "student_lastDiv_Attended": lastDiv,
                                           "firstAcadYrInSystem": firstAcadYrInSystem,
                                           "newAdmissioninFirstAcadYrinsystem":newAdmissioninFirstAcadYrinsystem,
                                         },
                                         destinationPort: 8080,
                                         destinationPost: "/addStudent",
                                         destinationUrl: mainDomain,
                                       );
                                       // addStudent_http_responseBody = json.decode(addStudent_http_responseBodyJSON!);



                                       if (addStudent_http_responseBodyJSON != "Saved") {
                                         String? _errMsg = addStudent_http_responseBodyJSON;
                                         setState(() {
                                           final snackBar = SnackBar(
                                             content: Text(_errMsg!),
                                             backgroundColor: (snackbarErrorBg),
                                             action: SnackBarAction(
                                               label: 'dismiss',
                                               textColor: snackbarErrorTxt,
                                               onPressed: () {},
                                             ),
                                           );
                                           ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                         });
                                       }
                                       else{

                                         if (religionAddasStringList.isNotEmpty && religionAdd.isNotEmpty) {
                                           if (religionAddasStringList[0] == Status.add && religionAddasStringList[0] != null) {
                                             await httpPost(
                                                 destinationUrl: mainDomain,
                                                 destinationPort: 8080,
                                                 destinationPost: "/getReligionData/addReligion",
                                                 msgToSend: {"religion_name": religionAdd[0], "updatedBy": userName});
                                           }
                                         }

                                         if (casteAddasStringList.isNotEmpty && casteListAdd.isNotEmpty) {
                                           if (casteAddasStringList[0] == Status.add && casteAddasStringList[0] != null) {
                                             await httpPost(
                                                 destinationUrl: mainDomain,
                                                 destinationPort: 8080,
                                                 destinationPost: "/getDataCaste/addCaste",
                                                 msgToSend: {"caste_name": casteListAdd[0], "updatedBy": userName});
                                           }
                                         }

                                         if (subcasteAddasStringList.isNotEmpty && subcasteListAdd.isNotEmpty) {
                                           if (subcasteAddasStringList[0] == Status.add && subcasteAddasStringList[0] != null) {
                                             print("@@@@@@@@@@@@@@@@@@${subcasteListAdd[0]}");
                                             await httpPost(
                                                 destinationUrl: mainDomain,
                                                 destinationPort: 8080,
                                                 destinationPost: "/getDataSubcaste/addSubcaste",
                                                 msgToSend: {"subcaste_name": subcasteListAdd[0], "updatedBy": userName});
                                           }
                                         }

                                         if (differentlyAbledAddasStringList.isNotEmpty && differentlyAbledListAdd.isNotEmpty) {
                                           if (differentlyAbledAddasStringList[0] == Status.add) {
                                             print("@@@@@@@@@@@@@@@@@@${differentlyAbledListAdd[0]}");
                                             await httpPost(
                                                 destinationUrl: mainDomain,
                                                 destinationPort: 8080,
                                                 destinationPost: "/getDataDifferentlyAbled/addDifferentlyAbled",
                                                 msgToSend: {"student_differently_abled": differentlyAbledListAdd[0], "updatedBy": userName});
                                           }
                                         }
                                         funcMakeVarNullStudents();
                                         setState(() {
                                           showAddStudent = false;
                                           refreshStudentTable = true;
                                           Provider.of<Data>(context, listen: false).refreshStudentMainfunc(true);

                                         });
                                       }
                                     }
                                    },
                                    child: Text("Create Student")),
                              ),
                            ) //CREATE STUDENT BUTTON
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//

//

class DropDownAndTextFieldWig extends StatefulWidget {
  List<dynamic> status;
  List<String> valueHolderVar;
  String postLink;
  String postLinkDel;
  String keyTosend;
  String fieldName;

  DropDownAndTextFieldWig(
      {required this.status,
      required this.valueHolderVar,
      required this.keyTosend,
      required this.fieldName,
      required this.postLink,
      required this.postLinkDel});

  @override
  State<DropDownAndTextFieldWig> createState() => _DropDownAndTextFieldWigState();
}

class _DropDownAndTextFieldWigState extends State<DropDownAndTextFieldWig> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.status[0] == Status.add)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextField(
                  onChanged: (val) async {
                    setState(() {
                      if (widget.valueHolderVar.isEmpty) {
                        widget.valueHolderVar.add(val);
                      } else {
                        widget.valueHolderVar[0] = val;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    errorText: widget.valueHolderVar.isEmpty
                        ? null
                        : widget.valueHolderVar[0] == ""
                            ? "Student's ${widget.fieldName} cannot be empty"
                            : null,
                    label: Text(widget.fieldName),
                  ),
                ),
              ),
            ) //ADD
          else if (widget.status[0] == Status.dropdown)
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: DropdownSearch<String>(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Choose ${widget.fieldName}",
                  border: OutlineInputBorder(),
                ),
                showSearchBox: true,
                onChanged: (data) async {
                  if (widget.valueHolderVar.isEmpty) {
                    widget.valueHolderVar.add(data!);
                  } else {
                    widget.valueHolderVar[0] = data!;
                  }
                  print(" widget.valueHolderVar[0] = ${widget.valueHolderVar[0]}");
                },
                onFind: (filter) => getDataUniversal(filter: filter, postlink: widget.postLink, keytosend: widget.keyTosend),
              ),
            ) // DROPDOWN
          else
            SizedBox(
              width: 300,
              child: Row(
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 257),
                    child: DropdownSearch<String>(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "Choose ${widget.fieldName}",
                        border: OutlineInputBorder(),
                      ),
                      showSearchBox: true,
                      onChanged: (data) async {
                        if (widget.valueHolderVar.isEmpty) {
                          widget.valueHolderVar.add(data!);
                        } else {
                          widget.valueHolderVar[0] = data!;
                        }
                        print(" widget.valueHolderVar[0] = ${widget.valueHolderVar[0]}");
                      },
                      onFind: (filter) => getDataUniversal(filter: filter, postlink: widget.postLink, keytosend: widget.keyTosend),
                    ),
                  ), // Delete DropDown
                  IconButton(
                      onPressed: () async {
                        if (widget.valueHolderVar.isNotEmpty) {
                          await httpPost(
                              destinationUrl: mainDomain,
                              destinationPort: 8080,
                              destinationPost: widget.postLinkDel,
                              msgToSend: {widget.keyTosend: widget.valueHolderVar[0], "updatedBy": userName});
                        }
                        setState(() {
                          widget.status[0] = Status.dropdown;
                        });
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        size: 20,
                      )) //Delete Button
                ],
              ),
            ), //DELETE
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
              left: 8,
            ),
            child: Container(
              width: 300,
              height: 50,
              // decoration: BoxDecoration(
              //     border: Border.all(width: 1, color: Colors.grey), borderRadius: const BorderRadius.all(Radius.circular(3))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      child: ListTile(
                        title: const Tooltip(message: "Choose from DropDown", child: Icon(Icons.arrow_drop_down_outlined)),
                        leading: Radio(
                            value: Status.dropdown,
                            groupValue: widget.status[0],
                            onChanged: (v) {
                              setState(() {
                                widget.status[0] = Status.dropdown;
                              });
                              print(" widget.ddTrueTfFalse[0]= ${widget.status[0]}");
                            }),
                      ),
                    ),
                  ), //DropDown
                  Expanded(
                    child: Container(
                      child: ListTile(
                        title: const Tooltip(
                            message: "Add New Entry to DropDown",
                            child: Icon(
                              Icons.add,
                              size: 20,
                            )),
                        leading: Radio(
                            value: Status.add,
                            groupValue: widget.status[0],
                            onChanged: (v) {
                              setState(() {
                                widget.status[0] = Status.add;
                              });
                              print("widget.ddTrueTfFalse[0] = ${widget.status[0]}");
                            }),
                      ),
                    ),
                  ), //Add
                  Expanded(
                    child: Container(
                      child: ListTile(
                        title: const Tooltip(
                            message: "Delete from DropDown",
                            child: Icon(
                              Icons.delete,
                              size: 20,
                            )),
                        leading: Radio(
                            value: Status.delete,
                            groupValue: widget.status[0],
                            onChanged: (v) {
                              setState(() {
                                widget.status[0] = Status.delete;
                              });
                              print("widget.ddTrueTfFalse[0] = ${widget.status[0]}");
                            }),
                      ),
                    ),
                  ) //Delete
                ],
              ),
            ),
          ), //RTE Bool
        ],
      ),
    );
  }
}
