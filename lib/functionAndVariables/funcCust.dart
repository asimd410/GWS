import 'dart:collection';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gws/screens/classList/divisionCreateView.dart';
import 'package:gws/screens/feesPage/createInstallments/feesInstallmentsCreate.dart';
import 'package:gws/screens/students/FilteredPanelStudent.dart';
import 'package:gws/screens/students/add_student_page.dart';
import 'package:gws/screens/students/wigForStudent/discountsWig.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:excel/excel.dart';
import 'CommVariables.dart';
import 'dart:typed_data';
// import 'commonWidgets/snackBarForError.dart';

//__________________________________________________ HTTP POST FUNC _________________________________________________________________________
Future<String> httpPost({destinationUrl, destinationPort, destinationPost, required Map<String, dynamic> msgToSend}) async {
  String resBody = "";
  try {
    var url = Uri.http('$destinationUrl:$destinationPort', '$destinationPost');
    final http.Response res = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          // <String, String>{
          //     "bismillah":"bismillah"
          // },
          msgToSend),
    );
    if (res.statusCode == 200) {
      // print(res.body);
      print("res.statusCode = ${res.statusCode}");
      resBody = res.body;
      return Future.delayed(const Duration(microseconds: 1), () => resBody);
    } else {
      print("res.statusCode = ${res.statusCode}");
      return Future.delayed(const Duration(microseconds: 1), () => "");
    }
  } catch (e) {
    print("ERROR HAS HAPPENED ASIM");
    print(e);
    return Future.delayed(const Duration(microseconds: 1), () => "");
  }
}
//_____________________________________________________ HTTP POST FUNC  CLOSED______________________________________________________________________

//__________________________________________________ PROVIDER FUNC _________________________________________________________________________

class Data extends ChangeNotifier {
  bool refrashPage = false;

  void refPage(ref) {
    refrashPage = ref;
    notifyListeners();
  }

  bool refrashPageEditAcadyr = false;

  void refPageEditAcadyr(ref) {
    refrashPageEditAcadyr = ref;
    notifyListeners();
  }

  bool refrashPageEditClass = false;

  void refPageEditClass(ref) {
    refrashPageEditClass = ref;
    notifyListeners();
  }

  bool refrashPageEditSubject = false;

  void refPageEditSubject(ref) {
    refrashPageEditSubject = ref;
    notifyListeners();
  }

  bool refrashPageEditDivision = false;

  void refPageEditDivision(ref) {
    refrashPageEditDivision = ref;
    notifyListeners();
  }

  bool refrashPageAddStudent = false;

  void refPageAddStudent(ref) {
    refrashPageAddStudent = ref;
    notifyListeners();
  }

  bool refreshStudentMain = false;

  void refreshStudentMainfunc(ref) {
    refreshStudentMain = ref;
    notifyListeners();
  }

  //
  bool refreshInstallmentDate = false;

  void refreshInstallmentDatefunc(ref) {
    refreshInstallmentDate = ref;
    notifyListeners();
  }

  bool refInstallmentTable = true;

  void refInstallmentTablefunc(ref) {
    refInstallmentTable = ref;
    notifyListeners();
  }

  bool refDiscountWig = true;

  void refDiscountWigfunc(ref) {
    refDiscountWig = ref;
    notifyListeners();
  }
}

// SETTER =   Provider.of<Data>(context, listen: false).refPage(true);

// LISTENER =   Provider.of<Data>(context, listen: true).refrashPage == true ? : ;

//__________________________________________________ PROVIDER FUNC Closed _________________________________________________________________________

//__________________________________________________ String Validation Functions _________________________________________________________________________

//-------- Normal String Validation not empty ------

String? ValidityFuncListNotEmpty(assignVal, nameofField) {
  if (assignVal.isEmpty) {
    String errMsg = "Choose At-least One Value in $nameofField";
    return errMsg;
  } else {
    return null;
  }
}

String? ValidityFuncStringNotEmpty(assignVal, nameofField) {
  if (assignVal == "" || assignVal == null) {
    String errMsg = "$nameofField cannot be empty";
    return errMsg;
  } else {
    return null;
  }
}

//-------- Only Numbers Validation not empty ------
String? ValidityFuncOnlyNumber(assignVal, nameofField) {
  // print("assignVal = $assignVal");
  String _errMsg = "$nameofField is invalid";
  if (assignVal == "" || assignVal == null) {
    // print("empty");
    String _errMsg = "$nameofField cannot be empty";
    print("issue 1");
    return _errMsg;
  } else if (assignVal != "" || assignVal != null) {
    // print("notempty");
    if (assignVal.contains(RegExp(r'[!@#$%^&*()_\-=\[\]{+};:"\\|,<>\/?]')) ||
        assignVal.contains(RegExp(r"[']")) ||
        assignVal.contains(RegExp(r"[a-z,A-Z]"))) {
      // print("contains Wrong Char");
      print("issue 2");
      return _errMsg;
    } else {
      print("issue 3");
      return null;
    }
  }
}

