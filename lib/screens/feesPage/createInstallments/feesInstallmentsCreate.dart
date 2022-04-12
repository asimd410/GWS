import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';
import 'package:provider/provider.dart';

import '../feeInstallmentList.dart';

var _acadYearData;
String? installmentID;
String? stratingYear;
String? _acadYrinUse;
String? _standardinUse;
String? endingYear;
String? divSelectedFeeInstallment;
String? _startingMonthAcadYr;
int? startingMonthNum;
int? calMonthsStarting;
String? _endingMonthAcadYr;
double? totalFees;
int? endingMonthNum;
int? finalnumofMonths;
bool showNumberOfInstallment = false;
List<Widget> installmentsToShow = [];
int numberofInstallments = 1;
var customInstallmentDateList = [];
List<String> customInstallmentAmount = [];
List<String> customInstallmentDateListString = [];
bool refreshdateInstallments = true;
double? pendingAmount;
bool editInstallments = false;
class FeesInstallments extends StatefulWidget {
  const FeesInstallments({Key? key}) : super(key: key);

  @override
  State<FeesInstallments> createState() => _FeesInstallmentsState();
}

class _FeesInstallmentsState extends State<FeesInstallments> {



  funcToGetDataOfDivFromServer()async{
    //----------- Get Data For the selected Acad Yr -------------
    _acadYrinUse = funcToGetAcadYrFromDiv(divSelectedFeeInstallment);
    _standardinUse = funcToGetClassFromDiv(divSelectedFeeInstallment);
    var _acadYearDataJSON = await httpPost(
        destinationUrl: mainDomain,
        destinationPort: 8080,
        destinationPost: '/feeInstallment',
        msgToSend: {"acadYr": _acadYrinUse});

    _acadYearData = await json.decode(_acadYearDataJSON);

    setState(
          () {
        //----------- Assigning data to variable for starting date -------------
        stratingYear = _acadYearData["year"].split("-")[0];
        _startingMonthAcadYr = _acadYearData["starting_month"];
        startingMonthNum = monthNumerical[_startingMonthAcadYr];
        calMonthsStarting = 13 - startingMonthNum!;

        //----------- Assigning data to variable for Ending date -------------
        endingYear = _acadYearData["year"].split("-")[1];
        _endingMonthAcadYr = _acadYearData["ending_month"];
        endingMonthNum = monthNumerical[_endingMonthAcadYr];

        //----------- Calculating total Months -------------
        finalnumofMonths = calMonthsStarting! + endingMonthNum!;
      },
    );
    totalFees = await funcToGetMainFeeTotalFees(divSelectedFeeInstallment);
    setState(() {
      totalFees = totalFees;
    });

    pendingAmount = funcCalculatePendingFees(totalFees);
    setState(() {
      totalFees = totalFees;
      pendingAmount = pendingAmount;
    });
    installmentsToShow.clear();
    customInstallmentAmount.clear();
    customInstallmentAmount.add("0");
    customInstallmentDateList.clear();
    customInstallmentDateList.add(DateTime.now());
    customInstallmentDateListString.clear();
    DateTime _temptoday = DateTime.now();
    customInstallmentDateListString.add("${_temptoday.day}/${_temptoday.month}/${_temptoday.year}");

    installmentsToShow.add(InstallmentCard(
      installmentNumber: numberofInstallments,
    ));
  }
  funcToGetDataOfDivFromServerEdit()async{
    //----------- Get Data For the selected Acad Yr -------------
    _acadYrinUse = funcToGetAcadYrFromDiv(divSelectedFeeInstallment);
    _standardinUse = funcToGetClassFromDiv(divSelectedFeeInstallment);
    var _acadYearDataJSON = await httpPost(
        destinationUrl: mainDomain,
        destinationPort: 8080,
        destinationPost: '/feeInstallment',
        msgToSend: {"acadYr": _acadYrinUse});

    _acadYearData = await json.decode(_acadYearDataJSON);

    setState(
          () {
        //----------- Assigning data to variable for starting date -------------
        stratingYear = _acadYearData["year"].split("-")[0];
        _startingMonthAcadYr = _acadYearData["starting_month"];
        startingMonthNum = monthNumerical[_startingMonthAcadYr];
        calMonthsStarting = 13 - startingMonthNum!;

        //----------- Assigning data to variable for Ending date -------------
        endingYear = _acadYearData["year"].split("-")[1];
        _endingMonthAcadYr = _acadYearData["ending_month"];
        endingMonthNum = monthNumerical[_endingMonthAcadYr];

        //----------- Calculating total Months -------------
        finalnumofMonths = calMonthsStarting! + endingMonthNum!;
      },
    );
    totalFees = await funcToGetMainFeeTotalFees(divSelectedFeeInstallment);
    setState(() {
      totalFees = totalFees;
    });

    pendingAmount = funcCalculatePendingFees(totalFees);
    // installmentsToShow.clear();
    // customInstallmentAmount.clear();
    // customInstallmentAmount.add("0");
    // customInstallmentDateList.clear();
    // customInstallmentDateList.add(DateTime.now());
    // customInstallmentDateListString.clear();
    // customInstallmentDateListString.add("");
    //
    // installmentsToShow.add(InstallmentCard(
    //   installmentNumber: numberofInstallments,
    // ));
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    editInstallments == false ? funcToGetDataOfDivFromServer(): funcToGetDataOfDivFromServerEdit();

  }

