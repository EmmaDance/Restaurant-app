import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/data/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderBloc bloc;
  final int orderId;

  const OrderDetailsScreen(
      {Key key, @required this.orderId, @required this.bloc})
      : super(key: key);

  @override
  OrderDetailsScreenState createState() {
    return OrderDetailsScreenState(orderId,bloc);
  }
}

class OrderDetailsScreenState extends State<OrderDetailsScreen>{
  final OrderBloc bloc;
  final int orderId;
  Future future;
  OrderDetailsScreenState(this.orderId, this.bloc);

  @override
  void initState() {
    future = getOrder();
    super.initState();
  }

  Future<Order> getOrder () async {
    Order order = await bloc.getOrder(orderId);
    return order;
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Order details"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(
                        children: <Widget>[
                          Text(snapshot.data.details),
                          Text("for table " + snapshot.data.table),
                          Text("type: " + snapshot.data.type),
                          Text("status: " + snapshot.data.status),
                          Text("time : " + snapshot.data.time.toString()),
                        ],
                      );
                    default:
                        return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ));
  }


}