//-------- Phone Number /aadhar no. 10digit Validation not empty ------
String? ValidityFuncTenDigOnlyNumber(assignVal, nameofField) {
  // print("assignVal = $assignVal");
  String _errMsg = "$nameofField is invalid";
  if (assignVal == "" || assignVal == null) {
    // print("empty");
    String _errMsg = "$nameofField cannot be empty";
    return _errMsg;
  } else if (assignVal != "" || assignVal != null) {
    // print("notempty");
    if (assignVal.contains(RegExp(r'[!@#$%^&*()_\-=\[\]{+};:"\\|,<>\/?]')) ||
        assignVal.contains(RegExp(r"[']")) ||
        assignVal.contains(RegExp(r"[a-z,A-Z]"))) {
      // print("contains Wrong Char");
      return _errMsg;
    } else {
      if (assignVal.length != 10) {
        return "${assignVal == null ? 0 : assignVal!.length}/10";
      } else {
        return null;
      }
    }
  }
}

//Not Empty and only Numbers(infinite) decimal allowed
String? funcValEmptyOrNumber(assignval, nameofField) {
  // print("nameofField = $nameofField");
  // print("assignval = $assignval");
  bool tempDecimal = false;

  String assignvalString = assignval == null ? "" : assignval.toString();

  if (assignvalString != null) {
    if (assignvalString.length == 1) {
      tempDecimal = false;
    } else {
      tempDecimal = funcChkIfStringHasMoreThanOneDecimal(assignvalString);
    }
  } else {
    tempDecimal = false;
  }

  if (assignvalString == "" && assignvalString != "^") {
    return "$nameofField cannot be Empty";
  } else if (assignvalString == null) {
    return null;
  } else if (assignvalString.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,<>\/?]')) ||
      assignvalString.contains(RegExp(r"[']")) ||
      assignvalString.contains(RegExp(r"[a-z,A-Z]"))) {
    if (assignvalString != "^") {
      return "$nameofField is an invalid number";
    }
  } else if (tempDecimal == true) {
    return "$nameofField is an invalid number";
  }
  // else{return null;}
}

String? funcValEmptyOrNumberAdmissionFee(assignval, nameofField) {
  // print("nameofField = $nameofField");
  // print("assignval = $assignval");
  bool tempDecimal = false;

  String assignvalString = assignval == null ? "" : assignval.toString();

  if (assignvalString != null) {
    if (assignvalString.length == 1) {
      tempDecimal = false;
    } else {
      tempDecimal = funcChkIfStringHasMoreThanOneDecimal(assignvalString);
    }
  } else {
    tempDecimal = false;
  }

  String assignvalS = assignval.toString();

  if (assignvalS == "" && assignvalS != "^") {
    return "$nameofField cannot be Empty";
  } else if (assignvalS == "null") {
    return null;
  } else if (assignvalS.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,<>\/?]')) ||
      assignvalS.contains(RegExp(r"[']")) ||
      assignvalS.contains(RegExp(r"[a-z,A-Z]"))) {
    if (assignvalS != "^") {
      return "$nameofField is an invalid number";
    }
  } else if (tempDecimal == true) {
    return "$nameofField is an invalid number";
  }
  // else{return null;}
}

bool? funcValEmptyOrNumberBool(assignval) {
  // print("assignval = $assignval");
  bool tempDecimal = false;

  String assignvalString = assignval == null ? "" : assignval.toString();

  if (assignvalString != null) {
    if (assignvalString.length == 1) {
      tempDecimal = false;
    } else {
      tempDecimal = funcChkIfStringHasMoreThanOneDecimal(assignvalString);
    }
  } else {
    tempDecimal = false;
  }
  //-------------------------------------
  if (assignvalString == "" && assignvalString != "^") {
    return true;
  } else if (assignvalString == null) {
    return true;
  } else if (assignvalString.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,<>\/?]')) ||
      assignvalString.contains(RegExp(r"[']")) ||
      assignvalString.contains(RegExp(r"[a-z,A-Z]"))) {
    if (assignvalString != "^") {
      return true;
    }
  } else if (tempDecimal == true) {
    return true;
  } else {
    return false;
  }
}

String? funcValEmptyOnly(assignval, nameofField) {
  if (assignval == "" && assignval != "^") {
    return "$nameofField cannot be empty";
  } else {
    return null;
  }
}

//__________________________________________________ String Validation Functions Closed _________________________________________________________________________

//__________________________________________________ Function to check balance fees _____________________________________________________________________________
double functoChkBalFee(totalfees, listofFeesTotal, feenum) {
  double tempTotalofSubFees = 0;
  double tempBalanceFees = 0;
  for (int i = 3; i < listofFeesTotal[feenum].length; i++) {
    if (listofFeesTotal[feenum][i][1] != "^") {
      double? tempSubFeeAmount = double.tryParse(listofFeesTotal[feenum][i][1]);
      tempSubFeeAmount = tempSubFeeAmount ?? 0;
      tempTotalofSubFees = tempTotalofSubFees + tempSubFeeAmount;
    }
  }
  double tempTotalFees = 0;
  if (totalfees != "^" || totalfees != null) {
    tempTotalFees = double.tryParse(totalfees) ?? 0;
  } else {
    tempTotalFees = 0;
  }

  tempBalanceFees = tempTotalFees - tempTotalofSubFees;
  // print("tempBalanceFees = $tempBalanceFees");
  return tempBalanceFees;
}
//__________________________________________________ Function to check balance fees Closed _________________________________________________________________________

//________________________________________________    Function to check more than 1 decimal ________________________________________________________________________