  @override

  @override

  Widget build(BuildContext context) {
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 75.0),
            child: Text("Fee Installments"),
          ),
        ),
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    color:Theme.of(context).primaryColor,
                    width:screenW < 1000 ? screenW : 1000,
                    height: 30,
                    child: Stack(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children:  const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Create Installment Plan", style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Provider.of<Data>(context, listen: false).refInstallmentTablefunc(false);
                                  });
                                  Navigator.pop(context);
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    divSelectedFeeInstallment = null;
                                    stratingYear = null;
                                    _acadYrinUse = null;
                                    _standardinUse = null;
                                    endingYear = null;
                                    divSelectedFeeInstallment = null;
                                    _startingMonthAcadYr = null;
                                    startingMonthNum = null;
                                    calMonthsStarting = null;
                                    _endingMonthAcadYr = null;
                                    totalFees = null;
                                    endingMonthNum = null;
                                    finalnumofMonths = null;
                                    showNumberOfInstallment = false;
                                    installmentsToShow = [];
                                    numberofInstallments = 1;
                                    customInstallmentDateList = [];
                                    customInstallmentAmount = [];
                                    customInstallmentDateListString = [];
                                    refreshdateInstallments = true;
                                    pendingAmount = null;
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
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Card(
                    child: Container(
                      width: screenW < 1000 ? screenW : 1000,
                      height: screenW > 1000 ? 500 : null,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: SizedBox(
                                    width: 200,
                                    child: Text("Division: ${divSelectedFeeInstallment!}"),
                                  ),
                                ), //SELECT DIVISION
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Academic Year From: ${stratingYear ?? "-"} ${_startingMonthAcadYr ?? "-"}"),
                                ), //ACADEMIC YR TO
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Academic Year To: ${endingYear ?? "-"} ${_endingMonthAcadYr ?? "-"}"),
                                ), //ACADEMIC YR FROM
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8, bottom: 30),
                                  child: Text("Total Months: ${finalnumofMonths ?? "-"}"),
                                ), //TOTAL MONTHS
                                Padding(
                                        padding: const EdgeInsets.only(top: 20.0),
                                        child: SizedBox(
                                          width: 300,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text("Nummber Of Installments"), //NUMBER OF INSTALLMENTS
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25.0),
                                                            // side: BorderSide(color: Colors.red)
                                                          ))),
                                                          onPressed: () {
                                                            setState(() {
                                                              numberofInstallments <= 1
                                                                  ? numberofInstallments = 1
                                                                  : setState(() {
                                                                      numberofInstallments--;
                                                                      refreshdateInstallments = !refreshdateInstallments;
                                                                      customInstallmentAmount.remove(customInstallmentAmount.last);
                                                                      customInstallmentDateList.remove(customInstallmentDateList.last);
                                                                      customInstallmentDateListString.remove(customInstallmentDateListString.last);
                                                                      installmentsToShow.remove(installmentsToShow.last);
                                                                    });
                                                              print(numberofInstallments);
                                                            });
                                                          },
                                                          child: const Text(
                                                            "-",
                                                            style: TextStyle(fontSize: 20),
                                                          )),
                                                    ),
                                                  ), //SUBRACT INSTALLMENT BUTTON
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Container(
                                                      width: 50,
                                                      margin: const EdgeInsets.all(15.0),
                                                      padding: const EdgeInsets.all(3.0),
                                                      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                                                      child: Center(
                                                        child: Text(
                                                          numberofInstallments < 1 ? "1" : numberofInstallments.toString(),
                                                          style: TextStyle(fontSize: 15),
                                                        ),
                                                      ),
                                                    ),
                                                  ), //INSTALLMENT COUNT
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: SizedBox(
                                                      height: 50,
                                                      width: 50,
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(25.0),
                                                            // side: BorderSide(color: Colors.red)
                                                          ))),
                                                          onPressed: () {
                                                            setState(() {
                                                              numberofInstallments++;
                                                              refreshdateInstallments = !refreshdateInstallments;
                                                              customInstallmentAmount.add("0");
                                                              customInstallmentDateList.add(DateTime.now());
                                                              customInstallmentDateListString.add("");
                                                              installmentsToShow.add(InstallmentCard(
                                                                installmentNumber: numberofInstallments,
                                                              ));
                                                            });
                                                          },
                                                          child: const Icon(
                                                            Icons.add,
                                                            size: 15,
                                                          )),
                                                    ),
                                                  ), //ADD INSTALLMENT BUTTON
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ) //NUMBER OF INSTALLMENTS ADD SUB
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0, bottom: 8),
                                child: Text(refreshdateInstallments == true ? "Total Fees: ${totalFees??"-"}" : "Total Fees: ${totalFees??"-"}"),
                              ), //TOTAL FEES
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Provider.of<Data>(context, listen: true).refreshInstallmentDate == true
                                    ? Text("Pennding Fees: ${pendingAmount??"-"} ")
                                    : Text("Pennding Fees: ${pendingAmount??"-"}"),
                              ), //PENDING FEES
                              ContainerWithTextLabel(
                                label: "Installments",
                                borderColor: Colors.grey,
                                textBgColor: Colors.white,
                                width: 250,
                                height: 380,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: refreshdateInstallments == true ? installmentsToShow : installmentsToShow,
                                  ),
                                ),
                              ) //CONTAINER FOR INSTALLMENTS
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                    onPressed: () async   {
                                      bool _isValid = true;
                                      //---------- Main Validity Function -----------
                                      funcforValidation(functhatValidates) {
                                        if (functhatValidates != null) {
                                          _isValid = false;
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

                                      //---------- checking Validity -----------
                                      funcforValidation(funcValidPendingAmount(pendingAmount));
                                      funcforValidation(funcValidInstallmentAmount(customInstallmentAmount));

                                      //--------- if valid send request to server ----------------------
                                      if( _isValid == true) {
                                        await httpPost(
                                            destinationUrl: mainDomain,
                                            destinationPort: 8080,
                                            destinationPost: "/feeInstallment/c",
                                            msgToSend: {
                                              "installmentID": installmentID,
                                              "divinUse": divSelectedFeeInstallment,
                                              "acadYrinUse":  _acadYrinUse,
                                              "standardinUse": _standardinUse,
                                              "amountList":customInstallmentAmount,
                                              "duedateList":customInstallmentDateListString,
                                              "updatedBy":userName
                                            });

                                        setState(() {
                                          final snackBar = SnackBar(
                                            content: Text("Installment Plan Has been saved for $divSelectedFeeInstallment"),
                                            backgroundColor: (snackbarSuccessBg),
                                            action: SnackBarAction(
                                              label: 'dismiss',
                                              textColor: snackbarSuccessTxt,
                                              onPressed: () {},
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                        });
                                        Navigator.pop(context);
                                        // divSelectedFeeInstallment = null;
                                        Future.delayed(const Duration(milliseconds: 500), () {
                                          divSelectedFeeInstallment = null;
                                          stratingYear = null;
                                          _acadYrinUse = null;
                                          _standardinUse = null;
                                          endingYear = null;
                                          divSelectedFeeInstallment = null;
                                          _startingMonthAcadYr = null;
                                          startingMonthNum = null;
                                          calMonthsStarting = null;
                                          _endingMonthAcadYr = null;
                                          totalFees = null;
                                          endingMonthNum = null;
                                          finalnumofMonths = null;
                                          showNumberOfInstallment = false;
                                          installmentsToShow = [];
                                          numberofInstallments = 1;
                                          customInstallmentDateList = [];
                                          customInstallmentAmount = [];
                                          customInstallmentDateListString = [];
                                          refreshdateInstallments = true;
                                          pendingAmount = null;
                                        });
                                        setState(() {
                                          Provider.of<Data>(context, listen: false).refInstallmentTablefunc(false);
                                        });

                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("Create Installment Plan"),
                                    )),
                              ),
                              //ONLY CURRENT DIV
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerMAIN(),
    );
  }
}

