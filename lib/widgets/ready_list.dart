import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/data/service.dart';
import 'dart:developer' as developer;

import '../data/order.dart';
import 'ready_order_tile.dart';

class ReadyList extends StatefulWidget {
  final OrderBloc bloc;

  ReadyList({Key key, this.bloc}) : super(key: key);

  @override
  _ReadyListState createState() => new _ReadyListState(bloc);
}

class _ReadyListState extends State<ReadyList> {
  final OrderBloc bloc;

  _ReadyListState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
        stream: bloc.readyOrders,
        initialData: List<Order>(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            case ConnectionState.active:
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ReadyOrderTile(
                      order: snapshot.data[index], bloc: bloc);
                },
              );
            default:
              return Service.isConnected ? Center(child: CircularProgressIndicator()) :
              Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Text("You are offline!"),
                    Text("Connect to internet and then try again"),
                    RaisedButton(
                      onPressed: () {
                        setState(() {
                        });
                      },
                      child: Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