bool funcChkIfStringHasMoreThanOneDecimal(abc) {
  if (abc != null) {
    int tempCount = 0;
    List<String> xyz = abc.split("");
    for (var i in xyz) {
      if (i == ".") {
        tempCount = tempCount + 1;
      }
    }
    if (tempCount > 1) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}

double funRightPadding(e) {
  if (e == 0) {
    return 150;
  } else {
    return 20;
  }
  // return 150;
}

//________________________________________________ Function to get List of Subject Names ____________________________________________________________________________
Widget funcGetSubjectList(v) {
  if (v.length > 1) {
    List<Widget> subjectNamesWig = [];
    Widget columoofSubjects = Column(
      children: subjectNamesWig,
    );

    for (var i in v) {
      subjectNamesWig.add(Text(i["subject_name"].toString()));
    }
    ;
    return columoofSubjects;
  } else {
    return Text("-");
  }
}

//________________________________________________ Function to get Class from Div Data ____________________________________________________________________________
List<dynamic> funcGetClassAndAcadYrFromDiv() {
  List<dynamic> acadYr = [];
  List<dynamic> classfromDiv = [];
  // print(divData![0][0]);
  // divData!.forEach((i) {});
  for (int i = 0; i < divData!.length; i++) {
    acadYr.add(divData![i][0]["academic_year"]["year"].toString());
    classfromDiv.add(divData![i][0]["std"]["standard_name"].toString());
  }
  //------------- Sorting AcadYrs and putting them in a Map Datatype --------------
  Map<int, int> tempAcadYrInt = {};
  for (int k = 0; k < acadYr.length; k++) {
    List<String> _tempAcadYr = acadYr[k].split("-");
    print("_tempAcadYr = $_tempAcadYr");
    tempAcadYrInt[k] = int.parse(_tempAcadYr[0]);
  }
  //----------- dummy Data --------------
  // tempAcadYrInt[1] = 2018;
  // tempAcadYrInt[2] = 2021;
  // tempAcadYrInt[3] = 2017;
  // classfromDiv.add("ukg");
  // classfromDiv.add("3rd");
  // classfromDiv.add("Lkg");
  // print(tempAcadYrInt);
  // print(classfromDiv);
  //------- dummy Data Closed -----------
  final sortedAcadYr = SplayTreeMap.from(tempAcadYrInt, (key1, key2) => tempAcadYrInt[key1]!.compareTo(tempAcadYrInt[key2]!));
  print(sortedAcadYr.lastKey());
  //------------- getting current class --------------
  String currentClass = classfromDiv[int.parse(sortedAcadYr.lastKey().toString())];
  var currentClassJson = {"currentClass": currentClass};
  List<dynamic> listtoReturn = [sortedAcadYr, currentClassJson];
  print(listtoReturn);
  return listtoReturn;
}

//________________________________________________ Function to get Class from Div to which admitted ____________________________________________________________________________
List<String> funcGetAdmittedClassAnddiv() {
  int? firstYearofAdmission;
  int? LastYearofAdmission;
  String firstDivOfAdmission;
  String firstClassOfAdmission;
  String firstAcadYrOfAdmission;
  String lastDivOfAdmission;
  String lastClassOfAdmission;
  String lastAcadYrOfAdmission;

  List<String> dataToReturn = [];

  if (divList!.length >= 1) {
    List<int> _temdivList = [];
    divList!.forEach((element) {
      List<String> _tempsplitone = element.split(" ");
      List<String> _tempsplit = _tempsplitone[2].split("-");

      String yeartoaddOne = _tempsplit[0];
      String yeartoadd = yeartoaddOne.substring(1, 5);
      _temdivList.add(int.parse(yeartoadd));
    });
    _temdivList.sort();
    firstYearofAdmission = _temdivList.first;
    LastYearofAdmission = _temdivList.last;
  }
  // else if (divList!.isNotEmpty && divList!.length == 1){
  //   List<int> _temdivList = [];
  //   _temdivList = int.parse(divList![0].split("-")[0]) as List<int>;
  //   firstYearofAdmission = _temdivList[0];
  //   LastYearofAdmission = _temdivList[0];
  // }
  else {
    firstYearofAdmission = null;
    LastYearofAdmission = null;
  }
  print("divList = $divList");
  print("firstYearofAdmission  = $firstYearofAdmission");
  print("LastYearofAdmission = $LastYearofAdmission");

  divList!.forEach((element) {
    List<String> toCheckSplit = element.split(" ");
    List<String> toCheckSplittwo = toCheckSplit[2].split("-");
    String tocheck = toCheckSplittwo[0].substring(1, 5);
    if (tocheck.contains(firstYearofAdmission.toString())) {
      firstDivOfAdmission = element;
      List<String> _divSplit = element.split(" ");
      firstClassOfAdmission = _divSplit[0];
      firstAcadYrOfAdmission = _divSplit[2];
      dataToReturn.add(firstDivOfAdmission);
      dataToReturn.add(firstClassOfAdmission);
      dataToReturn.add(firstAcadYrOfAdmission);
    }
  });

  divList!.forEach((element) {
    List<String> toCheckSplit = element.split(" ");
    List<String> toCheckSplittwo = toCheckSplit[2].split("-");
    String tocheck = toCheckSplittwo[0].substring(1, 5);

    if (tocheck.contains(LastYearofAdmission.toString())) {
      lastDivOfAdmission = element;
      List<String> _lastdivSplitLast = element.split(" ");
      lastClassOfAdmission = _lastdivSplitLast[0];
      lastAcadYrOfAdmission = _lastdivSplitLast[2];
      dataToReturn.add(lastDivOfAdmission);
      dataToReturn.add(lastClassOfAdmission);
      dataToReturn.add(lastAcadYrOfAdmission);
    }
  });

  print("dataToReturn = $dataToReturn");
  return dataToReturn;
}

//-------------------------------------------------- Filtered Search ------------------------------------------------------------------------------------------

bool functoenableStudentNamefilteredSearch() {
  if (acadYrFilteredSearch == null && classFilteredSearch == null && divisionFilteredSearch == null) {
    return true;
  } else {
    return false;
  }
}

//-------------------------------------------------- GET DATA ------------------------------------------------------------------------------------------

//-------- GetData Universal for Student-------------
Future<List<String>> getDataUniversalForStudent({filter, postlink, keytosend}) async {
  getdataStudentsNames_responseBodyJSON =
      await httpPost(destinationUrl: mainDomain, destinationPort: 8080, destinationPost: "/addStudent/$postlink", msgToSend: {keytosend: filter});
  var getdataStudentsNamesResponseBody = await json.decode(await getdataStudentsNames_responseBodyJSON!);
  print(await getdataStudentsNamesResponseBody["msg"][1]);
  List<String> toStringList = [];
  await getdataStudentsNamesResponseBody["msg"].forEach((v) {
    toStringList.add(v.toString());
  });
  return await toStringList;
}

//-------- GetData Really Universal -------------
Future<List<String>> getDataUniversal({filter, postlink, keytosend}) async {
  var getdata_responseBodyJSON =
      await httpPost(destinationUrl: mainDomain, destinationPort: 8080, destinationPost: postlink, msgToSend: {keytosend: filter});
  var getdataResponseBody = await json.decode(await getdata_responseBodyJSON);
  // print(await getdataResponseBody["msg"][1]);
  List<String> toStringList = [];
  await getdataResponseBody["msg"].forEach((v) {
    toStringList.add(v.toString());
  });
  return await toStringList;
}

//-------- GetData for Div -------------
Future<List<String>> funcGetSortedDivs(filter) async {
  List<String> fullListOfDiv = await getDataUniversalForStudent(filter: filter, postlink: "studentdiv", keytosend: "studentdiv");
  List<String> finallisttoSend = [];

  if (acadYrFilteredSearch != null && classFilteredSearch != null) {
    for (var i in fullListOfDiv) {
      if (i.contains(acadYrFilteredSearch!) && i.contains(classFilteredSearch!)) {
        finallisttoSend.add(i);
      }
    }
    return finallisttoSend;
  } else if (acadYrFilteredSearch != null && classFilteredSearch == null) {
    for (var i in fullListOfDiv) {
      if (i.contains(acadYrFilteredSearch!)) {
        finallisttoSend.add(i);
      }
    }
    return finallisttoSend;
  } else if (acadYrFilteredSearch == null && classFilteredSearch != null) {
    for (var i in fullListOfDiv) {
      if (i.contains(classFilteredSearch!)) {
        finallisttoSend.add(i);
      }
    }
    return finallisttoSend;
  } else {
    return fullListOfDiv;
  }
}

//-------- GetData Division-------------
Future<List<String>> getDatadivision(filter) async {
  getdataDivision_responseBodyJSON = await httpPost(
      destinationUrl: mainDomain, destinationPort: 8080, destinationPost: "/addDivision/divisionsGetData", msgToSend: {"division_name": filter});
  var getdataDivisionResponseBody = await json.decode(await getdataDivision_responseBodyJSON!);
  // print(await getdataDivision_responseBody["msg"][1]);
  List<String> toStringList = [];
  await getdataDivisionResponseBody["msg"].forEach((v) {
    toStringList.add(v.toString());
  });

// print("toStringList = $toStringList");
//   divList!.forEach((e) {
//     List<String> _tempSplitofE = e.split(" ");
//     String _tempAcadYear = _tempSplitofE[2];
//
//     List<String> listToRemove = [];
//     toStringList.forEach((b) {
//       b.toString().contains(_tempAcadYear);
//       listToRemove.add(b);
//     });
//     listToRemove.forEach((c) {
//       toStringList.remove(c);
//     });
//   });
//
//
  print("toStringList = $toStringList");
  return await toStringList;
}

Future<dynamic> getStudentDiscountDataDetials(_tempDiscounts) async {
  var _data = await httpPost(
      destinationUrl: mainDomain,
      destinationPort: 8080,
      destinationPost: "/addStudent/studentDiscountData",
      msgToSend: {"msg": "Send Discount Data", "studentID":edit_ID});

 var decodedData = await json.decode(await _data);
 print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
 print('decodedData["student_discount"] = ${decodedData["allstudentFound"]["student_discount"]}');
  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
  for(var _k in decodedData["allstudentFound"]["student_discount"]){
    print("_k = $_k");
    print('[_k["acadyr"] = ${_k["acadyr"]}');print('[_k["acadyr"] = ${_k["discount_amount"]}');
    _tempDiscounts.add([_k["acadyr"], _k["discount_amount"]]);
  }
}



Future<dynamic> getDatadivisionDataDetials(listOfDiv) async {
  getdataDivision_responseBodyJSON = await httpPost(
      destinationUrl: mainDomain,
      destinationPort: 8080,
      destinationPost: "/addDivision/divisionsGetDataDetials",
      msgToSend: {"division_names": listOfDiv});
  var getdataDivisionResponseBody = await json.decode(await getdataDivision_responseBodyJSON!);
  var toDynamicList = [];
  await getdataDivisionResponseBody["msg"].forEach((v) {
    toDynamicList.add(v);
  });

  return await toDynamicList;
}

//____________________________________ Function if else widget return ------------------------

Widget funcIfElseWidgetReturnTrue(boolVar, widgetToReturn) {
  if (boolVar == true) {
    return widgetToReturn;
  } else {
    return Container();
  }
}

Widget funcIfElseWidgetReturnFalse(boolVar, widgetToReturn) {
  if (boolVar == false) {
    return widgetToReturn;
  } else {
    return Container();
  }
}

//-------------------------- MAke all Vars null -------------------------------------------

funcMakeVarNullStudents() {
  //-----------Nulling All Vars---------------------
  studentFirstNameAdd = null;
  studentLastNameAdd = null;
  fathersNameAdd = null;
  mothersNameAdd = null;
  guardiansNameAdd = null;
  addressNameAdd = null;
//---- Father's ----------
  fathersPhoneNoEXT = "+91";
  fathersPhoneNoMain = null;

  fathersPhoneNofisttime = true;
//---- Mother's ----------
  mothersPhoneNoEXT = "+91";
  mothersPhoneNoMain = null;

  mothersPhoneNofisttime = true;
//---- Guardian's ----------
  guardiansPhoneNoEXT = "+91";
  guardiansPhoneNoMain = null;

  guardiansPhoneNofisttime = true;

  studentNameAdd = "$studentFirstNameAdd $fathersNameAdd $studentLastNameAdd";

  gender = "Male";

  studentID = null;

  grNumber = null;
  grNumberAddfirstTime = true;

  nationalityNameAdd = null;
  motherTongueNameAdd = null;

//------------------------------------
  userNameAdd = null;
  initialValueUserName = null;
  usernameErrorString = null;

  passwordAdd = null;
  passwordErrorString = null;
  passwordnotTyped = true;
  initialValuePassword = null;

  siblingsList!.clear();

//------------- Aadhar -----------------------
  aadharNumberAdd = null;
  aadharNumberAddfirstTime = true;

//------------- First Class -----------------------
  firstNlastClassDetials.clear();
  firstAcadYr = null;
  firstClass = null;
  firstDiv = null;

//------------- Last Class -----------------------
  lastAcadYr = null;
  lastClass = null;
  lastDiv = null;

  //------------- Religion -----------------------
  religionAdd.clear();
  religionAddasStringList = [Status.dropdown];

//------------- Caste -----------------------
  casteListAdd.clear();
  casteAddasStringList = [Status.dropdown];

//------------- SubCaste -----------------------
  subcasteListAdd.clear();
  subcasteAddasStringList = [Status.dropdown];

//------------- Different Abeled -----------------------
  differentlyAbledListAdd.clear();
  differentlyAbledAddasStringList = [Status.dropdown];
  differentlyAbledBool = false;
  rTE = false;
  enableStatus = true;
  inSchool = true;

//------------- Date of Birth -----------------------

//------------- Place of Birth -----------------------
  placeOfBirthAddVillageorCity = null;
  placeOfBirthAddTaluka = null;
  placeOfBirthAddDistrict = null;
  placeOfBirthAddState = null;
  placeOfBirthAddCountry = null;

//------------- Last School Attended -----------------------
  lastSchoolAttended = null;
  lastSchoolStandardAttended = null;
  uDISEpreviousSchool = null;
  uDISEpreviousSchoolAddfirstTime = true;

//--------------- Date Of Admission -----------------------
  selectedDateofAdmission.clear();
  selectedSchoolLeavingDate.clear();
  selectedDateofBirth.clear();
  selectedDateofAdmission.add(DateTime.now());
  selectedSchoolLeavingDate.add(DateTime.now());
  selectedDateofBirth.add(DateTime.now());
//--------------- Leaving ---------------------------------
  progressAdd = null;
  conductAdd = null;
  reasonForLeavingAdd = null;

  divList!.clear();
  divData = null;
  acadYearNClassAdd = null;
  currentDivision = null;
  refDivGetter = true;
}

//-------------------------- Generate Random UserName -------------------------------------------

// Future<String>
funcToGenerateRandomUserName(lengthofRandomString) async {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  bool isValidUserName = false;
  String? finalStringtoSend;

  while (isValidUserName == false) {
    print("inWhile");
    String stringtoCheck = getRandomString(lengthofRandomString);
    print(stringtoCheck);
    String approvedUserName = await httpPost(
        destinationUrl: "techifythat.com",
        destinationPort: 8080,
        destinationPost: "/addStudent/checkUserNameValidity",
        msgToSend: {"student_username": stringtoCheck});

    bool _tempBool = approvedUserName == 'UserName is New' ? true : false;

    print(_tempBool);
    isValidUserName = _tempBool;
    if (isValidUserName == true) {
      finalStringtoSend = stringtoCheck;
    }
  }

  print(finalStringtoSend);
  initialValueUserName = finalStringtoSend!;
  // return finalStringtoSend!;
}

functionToCheckValidUserName(un) async {
  String approvedUserName = await httpPost(
      destinationUrl: "techifythat.com",
      destinationPort: 8080,
      destinationPost: "/addStudent/checkUserNameValidity",
      msgToSend: {"student_username": un});
  usernameErrorString = approvedUserName == 'UserName Alread Exists' ? 'UserName Alread Exists' : null;
}

functionToCheckPassword(pw) async {
  if (pw == "" || pw == null) {
    passwordErrorString = "Password Cannot be Empty";
  } else {
    if (pw.length < 8) {
      passwordErrorString = "Min 8 char";
    } else {
      if (pw.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,<>\/?]')) == false ||
          pw.contains(RegExp(r"[!@#$%^&*()_+\-=\[\]{};:'\\|,<>\/?]")) == false) {
        passwordErrorString = "Missing special char";
      } else if (pw.contains(RegExp(r"[a-z]")) == false) {
        passwordErrorString = "Missing lower case char";
      } else if (pw.contains(RegExp(r"[A-Z]")) == false) {
        passwordErrorString = "Missing upper case char";
      } else if (pw.contains(RegExp(r"[0-9]")) == false) {
        passwordErrorString = "Missing number";
      } else {
        passwordErrorString = null;
      }
    }
  }
}

