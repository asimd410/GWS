import 'package:flutter/material.dart';
import 'package:gws/functionAndVariables/funcCust.dart';
import 'package:gws/screens/login_page.dart';
import 'package:gws/screens/students/StudentsMain.dart';
import 'package:gws/screens/students/add_student_page.dart';
import 'package:gws/screens/user_profiles.dart';
import 'package:gws/screens/classList/class_list.dart';
import 'package:gws/Trail/trail.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return
      ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child:
      MaterialApp(
        title: 'Flutter Demo',
        // themeMode:ThemeMode.light,
        // theme: ThemeClass.lightTheme,
        // darkTheme: ThemeClass.darkTheme,
        initialRoute: '/Class_List',
        routes: {
          '/Login_Page':(context) =>const Login_Page(),
          '/User_Profiles':(context) =>const User_Profiles(),
          '/Class_List':(context) =>const ClassList(),
          '/Students_Main':(context) =>const StudentsMain(),
          '/AddStudentPage':(context) => const AddStudentPage(),
        },
      ),
    );
  }
}



//----------- Theme Class -------------------
class ThemeClass{

  static ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
      )
  );

  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey,
      )
  );
}