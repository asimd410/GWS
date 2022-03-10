import 'package:flutter/material.dart';

String mainDomain = "techifythat.com";

//_______________________________ Class _______________________________________________
String? createClass_responseBody;
String? showClass_responseBodyJSON;
var showClass_responseBody;
//_______ Edit ________
String? editClass_responseBody;
String? editshowClass_responseBodyJSON;
var editShowClass_responseBody;
String? editClassToEdit;
String? editClassToSave;
bool? showEditClass = false;

//_____ Del_____________
String? deleteClass_responseBody;
bool delClass = false;
String? deleteClass_id;
String? deleteClass;

//_______________________________User Name_______________________________________________

String userName = "User";

//___________________________ACAD YR___________________________________________________
String? createAcadYr_responseBody;
String? showAcadYr_responseBodyJSON;
var showAcadYr_responseBody;
//-------- EDIT-----------------
String? editAcadYr_responseBody;
String? editshowAcadYr_responseBodyJSON;
var editShowAcadYr_responseBody;
bool showEditAcadYr = false;
String? editAcadYrFromAndTo;
String? editAcadYrFrom;
String? editAcadYrTo;
//-------- EDIT Closed-----------------
//-------- DELETE ------------------------
String? deleteAcadYr_responseBody;
bool delAcadYr = false;
String? deleteAcadYr_id;
String? deleteAcadYrYear;
//-------- DELETE Closed -----------------

//____________________________ Subject __________________________________________________

String? createSubject_responseBody;
String? showSubject_responseBodyJSON;
var showSubject_responseBody;

//_________________ Edit _________________
String? editSubject_responseBody;
String? editshowSubject_responseBodyJSON;
var editShowSubject_responseBody;
String? editSubjectToEdit;
String? editSubjectToSave;
bool? showEditSubject = false;

//________________ Delete ________________
String? deleteSubject_responseBody;
bool delSubject = false;
String? deleteSubject_id;
String? deleteSubject;

//________________________________ Division ______________________________________________

String? createDivision_responseBody;
String? showDivision_responseBodyJSON;
var showDivision_responseBody;

//_______ EDIT ___________
String? editDivision_responseBody;
String? editshowDivision_responseBodyJSON;
var editShowDivision_responseBody;
bool showEditDivision = false;
String? editDivNameToEdit;

String? editAdmissionFeesToEdit;

String? editDivAcadYrToEdit;

String? editDivClassToEdit;

List<String>? editDivSubjectsToEdit;

String? editDivMainFeeTitleToEdit;

String? editDivMainFeeAmountToEdit;

List<List<dynamic>> editListofMainFeeSubsToEdit = [];
List<dynamic> listOfMainFeesEDIT = [];
List<dynamic> editListofExtraFeesToEdit = [];
String? editIdToEdit;

//_______ DELETE ___________

String? deletDivision_responseBody;
bool delDivision = false;
String? deleteDivision_id;
String? deleteDivisionName;

//----------------------------------- Students ----------------------------------------
String ? getdataStudentsNames_responseBody;
String? getdataStudentsNames_responseBodyJSON;

//----------------------------------- Main VARS ----------------------------------------

double screenWMinus = 0;

double mobileBrkPoint = 1000;

//------------------------------------ Colors--------------------------------------------

Color expansionPanelMainBodyColor = Colors.grey.shade50;
Color containerBorderColor = Colors.black38;

//--------------------------UX Vars-----------------------------------------------------

Color editButtonAll = Colors.blue.shade700;
Color deleteButtonAll = Colors.red;