String functionPasswordGenerator() {
  const _charsa = 'abcdefghijklmnopqrstuvwxyz';
  const _charsA = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const _chars1 = '1234567890';
  const _charsSC = '!@#\$%^&*()_+-=[]{};:"\\|,<>/?';
  Random _rnd = Random();
  List<String> generatedList = [];
  String a1 = String.fromCharCodes(Iterable.generate(2, (_) => _charsa.codeUnitAt(_rnd.nextInt(_charsa.length))));
  String A1 = String.fromCharCodes(Iterable.generate(2, (_) => _charsA.codeUnitAt(_rnd.nextInt(_charsA.length))));
  String num1 = String.fromCharCodes(Iterable.generate(2, (_) => _chars1.codeUnitAt(_rnd.nextInt(_chars1.length))));
  String sC1 = String.fromCharCodes(Iterable.generate(2, (_) => _charsSC.codeUnitAt(_rnd.nextInt(_charsSC.length))));
  String a2 = String.fromCharCodes(Iterable.generate(2, (_) => _charsa.codeUnitAt(_rnd.nextInt(_charsa.length))));
  String A2 = String.fromCharCodes(Iterable.generate(2, (_) => _charsA.codeUnitAt(_rnd.nextInt(_charsA.length))));
  String num2 = String.fromCharCodes(Iterable.generate(2, (_) => _chars1.codeUnitAt(_rnd.nextInt(_chars1.length))));
  String sC2 = String.fromCharCodes(Iterable.generate(2, (_) => _charsSC.codeUnitAt(_rnd.nextInt(_charsSC.length))));
  generatedList.add(a1);
  generatedList.add(a2);
  generatedList.add(A1);
  generatedList.add(A2);
  generatedList.add(num1);
  generatedList.add(num2);
  generatedList.add(sC1);
  generatedList.add(sC2);
  generatedList.shuffle();
  String stringToReturn = generatedList.join();
  return stringToReturn;
}

