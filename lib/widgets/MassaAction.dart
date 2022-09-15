import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';
class MassaActions extends StatefulWidget {
  @override
  _MassaActionsState createState() => _MassaActionsState();
}

class NumberLimitFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    //if (newValue.text.length >= 12) return oldValue;
    if(newValue.text.isEmpty)
    {
      return newValue;
    }
    try {
      double.parse((newValue.text));
    }
    catch (e) {
      return oldValue;
    }
    return newValue;
  }
}

class _MassaActionsState extends State<MassaActions> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController message = TextEditingController();
  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI
    setState(() {});
  }
  String _from = 'kg';
  String _to = 'g';
  double _value = 0;
  double _answer = 0;

  void convert(String from, String to, double value) async {
    if (value == 0) {
      return;
    }
    if (from == to) {
      setState(() {
        _answer = value;
      });
    }
    if (from == 'kg' && to == 'g') {
      setState(() {
        _answer = value * 1000;
      });
    }
    if (from == 'g' && to == 'kg') {
      setState(() {
        _answer = value/1000;
      });
    }
    if (from == 'kg' && to == 't') {
      setState(() {
        _answer = value/1000;
      });
    }
    if (from == 'g' && to == 't') {
      setState(() {
        _answer = value/1000000;
      });
    }
    if (from == 't' && to == 'kg') {
      setState(() {
        _answer = value*1000;
      });
    }
    if (from == 't' && to == 'g') {
      setState(() {
        _answer = value*1000000;
      });
    }
    FocusScope.of(context).unfocus();
  }

  Widget _portMoney() {
    return Container(
      child: Column(
        children: [
          Column(
            children: [

              Text(
                'From and to',
                style: TextStyle(
                    fontSize: 35, fontWeight: FontWeight.bold),
              ),
              DropdownButton(
                value: _from,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "KG " ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'kg',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "G",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'g',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "T",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 't',
                  ),
                ],
                hint: Text('Massa Scale'),
                onChanged: (String? from) {
                  setState(() {
                    _from = from!;
                  });
                },
              ),
              MaterialButton(
                child:Icon(Icons.arrow_circle_left,
                  color: Colors.black,
                  size: 20.0,),
                onPressed: (){
                  String temp = this._from;
                  this._from = _to;
                  _to = temp;
                  convert(_from, _to, _value);
                },
              ),
              SizedBox(
                width: 10,
              ),
              DropdownButton(
                value: _to,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "KG ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'kg',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "G",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'g',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "T" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 't',
                  ),
                ],
                hint: Text('Massa Scale'),
                onChanged: (String? to) {
                  setState(() {
                    _to = to!;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.65,
                child: TextField(

                  controller: _controller,
                  maxLength: 12,
                  inputFormatters: [
                    NumberLimitFormatter()
                  ],
                  cursorHeight: 20,
                  onSubmitted: (value) =>
                      convert(_from, _to, double.parse(value)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Input',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.handshake),
                    suffixIcon: _controller.text.isEmpty
                        ? null // Show nothing if the text field is empty
                        : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearTextField,
                    ), // Show the clear button if the text field has something
                  ),
                  //floatingLabelBehavior: FloatingLabelBehavior.never),
                  onChanged: (value) {
                    setState(() {
                      _value = double.tryParse(value)!;
                    });
                  },

                ),
              ),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                '=',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.65,
                child: Text(
                  _answer.toStringAsFixed(3),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red,
                      )),
                  onPressed: () {
                    if (_answer.toStringAsFixed(3).trim() == "") {

                      // do nothing
                    } else {
                      var v = _answer.toStringAsFixed(3);
                      FlutterClipboard.copy(v)
                          .then((value) => print('copied text'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Copied to your clipboard !')));
                    }
                  },
                  child: Text(
                    'COPY',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.redAccent,
                    )),
                onPressed: () {

                  if(_answer.toStringAsFixed(3).length>12)
                  {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Number is sooo big')));
                    _controller.text = "";
                  }
                  else {
                    FlutterClipboard.paste().then((value) {
                      setState(() {
                        _controller.text = value;
                      });
                    });
                  }
                },
                child: Text(
                  'PASTE',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _landMoney() {
    return Container(
      child: Column(
        children: [
          Text(
            'From and to',
            style: TextStyle(
                fontSize: 35, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: _from,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "KG " ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'kg',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "G",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'g',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "T",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 't',
                  ),
                ],
                hint: Text('Massa Scale'),
                onChanged: (String? from) {
                  setState(() {
                    _from = from!;
                  });
                },
              ),
              SizedBox(
                width: 30,
              ),

              SizedBox(
                width: 30,
              ),
              DropdownButton(
                value: _to,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "KG ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'kg',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "G",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'g',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "T" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 't',
                  ),
                ],
                hint: Text('Massa Scale'),
                onChanged: (String? to) {
                  setState(() {
                    _to = to!;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            child:Icon(Icons.arrow_circle_left,
              color: Colors.black,
              size: 60.0,),
            onPressed: (){
              String temp = this._from;
              this._from = _to;
              _to = temp;
              convert(_from, _to, _value);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.center,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.32,
                child: TextField(

                  controller: _controller,
                  maxLength: 12,
                  inputFormatters: [
                    NumberLimitFormatter()
                  ],
                  cursorHeight: 20,
                  onSubmitted: (value) =>
                      convert(_from, _to, double.parse(value)),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Input',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.handshake),
                    suffixIcon: _controller.text.isEmpty
                        ? null // Show nothing if the text field is empty
                        : IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _clearTextField,
                    ), // Show the clear button if the text field has something
                  ),
                  //floatingLabelBehavior: FloatingLabelBehavior.never),
                  onChanged: (value) {
                    setState(() {
                      _value = double.tryParse(value)!;
                    });
                  },

                ),
              ),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 25,
              ),
              Text(
                '=',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.center,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width * 0.21,
                child: Text(
                  _answer.toStringAsFixed(8),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

                ),
              ),
              SizedBox(
                width: 10,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red,
                      )),
                  onPressed: () {
                    if (_answer.toStringAsFixed(3).trim() == "") {

                      // do nothing
                    } else {
                      var v = _answer.toStringAsFixed(3);
                      FlutterClipboard.copy(v)
                          .then((value) => print('copied text'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Copied to your clipboard !')));
                    }
                  },
                  child: Text(
                    'COPY',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.redAccent,
                    )),
                onPressed: () {

                  if(_answer.toStringAsFixed(3).length>12)
                  {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Number is sooo big')));
                    _controller.text = "";
                  }
                  else {
                    FlutterClipboard.paste().then((value) {
                      setState(() {
                        _controller.text = value;
                      });
                    });
                  }
                },
                child: Text(
                  'PASTE',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),

        ],

      ),

    );
  }

  @override
  Widget build (BuildContext context) {
    return (
        OrientationBuilder(
          builder: (context,
              orientation){
            if(MediaQuery.of(context).orientation == Orientation.portrait){
              return _portMoney();
            }else{
              return _landMoney();
            }
          },
        )
    );
  }
}