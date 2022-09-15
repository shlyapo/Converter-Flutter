import 'package:converter/widgets/scaleDrawer.dart';
import 'package:converter/widgets/MassaAction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MassaScreen extends StatefulWidget {
  static const routeName = '/massa-conversion';

  @override
  State<MassaScreen> createState() => _MassaScreenState();
}

class _MassaScreenState extends State<MassaScreen> {
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
                  color: Colors.green,
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
                          MassaActions(),
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
        backgroundColor: Colors.green,
        drawer:AppDrawer(),
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.red,
          elevation: 50.0,
          title: Text(
            'Convert Massa',
            style: TextStyle(
              color: Colors.black,
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
                                MassaActions(),
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