
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/data/service.dart';
import 'package:restaurant_app/screens/order_details_screen.dart';

import '../data/order.dart';


class ReadyOrderTile extends StatelessWidget{

  final Order order;
  final OrderBloc bloc;
  const ReadyOrderTile({Key key, @required this.order, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      title: Text(order.details ),
      subtitle: Text("type: " + order.type + "\nstatus: " + order.status),
      onTap: (){
        if(Service.isConnected)
        Navigator.of(context).push(new MaterialPageRoute(builder: (context){
          return OrderDetailsScreen(orderId: order.id, bloc: bloc);
        }));
        else{
          final snackBar = SnackBar(content: Text('You cannot do this while offline'));
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

}