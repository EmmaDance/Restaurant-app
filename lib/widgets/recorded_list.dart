import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/widgets/recorded_order_tile.dart';
import '../data/order.dart';

class RecordedList extends StatefulWidget {
  final OrderBloc bloc;

  RecordedList({Key key, this.bloc}) : super(key: key);

  @override
  _RecordedListState createState() => new _RecordedListState(bloc);
}

class _RecordedListState extends State<RecordedList> {
  final OrderBloc bloc;

  _RecordedListState(this.bloc);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Order>>(
        stream: bloc.recordedOrders,
        initialData: List<Order>(),
        builder: (context, snapshot) {
          // add connection switch
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return RecordedOrderTile(order: snapshot.data[index],bloc: bloc,);
                },
              );
          }
        });
  }
}