String funcToGetAcadYrFromDiv(div) {
  List<String> splitDiv = div.split(" ");
  String acadYr = splitDiv[2].substring(1, 10);
  return acadYr;
}

String funcToGetClassFromDiv(div) {
  List<String> splitDiv = div.split(" ");
  String standardFromDiv = splitDiv[0];
  return standardFromDiv;
}

Future<double> funcToGetMainFeeTotalFees(div) async {
  List<dynamic> _divData = await getDatadivisionDataDetials([div]);
  double _totalFees = double.parse(_divData[0][0]["fees"]["main_fees"][0]["total_fees"].toString());
  debugMode == false ? null : print("_totalFees = $_totalFees");
  return _totalFees;
}

double funcCalculatePendingFees(totalAmount) {
  double totalAmountfromInstallments = 0;
  print("customInstallmentAmount = $customInstallmentAmount");
  customInstallmentAmount.forEach((e) {
    double _amount = double.parse(e);
    totalAmountfromInstallments = totalAmountfromInstallments + _amount;
  });
  double pendingAmount = 0;
  pendingAmount = totalAmount - totalAmountfromInstallments;
  return pendingAmount;
}

//---------------------------------------- Validity Function for Installments -----------------------------------------

String? funcValidPendingAmount(pendingAmount) {
  if (pendingAmount != 0) {
    return "Pending Amount Should be 0";
  } else {
    return null;
  }
}