class ContainerWithTextLabel extends StatelessWidget {
  String label;
  double? height;
  double? width;
  Color borderColor;
  Color textBgColor;
  Widget child;

  ContainerWithTextLabel(
      {required this.child, required this.textBgColor, required this.label, required this.width, required this.height, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: width == null ? double.infinity : width,
          height: height == null ? double.infinity : height,
          margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
          padding: EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(child: child),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(5),
            shape: BoxShape.rectangle,
          ),
        ),
        Positioned(
            left: 50,
            top: 12,
            child: Container(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
              color: textBgColor,
              child: Text(
                label,
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            )),
      ],
    );
  }
}

class InstallmentCard extends StatefulWidget {
  final int installmentNumber;

  InstallmentCard({required this.installmentNumber});

  @override
  State<InstallmentCard> createState() => _InstallmentCardState();
}

class _InstallmentCardState extends State<InstallmentCard> {
  bool _firsttimeinstallmentAmount = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate(BuildContext context, selectedDateVar, final listposition, stratingYear, endingYear) async {
      print("listposition = $listposition");
      final DateTime? pickedDate =
          await showDatePicker(context: context, initialDate: selectedDateVar[listposition], firstDate: DateTime(2010), lastDate: DateTime(2050));
      print("pickedDate = $pickedDate");
      if (pickedDate != null && pickedDate != selectedDateVar[listposition]) {
        print("{pickedDate.day/pickedDate.month/pickedDate.year} = ${pickedDate.day}/${pickedDate.month}/${pickedDate.year}");
        // await selectedDateVar.replaceRange(listposition,listposition+1,[pickedDate]);
        if (selectedDateVar.length < 2) {
          await selectedDateVar.clear();
          await selectedDateVar.add(pickedDate);
          customInstallmentDateListString.clear();
          customInstallmentDateListString.add("${pickedDate.day}/${pickedDate.month}/${pickedDate.year}");
        } else {
          print("b4 selectedDateVar = $selectedDateVar");
          await selectedDateVar.removeAt(listposition);
          await selectedDateVar.insert(listposition, pickedDate);
          print("after selectedDateVar = $selectedDateVar");
          customInstallmentDateListString.removeAt(listposition);
          customInstallmentDateListString.insert(listposition, "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}");
        }

        setState(() {
          selectedDateVar = selectedDateVar;
          print("selectedDateVar = $selectedDateVar");
          refreshdateInstallments = !refreshdateInstallments;

        });
      }
    }

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          child: Container(
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Installment ${widget.installmentNumber}"),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    initialValue: customInstallmentAmount.isNotEmpty ? customInstallmentAmount[widget.installmentNumber - 1]:null,
                    decoration: InputDecoration(
                      labelText: "Installment Amount",
                      errorText: _firsttimeinstallmentAmount == false ? _errorMsg : null,
                      errorMaxLines: 3,
                    ),
                    onChanged: (v) {
                      _firsttimeinstallmentAmount = false;
                      if (funcValEmptyOrNumber(v, "Installment Amount") == null) {
                        customInstallmentAmount.removeAt(widget.installmentNumber - 1);
                        customInstallmentAmount.insert(widget.installmentNumber - 1, v);
                      }
                      setState(() {
                        if(customInstallmentAmount.isNotEmpty){
                          for(int i =0; i < customInstallmentAmount.length;i++){
                            if(customInstallmentAmount[i] == "" || customInstallmentAmount[i] == " " || customInstallmentAmount[i] == null){
                              customInstallmentAmount.removeAt(i);
                              customInstallmentAmount.insert(i, "0");
                            }
                          }
                        }



                        _errorMsg = funcValEmptyOrNumber(v, "Installment Amount");
                        pendingAmount = funcCalculatePendingFees(totalFees);
                        Provider.of<Data>(context, listen: false).refreshInstallmentDatefunc(true);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8, top: 8, bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectDate(context, customInstallmentDateList, widget.installmentNumber - 1, stratingYear, endingYear);
                        print("customInstallmentDateList = $customInstallmentDateList");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Due Date "),
                        Text(
                            "${customInstallmentDateList[widget.installmentNumber - 1].day}/${customInstallmentDateList[widget.installmentNumber - 1].month}/${customInstallmentDateList[widget.installmentNumber - 1].year}"),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    ));
  }
}
