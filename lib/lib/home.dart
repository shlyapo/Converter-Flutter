import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double inTemp = 0.0, outTemp = 0.0;
  bool isFah = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          // ignore: prefer_const_constructors
          title: Text('Temperature Converter'),
          backgroundColor: Colors.red,
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Temperature',
                  labelText: isFah
                      ? 'You have entered temp $inTemp in Fahrenhiet'
                      : 'You have entered temp $inTemp in Celsius',
                ),
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  setState(() {
                    try {
                      inTemp = double.parse(newValue);
                    } catch (e) {}
                  });
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              RadioListTile(
                value: true,
                groupValue: isFah,
                onChanged: (bool? newValue) {
                  setState(() {
                    isFah = newValue!;
                  });
                },
                title: const Text('Fahrenhiet'),
              ),
              RadioListTile(
                value: false,
                groupValue: isFah,
                onChanged: (bool? newValue) {
                  setState(() {
                    isFah = newValue!;
                  });
                },
                title: const Text('Celsius'),
              ),
              const SizedBox(
                height: 30.0,
              ),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: () {
                  setState(() {
                    outTemp =
                    isFah ? (inTemp - 32) / (5 / 6) : (inTemp * 9 / 5) + 32;
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Final Result',
                          style: TextStyle(
                              fontSize: 28.0, fontWeight: FontWeight.bold),
                        ),
                        content: isFah
                            ? Text(
                            '$inTemp in Fahrenhiet = $outTemp in Celsius')
                            : Text(
                            '$inTemp in Celsius = $outTemp in Fahrenhiet'),
                      ),
                    );
                  });
                },
                child: const Text(
                  'Convert',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}