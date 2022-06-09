import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:provider/provider.dart';

import '../add_student_page.dart';

List<Widget> listofDiscountsWigs = [];
List<Map<String, dynamic>> listofDiscountsWigsMAP = [];
List<List<Widget>> listofDiscountsWigsEXTRA = [];
List<Map<String, dynamic>> listofDiscountsWigsMAP_EXTRA = [];
List<Widget> fINALlistofDiscountsWigs = [];

//-------------------------------- Main Discount Wig --------------------------------------------
class DiscountWig extends StatefulWidget {

  @override
  State<DiscountWig> createState() => _DiscountWigState();
}

class _DiscountWigState extends State<DiscountWig> {
  @override
  Widget build(BuildContext context) {
    print("listofDiscountsWigs = $listofDiscountsWigs ");
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Discount details"),
          ),
          Column(
            children: listofDiscountsWigs.isEmpty
                ? [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Division not Selected Yet",
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                    )
                  ]
                : fINALlistofDiscountsWigs,
          )
        ],
      ),
    );
  }
}

//-------------------------------- Sub Discount Wig --------------------------------------------
class DiscountWigSub extends StatefulWidget {
  final String divName;
  final String amount;
  final String title;

  DiscountWigSub({required this.divName, required this.amount, required this.title});

  @override
  State<DiscountWigSub> createState() => _DiscountWigSubState();
}

class _DiscountWigSubState extends State<DiscountWigSub> {
  bool amtORper = true;
  String discountAmt = "";
  bool discountAmtFirstTime = true;
  String discountPer = "";
  bool discountPerFirstTime = true;

  Widget build(BuildContext context) {
    String tempacadYr = widget.divName.split(" ")[2].substring(1, 10);
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Title: ${widget.title}"),
              ],
            ),
          ),
        ), //TITLE
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text("Amount: ${widget.amount}"),
        ), //AMOUNT
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("%"),
                    Switch(
                        value: amtORper,
                        onChanged: (v) {
                          setState(() {
                            amtORper = !amtORper;
                            print("Switch = $amtORper");

                            if (amtORper == true) {
                              discountAmt = discountPer;
                              if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                                for (var o in divData!) {
                                  if (o[0]["division_name"] == widget.divName) {
                                    double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                                    double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                                    double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Main_Fees) * 100;
                                    discountPer = _temp_discountPercentage.toString();
                                  }
                                }
                                for (var r in listofDiscountsWigsMAP) {
                                  if (r["acadyr"] == tempacadYr) {
                                    r["discount_amount"] = discountAmt.toString();
                                    r["discount_percentage"] = discountPer.toString();
                                  }
                                }
                              } else {
                                discountPer = "";
                              }
                              print("discountPer = $discountPer");
                            } else {
                              discountPer = discountAmt;
                              if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                                for (var o in divData!) {
                                  if (o[0]["division_name"] == widget.divName) {
                                    double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                                    double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                                    double _temp_discountAmount = _temp_total_Main_Fees * _temp_discountPerInt / 100;
                                    discountAmt = _temp_discountAmount.toString();
                                    print("discountAmt = $discountAmt");
                                  }
                                }
                                for (var r in listofDiscountsWigsMAP) {
                                  if (r["acadyr"] == tempacadYr) {
                                    r["discount_amount"] = discountAmt.toString();
                                    r["discount_percentage"] = discountPer.toString();
                                  }
                                }
                              } else {
                                discountAmt = "";
                                print("discountAmt = $discountAmt");
                              }
                            }
                          });
                        }),
                    Text("Amt"),
                  ],
                ),
              ],
            ),
          ),
        ), // TOGGLE AMOUNT OR PERCENTAGE
        amtORper == true
            ? Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    initialValue: "0",
                    onChanged: (v) {
                      setState(() {
                        discountAmt = v;
                        discountAmtFirstTime = false;
                        if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                          for (var o in divData!) {
                            if (o[0]["division_name"] == widget.divName) {
                              double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                              double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                              double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Main_Fees) * 100;
                              discountPer = _temp_discountPercentage.toString();
                            }
                          }
                          for (var r in listofDiscountsWigsMAP) {
                            if (r["acadyr"] == tempacadYr) {
                              r["discount_amount"] = discountAmt.toString();
                              r["discount_percentage"] = discountPer.toString();
                            }
                          }
                        } else {
                          discountPer = "";
                        }
                        print("discountPer = $discountPer");
                      });
                    },
                    decoration: InputDecoration(
                      label: const Text("Discount Amount"),
                      errorText: discountAmtFirstTime == true ? null : funcValEmptyOrNumber(discountAmt, "Discount Amount"),
                    ),
                  ),
                ),
              ) //DISCOUNT AMOUNT
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    initialValue: "0",
                    onChanged: (v) {
                      discountPer = v;
                      discountPerFirstTime = false;
                      if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                        for (var o in divData!) {
                          if (o[0]["division_name"] == widget.divName) {
                            double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                            double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                            double _temp_discountAmount = _temp_total_Main_Fees * _temp_discountPerInt / 100;
                            discountAmt = _temp_discountAmount.toString();
                            print("discountAmt = $discountAmt");
                          }
                        }
                        for (var r in listofDiscountsWigsMAP) {
                          if (r["acadyr"] == tempacadYr) {
                            r["discount_amount"] = discountAmt.toString();
                            r["discount_percentage"] = discountPer.toString();
                          }
                        }
                      } else {
                        discountAmt = "";
                        print("discountAmt = $discountAmt");
                      }
                    },
                    decoration: InputDecoration(
                        label: Text("Percentage Discount"),
                        errorText: discountPerFirstTime == true ? null : funcValEmptyOrNumber(discountPer, "Discount Percent")),
                  ),
                ),
              ), //DISCOUNT PERCENTAGE
      ],
    );
  }
}

