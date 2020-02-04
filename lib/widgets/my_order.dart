import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'dart:developer' as developer;

import 'package:restaurant_app/data/order.dart';

class MyOrder extends StatefulWidget {
  final OrderBloc bloc;

  MyOrder({Key key, this.bloc}) : super(key: key);

  @override
  _MyOrderState createState() => new _MyOrderState(bloc);
}

class _MyOrderState extends State<MyOrder> {
  final OrderBloc bloc;
  List<String> tables = ['T1', 'T2', 'North', 'Big', 'Small', 'Round'].toList();
  String table;
  Future future;

  _MyOrderState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  getMyOrder() async {
    try{
      return await bloc.getMyOrder(table);
    }
    on Exception catch(e){
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.amber,
          textColor: Colors.black45,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text("Choose your table: "),
            DropdownButton(
              hint: Text('Table'),
              value: table,
              onChanged: (newValue) {
                setState(() {
                  table = newValue;
                  future = getMyOrder();
                });
              },
              items: tables.map((t) {
                return DropdownMenuItem(
                  child: new Text(t),
                  value: t,
                );
              }).toList(),
            ),
            FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                    case ConnectionState.active:
                      if (snapshot.data != null)
                        return Column(
                          children: <Widget>[
                            Text(snapshot.data.details),
                            Text("status: " + snapshot.data.status),
                            Text("type: " + snapshot.data.type),
                            Text("time: " + snapshot.data.time.toString()),
                          ],
                        );
                      else {
                        return Text("Can't find any orders, sorry.");
                      }
                      break;
                    default:
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
