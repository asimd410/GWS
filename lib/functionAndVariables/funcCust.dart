import 'package:flutter/material.dart';
import 'package:gws/screens/classList/divisionCreateView.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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
      print(res.statusCode);
      resBody = res.body;
      return Future.delayed(const Duration(microseconds: 1), () => resBody);
    } else {
      print(res.statusCode);
      return Future.delayed(const Duration(microseconds: 1), () => "");
    }
  } catch (e) {
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
}

// SETTER =   Provider.of<Data>(context, listen: false).refPage(true);

// LISTENER =   Provider.of<Data>(context, listen: true).refrashPage == true;

//__________________________________________________ PROVIDER FUNC Closed _________________________________________________________________________

//__________________________________________________ String Validation Functions _________________________________________________________________________

//Not Empty and only Numbers(infinite)
String? funcValEmptyOrNumber(assignval, nameofField) {
  print("nameofField = $nameofField");
  print("assignval = $assignval");
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
  print("nameofField = $nameofField");
  print("assignval = $assignval");
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
  print("assignval = $assignval");
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
  }
  else {
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
  for (int i = 2; i < listofFeesTotal[feenum].length; i++) {
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
  print("tempBalanceFees = $tempBalanceFees");
  return tempBalanceFees;
}
//__________________________________________________ Function to check balance fees Closed _________________________________________________________________________

bool funcChkIfStringHasMoreThanOneDecimal(abc) {
  print("listOfMainFees[0] =========== ${listOfMainFees[0]}");
  // print("listOfMainFees[0][1 + widget.subdivofMainfeeNumber][2] =========== ${listOfMainFees[0][1 + j][2]}");
  print("ABC =========== $abc");

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