String? funcValidInstallmentAmount(listofAmount) {
  if (listofAmount != null) {
    List<String?> _errorText = [];
    for (var i in listofAmount) {
      print("i = $i");
      if (i != "0") {
        _errorText.add(funcValEmptyOrNumber(i, "Installment Amount"));
      } else {
        _errorText.add("Installment Amount cannot be 0");
      }
    }
    print("_errorText = $_errorText");
    bool _isValid = false;
    int? installmentnumb;
    for (int e = 0; e < _errorText.length; e++) {
      print("@@@@@@@@@@@@@@@@@@@@@@@ ${_errorText[e]} @@@@@@@@@@@@@@@");
      if (e != null) {
        _isValid = false;
        installmentnumb = e;
      } else {
        _isValid = true;
      }
    }
    if (_isValid == false) {
      return _errorText[installmentnumb!];
    } else {
      return null;
    }
  } else {
    return "Installment Amount cannot be empty";
  }
}

//-------------------------------- Function to add Discount Sub Wigs to List of Discount Wigs -------------------------------------------------------------
functomakeListofDiscountWigs() {

  if (divList != null) {
    listofDiscountsWigs.clear();
    listofDiscountsWigsMAP.clear();
    fINALlistofDiscountsWigs.clear();
    int _c = 0;
    for (String i in divList!) {
      List<String> _tempDiv = i.split(" ");
      String _tempacadYr = _tempDiv[2].substring(1, 10);
      listofDiscountsWigs.add(DiscountWigSub(
        divName: i,
        title: divData![_c][0]["fees"]["main_fees"][0]["fee_title"].toString(),
        amount: divData![_c][0]["fees"]["main_fees"][0]["total_fees"].toString(),
      ));
      listofDiscountsWigsMAP.add({"acadyr": _tempacadYr, "discount_amount": "0", "discount_percentage": "0"});
      List<Widget> _tempListofWigs = [];
      // for (var o in divData!) {
      //   if (o[0]["division_name"] == i) {
      //     for (var k in o[0]["fees"]["extra_fee"]) {
      //       String _extra_fee_title = k["extra_fee_title"];
      //       String _extra_total_fee = k["extra_total_fee"].toString();
      //       _tempListofWigs.add( Column(
      //         children: [
      //           DiscountSubE(divName: i, title: _extra_fee_title, amount: double.parse(_extra_total_fee)),
      //           Divider(),
      //         ],
      //       ));
      //       listofDiscountsWigsMAP_EXTRA
      //           .add({"acadyr": _tempacadYr, "discount_fee_title": _extra_fee_title, "discount_amount": "0", "discount_percentage": "0"});
      //     }
      //   }
      // }
      // listofDiscountsWigsEXTRA.add(_tempListofWigs);
      _c++;
    }
    if (listofDiscountsWigs.isNotEmpty) {
      for (int j = 0; j < divList!.length; j++) {
        Widget _tempWidget = Card(
          child: Column(
            children: [
               Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Main Fee for Div: ${divList![j]}"),
              ),
              listofDiscountsWigs[j],
              // Divider(),
              // Column(
              //   children: [
              //    Padding(
              //       padding: EdgeInsets.all(8.0),
              //       child: Text("Extra Fee for Div: ${divList![j]}"),
              //     ),
              //     Column(
              //       children: listofDiscountsWigsEXTRA[j],
              //     ),
              //   ],
              // )
            ],
          ),
        );
        fINALlistofDiscountsWigs.add(_tempWidget);

      }
    }
  } else {
    divList!.clear();
    listofDiscountsWigs.clear();
    listofDiscountsWigsMAP.clear();
    fINALlistofDiscountsWigs.clear();
  }
  print("divList = $divList");
  print("fINALlistofDiscountsWigs = $fINALlistofDiscountsWigs");
  print("listofDiscountsWigs = $listofDiscountsWigs");
  print("listofDiscountsWigsMAP = $listofDiscountsWigsMAP");
}

