import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gws/functionAndVariables/CommVariables.dart';


class DrawerMAIN extends StatelessWidget {
  const DrawerMAIN({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(userName),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.school),
            title: const Text('AcadYr, Class, Subject & Division'),
            onTap: () {
              Navigator.pushNamed(context,  '/Class_List');
            },
          ),
          const Divider(),
          ListTile(
            leading: const FaIcon(FontAwesomeIcons.child),
            title: const Text('View Edit Students'),
            onTap: () {Navigator.pushNamed(context, '/Students_Main');},
          ),
          const Divider(),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}