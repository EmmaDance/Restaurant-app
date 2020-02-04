import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/widgets/my_order.dart';

class ClientScreen extends StatelessWidget{
  final OrderBloc bloc;

  const ClientScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client"),
      ),
      body: MyOrder(bloc: bloc),
    );
  }

}