funcSortDivList(divList){
  print("Before = $divList");
  List<String> tempdivList = [];
  divList.forEach((v){
    tempdivList.add(v);
  });
  divList.clear();
  Map<int,String> tempdivListOne = {};
  Map<int,String> tempdivListTwo = {};
  for(int p = 0 ; p < tempdivList.length; p++){
    String divToWorkOn = tempdivList[p];
    tempdivListOne[p] = divToWorkOn;
    String _acadYR = divToWorkOn.split(" ")[2].split("-")[0];
    tempdivListTwo[p] = _acadYR;
  }
  Map<int,String>tempdivListTwoSorted = Map.fromEntries(
      tempdivListTwo.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)));
  tempdivListTwoSorted.forEach((k,v){
    divList.add(tempdivListOne[k]);
  });
  print("After = $divList");
}

functomakeListofDiscountWigsINIT(initAmt) {

  if (divList != null) {
    funcSortDivList(divList);
    listofDiscountsWigs.clear();
    listofDiscountsWigsMAP.clear();
    fINALlistofDiscountsWigs.clear();
    List<String> tempAllDivListVal = [];
    initAmt.forEach((e) {
      tempAllDivListVal.add(e[0]);
    });


    int _c = 0;
    for (String i in divList!) {
      List<String> _tempDiv = i.split(" ");
      String _tempacadYr = _tempDiv[2].substring(1, 10);

      String _title = divData![_c][0]["fees"]["main_fees"][0]["fee_title"].toString();
      String _amount = divData![_c][0]["fees"]["main_fees"][0]["total_fees"].toString();
      String _divActive = i;

      print("_title = $_title "
          "_amount = $_amount"
          "_divActive  = $_divActive");
      print("initAmt = $initAmt");


      if(tempAllDivListVal.contains(i.split(" ")[2].substring(1,10))){
      for(var u in initAmt){

        if(u[0] == i.split(" ")[2].substring(1,10)){
          print("u[1].toString() = ${u[1].toString()}");
          listofDiscountsWigs.add(DiscountINITWigSub(
              divName: i,
              title: divData![_c][0]["fees"]["main_fees"][0]["fee_title"].toString(),
              amount: divData![_c][0]["fees"]["main_fees"][0]["total_fees"].toString(),
              initAmount:  u[1].toString()
          ));

          String tempAmt = divData![_c][0]["fees"]["main_fees"][0]["total_fees"].toString();
          double perTempAmt = double.parse(u[1].toString())/double.parse(tempAmt.toString())*100;
          listofDiscountsWigsMAP.add({"acadyr": _tempacadYr, "discount_amount": u[1].toString(), "discount_percentage": perTempAmt.toString()});
        }
      }}
      if (tempAllDivListVal.contains(i.split(" ")[2].substring(1,10)) == false) {
        listofDiscountsWigs.add(DiscountWigSub(
          divName: i,
          title: divData![_c][0]["fees"]["main_fees"][0]["fee_title"].toString(),
          amount: divData![_c][0]["fees"]["main_fees"][0]["total_fees"].toString(),
        ));
        listofDiscountsWigsMAP.add({"acadyr": _tempacadYr, "discount_amount": "0", "discount_percentage": "0"});
      }
      _c++;
    }
    if (listofDiscountsWigs.isNotEmpty) {
      for (int j = 0; j < divList!.length; j++) {
        Widget _tempWidget = Card(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Main Fee for Div: ${divList![j]}"),
              ),
              listofDiscountsWigs[j],

            ],
          ),
        );
        fINALlistofDiscountsWigs.add(_tempWidget);

      }
    }
  } else {
    divList!.clear();
    listofDiscountsWigs.clear();
    listofDiscountsWigsMAP.clear();
    fINALlistofDiscountsWigs.clear();
  }
  print("divList = $divList");
  print("fINALlistofDiscountsWigs = $fINALlistofDiscountsWigs");
  print("listofDiscountsWigs = $listofDiscountsWigs");
  print("listofDiscountsWigsMAP = $listofDiscountsWigsMAP");
}

