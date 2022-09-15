import 'package:converter/widgets/scaleDrawer.dart';
import 'package:converter/widgets/MoneyActions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyScreen extends StatefulWidget {
  static const routeName = '/money-conversion';

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  Future setPortrait() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Future setLandscape() async => await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  Widget _landscapeMoneyMode(){
    return Center(
        child:ListView(
            children:[Card(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                side: BorderSide(
                  color: Colors.brown,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                padding: EdgeInsets.only(top:40),
                width: MediaQuery.of(context).size.width,
                height: 350,
                child:Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MoneyActions(),
                        ],
                      ),
                    ]
                ),
              ),
            ),
            ]
        )

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
        drawer:AppDrawer(),
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.orange,
          elevation: 50.0,
          title: Text(
            'Convert Money',
            style: TextStyle(
              color: Colors.brown,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            Padding(
                padding:EdgeInsets.only(left:20.0),
                child:GestureDetector(
                    onTap:(){
                      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
                      if (isPortrait) {
                        setLandscape();
                      } else {
                        setPortrait();
                      }
                    },
                    child:Icon(
                        Icons.rotate_left
                    )
                )
            )
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body:Center(
            child:ListView(
                children:[
                  Card(
                    shape: RoundedRectangleBorder( //<-- SEE HERE
                      side: BorderSide(
                        color: Colors.orange,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      padding: EdgeInsets.only(top:40),
                      width: MediaQuery.of(context).size.width,
                      height: 500,
                      child:Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MoneyActions(),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ]
            )

        )

    );


  }
}