import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/screens/Drawer/drawerMain.dart';
import 'package:provider/provider.dart';
import 'dataTable/DataTableForInstallmentsView.dart';


bool showInstallmentList = true;

class FeeInstallmentList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 5), () {
      Provider.of<Data>(context, listen: false).refInstallmentTablefunc(true);
    });

    double screenW = MediaQuery.of(context).size.width;
    double screenH = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Division And Installments List"))
      ),
        drawer:  DrawerMAIN(),
        body: Stack(
          children: [
            Provider.of<Data>(context, listen: true).refInstallmentTable == true? DataPageInstallment(width: screenW, height: screenH,):Container(),
          ],
        ));
  }
}