//
// List<String>  funcdivList(){
//   functomakeListofDiscountWigsINIT();
//   return divList!;
// }


//----------------------------------- EXCEL to JSON -------------------------

Future<String> excelToJson() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xls', 'xlsx', 'csv']);
  // print("result = $result");
  var excelFile;
  if (result != null && result.files.isNotEmpty) {
    excelFile = result.files.first.bytes!;
  }
  print("excelFile = ${excelFile.runtimeType}");


  // var bytes = excelFile!.readAsBytesSync();

  //-------------------------------------------
  var excel = Excel.decodeBytes(excelFile);
  print("excel = ${excel.tables.keys}");
  int i = 0;
  List<dynamic> keys = [];
  var jsonMap = [];

  for (var table in excel.tables.keys) {
    // dev.log(table.toString());
    for (var row in excel.tables[table]!.rows) {
      // dev.log(row.toString());
      print("row = ${row.runtimeType}");
      List<String> tempRow = [];
      row.forEach((e) {
        print("e = $e");
        if (e == null) {
          tempRow.add("");
        } else {
          tempRow.add(e.value.toString());
        }
      });

      if (i == 0) {
        keys = tempRow;
        i++;
      } else {
        var temp = {};
        int j = 0;
        String tk = '';
        for (var key in keys) {
          tk = '\"${key.toString()}\"';
          temp[tk] = (tempRow[j].runtimeType == String)
              ? '\"${tempRow[j].toString()}\"'
              : tempRow[j];
          j++;
        }

        jsonMap.add(temp);
      }
    }
  }
  // dev.log(
  //   jsonMap.length.toString(),
  //   name: 'excel to json',
  // );
  // dev.log(jsonMap.toString(), name: 'excel to json');
  jsonMap.removeRange(0, 1);
  String fullJson =
  jsonMap.toString().substring(1, jsonMap
      .toString()
      .length - 1);
  // dev.log(
  //   fullJson.toString(),
  //   name: 'excel to json',
  // );
  // print("fullJson = $fullJson");
  // Map<dynamic,dynamic> mapFullJson = {};
  // List<String> splitOneFullJson = fullJson.split("},");
  // splitOneFullJson.forEach((el) {el.replaceAll("}", ""); });
  // splitOneFullJson.forEach((el) {el.replaceAll("{", ""); });
  // print("splitOneFullJson = $splitOneFullJson");
  // splitOneFullJson.forEach((element) {
  //   List<String> splitFullJson = element.split(",");
  //   splitFullJson.forEach((e){
  //     String keyf = e.split(":")[0] == null ? "":e.split(":")[0];
  //     String valf = e.split(":").length < 2 ? "": e.split(":")[1] == null ? "":e.split(":")[1];
  //     mapFullJson[keyf] = valf;
  //   });
  // });

String finalfullJson  = "[$fullJson]";








 // Map<String,dynamic> finalone = funcStrtoJson(fullJson);
  //-------------------------------------------
  // String fullJson = bString;
// print("fullJson = $finalfullJson");
// print("mapFullJson = $mapFullJson");
// print("finalone = $finalone");
  return finalfullJson;
}