import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';

import '../data/order.dart';

class RecordedOrderTile extends StatefulWidget {
  final OrderBloc bloc;
  final Order order;

  const RecordedOrderTile({Key key, @required this.order, @required this.bloc})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecordedOrderTileState();
  }
}

class RecordedOrderTileState extends State<RecordedOrderTile> {
  String status;
  List<String> statuses = ['preparing', 'ready', 'canceled'].toList();

  @override
  Widget build(BuildContext context) {
    return ListTile(
        isThreeLine: true,
        title: Text(widget.order.details),
        subtitle: Text(
            "type: " + widget.order.type + "\nstatus: " + widget.order.status),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: DropdownButton(
                            hint: Text('Status'),
                            value: status,
                            onChanged: (newValue) {
                              setState(() {
                                status = newValue;
                              });
                            },
                            items: statuses.map((t) {
                              return DropdownMenuItem(
                                child: new Text(t),
                                value: t,
                              );
                            }).toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                widget.bloc.status(widget.order.id, status);
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                  );
                });
              });
        });
  }
}