//-------------------------------------------------------------------------------------------------------------------------

class DiscountSubE extends StatefulWidget {
  final String divName;
  final String title;
  final double amount;

  DiscountSubE({required this.divName, required this.title, required this.amount});

  @override
  State<DiscountSubE> createState() => _DiscountSubEState();
}

class _DiscountSubEState extends State<DiscountSubE> {
  @override
  bool amtORper = true;
  String discountAmt = "";
  bool discountAmtFirstTime = true;
  String discountPer = "";
  bool discountPerFirstTime = true;

  Widget build(BuildContext context) {
    String tempacadYr = widget.divName.split(" ")[2].substring(1, 10);
    return Wrap(
      runAlignment: WrapAlignment.spaceEvenly,
      alignment: WrapAlignment.spaceEvenly,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Text("Div: ${widget.divName}"),
        // ), //YEAR
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text("Title: ${widget.title}"),
        ), //TITLE
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text("Amount: ${widget.amount.toString()}"),
        ), //AMOUNT
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: 150,
            child: Row(
              children: [
                Text("%"),
                Switch(
                    value: amtORper,
                    onChanged: (v) {
                      setState(() {
                        amtORper = !amtORper;
                        print("Switch = $amtORper");

                        if (amtORper == true) {
                          discountAmt = discountPer;
                          if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                            for (var o in divData!) {
                              if (o[0]["division_name"] == widget.divName) {
                                double _temp_total_Extra_Fees = widget.amount;
                                double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                                double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Extra_Fees) * 100;
                                discountPer = _temp_discountPercentage.toString();
                              }
                            }
                            for (var r in listofDiscountsWigsMAP_EXTRA) {
                              if (r["acadyr"] == tempacadYr && r["discount_fee_title"] == widget.title) {
                                r["discount_amount"] = discountAmt.toString();
                                r["discount_percentage"] = discountPer.toString();
                              }
                            }
                          } else {
                            discountPer = "";
                          }
                          print("discountPer  ${widget.title} = $discountPer");
                        } else {
                          discountPer = discountAmt;
                          if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                            for (var o in divData!) {
                              if (o[0]["division_name"] == widget.divName) {
                                double _temp_total_Extra_Fees = widget.amount;
                                double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                                double _temp_discountAmount = _temp_total_Extra_Fees * _temp_discountPerInt / 100;
                                discountAmt = _temp_discountAmount.toString();
                                print("discountAmt  ${widget.title} = $discountAmt");
                              }
                            }
                            for (var r in listofDiscountsWigsMAP_EXTRA) {
                              if (r["acadyr"] == tempacadYr && r["discount_fee_title"] == widget.title) {
                                r["discount_amount"] = discountAmt.toString();
                                r["discount_percentage"] = discountPer.toString();
                              }
                            }
                          } else {
                            discountAmt = "";
                            print("discountAmt  ${widget.title} = $discountAmt");
                          }
                        }
                      });
                    }),
                Text("Amt"),
              ],
            ),
          ),
        ), // TOGGLE AMOUNT OR PERCENTAGE
        amtORper == true
            ? Padding(
                padding: EdgeInsets.all(30.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    initialValue: "0",
                    onChanged: (v) {
                      setState(() {
                        discountAmt = v;
                        discountAmtFirstTime = false;
                        if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                          for (var o in divData!) {
                            if (o[0]["division_name"] == widget.divName) {
                              double _temp_total_Extra_Fees = widget.amount;
                              double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                              double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Extra_Fees) * 100;
                              discountPer = _temp_discountPercentage.toString();
                            }
                          }
                          for (var r in listofDiscountsWigsMAP_EXTRA) {
                            if (r["acadyr"] == tempacadYr && r["discount_fee_title"] == widget.title) {
                              r["discount_amount"] = discountAmt.toString();
                              r["discount_percentage"] = discountPer.toString();
                            }
                          }
                        } else {
                          discountPer = "";
                        }
                        print("discountPer  ${widget.title} = $discountPer");
                      });
                    },
                    decoration: InputDecoration(
                      label: const Text("Discount Amount"),
                      errorText: discountAmtFirstTime == true ? null : funcValEmptyOrNumber(discountAmt, "Discount Amount"),
                    ),
                  ),
                ),
              ) //DISCOUNT AMOUNT
            : Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    initialValue: "0",
                    onChanged: (v) {
                      discountPer = v;
                      discountPerFirstTime = false;
                      if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                        for (var o in divData!) {
                          if (o[0]["division_name"] == widget.divName) {
                            double _temp_total_Extra_Fees = widget.amount;
                            ;
                            double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                            double _temp_discountAmount = _temp_total_Extra_Fees * _temp_discountPerInt / 100;
                            discountAmt = _temp_discountAmount.toString();
                            print("discountAmt  ${widget.title} = $discountAmt");
                          }
                        }
                        for (var r in listofDiscountsWigsMAP_EXTRA) {
                          if (r["acadyr"] == tempacadYr && r["discount_fee_title"] == widget.title) {
                            r["discount_amount"] = discountAmt.toString();
                            r["discount_percentage"] = discountPer.toString();
                          }
                        }
                      } else {
                        discountAmt = "";
                        print("discountAmt ${widget.title} = $discountAmt");
                      }
                    },
                    decoration: InputDecoration(
                        label: Text("Percentage Discount"),
                        errorText: discountPerFirstTime == true ? null : funcValEmptyOrNumber(discountPer, "Discount Percent")),
                  ),
                ),
              ), //DISCOUNT PERCENTAGE
      ],
    );
    ;
  }
}


