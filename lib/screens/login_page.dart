import 'package:flutter/material.dart';



class Login_Page extends StatelessWidget {
  const Login_Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;
    double screenW = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Login"))),
      body: Container(
        height: screenH,
        width:  screenW,
        child: Center(
          child: Container(
            width:500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  decoration: InputDecoration(
                    label: Text("UserName"),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    label: Text("Password"),
                  ),
                ),
                SizedBox(height:30),
                ElevatedButton(onPressed:(){}, child: Text("Login"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
