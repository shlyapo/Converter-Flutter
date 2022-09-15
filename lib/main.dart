import 'package:converter/screen/Lconversion.dart';
import 'package:converter/screen/Mconversion.dart';
import 'package:converter/screen/Moconversion.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          secondaryHeaderColor: Colors.red,
        ),
        home: LengthScreen(),
        routes: {
          LengthScreen.routeName: (ctx) => LengthScreen(),
          MoneyScreen.routeName: (ctx) =>
              MoneyScreen(),
          MassaScreen.routeName: (ctx) =>
              MassaScreen()
        },
      ),
    );
  }
}
