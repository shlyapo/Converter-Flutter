import 'package:converter/screen/Lconversion.dart';
import 'package:converter/screen/Mconversion.dart';
import 'package:converter/screen/Moconversion.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'What you want to convert?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.linear_scale),
            title: Text('Length'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, LengthScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Money'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, MoneyScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.balance_outlined),
            title: Text('Massa'),
            onTap: () {
              Navigator.restorablePushNamed(
                  context, MassaScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}