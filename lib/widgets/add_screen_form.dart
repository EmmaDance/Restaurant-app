import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/bloc.dart';
import '../data/order.dart';

class AddScreenForm extends StatefulWidget {
  final OrderBloc bloc;

  AddScreenForm({Key key, this.bloc}) : super(key: key);

  @override
  _AddScreenFormState createState() => new _AddScreenFormState(bloc);
}

class _AddScreenFormState extends State<AddScreenForm> {
  final _formKey = GlobalKey<FormState>();
  final OrderBloc bloc;
  String table;
  String details;
  int time;
  String type;
  List<String> types = ['normal', 'delivery', 'urgent'].toList();
  List<String> tables = ['T1', 'T2', 'North', 'Big', 'Small', 'Round'].toList();

  _AddScreenFormState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: <Widget>[
              Center(
                child: DropdownButton(
                  hint: Text('Table'),
                  value: table,
                  onChanged: (newValue) {
                    setState(() {
                      table = newValue;
                    });
                  },
                  items: tables.map((t) {
                    return DropdownMenuItem(
                      child: new Text(t),
                      value: t,
                    );
                  }).toList(),
                ),
              ),
              TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  details = value;
                  return null;
                },
                decoration: new InputDecoration(
                    labelText: 'Details',
                    hintText: 'What is the order?',
                    contentPadding: const EdgeInsets.all(16.0)),
              ),
              TextFormField(
                onChanged: (value) {
                  time = int.parse(value);
                },
                decoration: new InputDecoration(
                  labelText: "Time",
                  hintText: "In seconds... yeah, sorry for that",
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
              ),
              Center(
                child: DropdownButton(
                  hint: Text('Type'),
                  value: type,
                  onChanged: (newValue) {
                    setState(() {
                      type = newValue;
                    });
                  },
                  items: types.map((t) {
                    return DropdownMenuItem(
                      child: new Text(t),
                      value: t,
                    );
                  }).toList(),
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: RaisedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        if (_formKey.currentState.validate()) {
                          // Process data.
                          _addOrder(table, details, time, type);
                          Navigator.pop(context);
                        }
                      },
                      color: Colors.orangeAccent,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    )),
              ),
            ]),
          ),
        ));
  }

  void _addOrder(String table, String details, int time, String type) async {
    Order o = new Order();
    o.table = table;
    o.details = details;
    o.status = "recorded";
    o.time = time;
    o.type = type;
    try {
      await bloc.add(o);
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg:
              "Couldn't add your order! Please make sure no fields are missing.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.amber,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }
}