//-------------------------------- Initial Sub Discount Wig --------------------------------------------
class DiscountINITWigSub extends StatefulWidget {
  final String divName;
  final String amount;
  final String title;
  String initAmount;

  DiscountINITWigSub({required this.divName, required this.amount, required this.title, required this.initAmount});

  @override
  State<DiscountINITWigSub> createState() => _DiscountINITWigSubState();
}

class _DiscountINITWigSubState extends State<DiscountINITWigSub> {
  bool amtORper = true;
  String discountAmt = "";
  bool discountAmtFirstTime = true;
  String discountPer = "";
  bool discountPerFirstTime = true;

  Widget build(BuildContext context) {
    String tempacadYr = widget.divName.split(" ")[2].substring(1, 10);
    discountAmt = widget.initAmount;
    discountPer = (int.parse(discountAmt)/int.parse(widget.amount)*100).toString();
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Title: ${widget.title}"),
              ],
            ),
          ),
        ), //TITLE
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text("Amount: ${widget.amount}"),
        ), //AMOUNT
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text("%"),
                    Switch(
                        value: amtORper,
                        onChanged: (v) {
                          setState(() {
                            amtORper = !amtORper;
                            print("Switch = $amtORper");

                            if (amtORper == true) {
                              discountAmt = widget.initAmount;
                              discountPer = (int.parse(discountAmt)/int.parse(widget.amount)*100).toString();
                              if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                                for (var o in divData!) {
                                  if (o[0]["division_name"] == widget.divName) {
                                    double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                                    double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                                    double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Main_Fees) * 100;
                                    discountPer = _temp_discountPercentage.toString();
                                  }
                                }
                                for (var r in listofDiscountsWigsMAP) {
                                  if (r["acadyr"] == tempacadYr) {
                                    r["discount_amount"] = discountAmt.toString();
                                    r["discount_percentage"] = discountPer.toString();
                                  }
                                }
                              } else {
                                discountPer = "";
                              }
                              print("discountPer = $discountPer");
                            } else {
                              discountAmt = widget.initAmount;
                              discountPer = (int.parse(discountAmt)/int.parse(widget.amount)*100).toString();
                              if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                                for (var o in divData!) {
                                  if (o[0]["division_name"] == widget.divName) {
                                    double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                                    double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                                    double _temp_discountAmount = _temp_total_Main_Fees * _temp_discountPerInt / 100;
                                    discountAmt = _temp_discountAmount.toString();
                                    print("discountAmt = $discountAmt");
                                  }
                                }
                                for (var r in listofDiscountsWigsMAP) {
                                  if (r["acadyr"] == tempacadYr) {
                                    r["discount_amount"] = discountAmt.toString();
                                    r["discount_percentage"] = discountPer.toString();
                                  }
                                }
                              } else {
                                discountAmt = "";
                                print("discountAmt = $discountAmt");
                              }
                            }
                          });
                        }),
                    Text("Amt"),
                  ],
                ),
              ],
            ),
          ),
        ), // TOGGLE AMOUNT OR PERCENTAGE
        amtORper == true
            ? Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextFormField(
              initialValue:discountAmt,
              onChanged: (v) {
                setState(() {
                  discountAmt = v;
                  discountAmtFirstTime = false;
                  if (funcValEmptyOrNumber(discountAmt, "Discount Amount") == null) {
                    for (var o in divData!) {
                      if (o[0]["division_name"] == widget.divName) {
                        double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                        double _temp_discountAmtInt = discountAmt == "" ? 0 : double.parse(discountAmt);
                        double _temp_discountPercentage = (_temp_discountAmtInt / _temp_total_Main_Fees) * 100;
                        discountPer = _temp_discountPercentage.toString();
                      }
                    }
                    for (var r in listofDiscountsWigsMAP) {
                      if (r["acadyr"] == tempacadYr) {
                        r["discount_amount"] = discountAmt.toString();
                        r["discount_percentage"] = discountPer.toString();
                      }
                    }
                  } else {
                    discountPer ="";
                  }
                  print("discountPer = $discountPer");
                });
              },
              decoration: InputDecoration(
                label: const Text("Discount Amount"),
                errorText: discountAmtFirstTime == true ? null : funcValEmptyOrNumber(discountAmt, "Discount Amount"),
              ),
            ),
          ),
        ) //DISCOUNT AMOUNT
            : Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 300,
            child: TextFormField(
              initialValue: discountPer,
              onChanged: (v) {
                discountPer = v;
                discountPerFirstTime = false;
                if (funcValEmptyOrNumber(discountPer, "Discount Percent") == null) {
                  for (var o in divData!) {
                    if (o[0]["division_name"] == widget.divName) {
                      double _temp_total_Main_Fees = o[0]["fees"]["main_fees"][0]["total_fees"];
                      double _temp_discountPerInt = discountPer == "" ? 0 : double.parse(discountPer);
                      double _temp_discountAmount = _temp_total_Main_Fees * _temp_discountPerInt / 100;
                      discountAmt = _temp_discountAmount.toString();
                      print("discountAmt = $discountAmt");
                    }
                  }
                  for (var r in listofDiscountsWigsMAP) {
                    if (r["acadyr"] == tempacadYr) {
                      r["discount_amount"] = discountAmt.toString();
                      r["discount_percentage"] = discountPer.toString();
                    }
                  }
                } else {
                  discountAmt = "";
                  print("discountAmt = $discountAmt");
                }
              },
              decoration: InputDecoration(
                  label: Text("Percentage Discount"),
                  errorText: discountPerFirstTime == true ? null : funcValEmptyOrNumber(discountPer, "Discount Percent")),
            ),
          ),
        ), //DISCOUNT PERCENTAGE
      ],
    );
  }
}