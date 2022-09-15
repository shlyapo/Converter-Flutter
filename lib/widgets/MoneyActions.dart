import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clipboard/clipboard.dart';

class MoneyActions extends StatefulWidget {
  @override
  _MoneyActionsState createState() => _MoneyActionsState();
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


class TextNumberLimitFormatter extends TextInputFormatter {

  TextNumberLimitFormatter();

  RegExp exp = new RegExp("[0-9.]");
  static const String POINTER = ".";
  static const String ZERO = "0";

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// Ввод полностью удален
    if (newValue.text.isEmpty) {
      return TextEditingValue();
    }
    String input = newValue.text;
    int index = input.indexOf(POINTER);

    /// Цифры перед десятичной запятой
    int lengthBeforePointer = input.substring(0, index).length;
    int lengthAfterPointer = input.substring(index, input.length).length - 1;
    // Разрешить ввод только чисел и десятичных знаков
    if (!exp.hasMatch(newValue.text)) {
      return oldValue;

    }

    if(newValue.text.length>=12) return oldValue;

    /// Включите десятичную точку
    if (newValue.text.contains(POINTER)) {
      // Точность 0, то есть без десятичных знаков

      /// Содержат несколько десятичных знаков
      if (newValue.text.indexOf(POINTER) !=
          newValue.text.lastIndexOf(POINTER)) {
        return oldValue;
      }
      /// Десятичные разряды больше точности
      if (lengthAfterPointer > 12 - lengthBeforePointer) {
        return oldValue;
      }

    } else if (
    // Начинаем с точки
    newValue.text.startsWith(POINTER)
        ||
        // Если первая цифра 0, а длина больше 1, исключить все недопустимые входы 00, 01-09
        (newValue.text.startsWith(ZERO) && newValue.text.length>1)
    ) {
      return oldValue;
    }
    return newValue;
  }
}

class _MoneyActionsState extends State<MoneyActions> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController message = TextEditingController();
  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI
    setState(() {});
  }
  String _from = 'byn';
  String _to = 'usd';
  double _value = 0;
  double _answer = 0;

  TextEditingController _editTextController = TextEditingController();


  final TextEditingController _textController = TextEditingController();

  // This function is triggered when the copy icon is pressed
  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }
  void convert(String from, String to, double value) async {
    if (value == 0) {
      return;
    }
    if (from == to) {
      setState(() {
        _answer = value;
      });
    }
    if (from == 'byn' && to == 'usd') {
      setState(() {
        _answer = value * 0.3886;
      });
    }
    if (from == 'usd' && to == 'byn') {
      setState(() {
        _answer = value*2.55;
      });
    }
    if (from == 'eur' && to == 'byn') {
      setState(() {
        _answer = value*0.3895;
      });
    }
    if (from == 'byn' && to == 'eur') {
      setState(() {
        _answer = ((value - 32) * 5) / 9;
      });
    }
    if (from == 'usd' && to == 'eur') {
      setState(() {
        _answer = value*0.99582;
      });
    }
    if (from == 'eur' && to == 'usd') {
      setState(() {
        _answer = value*0.8;
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
                      "BYN" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'byn',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "EUR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'eur',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "USD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'usd',
                  ),
                ],
                hint: Text('Money Scale'),
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
                      "BYN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'byn',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "EUR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'eur',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "USD" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'usd',
                  ),
                ],
                hint: Text('Money Scale'),
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
                  borderRadius: BorderRadius.circular(30),
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
                        Colors.brown,
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
                      Colors.brown,
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

          //TextButton(
            //style: ButtonStyle(
                //backgroundColor: MaterialStateProperty.all<Color>(
                //  Colors.brown,
              //  )),
            //onPressed: () => convert(_from, _to, _value),
           // child: Text(
              //'Convert',
              //style:
            //  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //  ),
          //)
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
                fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton(
                value: _from,
                items: [
                  DropdownMenuItem(
                    child: Text(
                      "BYN" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'byn',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      " EUR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'eur',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "USD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'usd',
                  ),
                ],
                hint: Text('Money Scale'),
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
                      "BYN",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'byn',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "EUR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'eur',
                  ),
                  DropdownMenuItem(
                    child: Text(
                      "USD" ,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: 'usd',
                  ),
                ],
                hint: Text('Money Scale'),
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
              size: 30.0,),
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
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.brown,
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
                      Colors.brown,
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