import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:web_socket_channel/io.dart';
import 'data/order.dart';
import 'dart:developer' as developer;

class WebSocketListener {
  static String msg = "";
  final OrderBloc bloc;

  WebSocketListener({Key key, this.bloc});


  void init() {
    var channel = IOWebSocketChannel.connect(
        'ws://192.168.2.104:2301');
    channel.sink.add('I am connected!');
    channel.stream.listen((message) {
      developer.log("message received: " + message, name: "WebSocket");
      messageFunction(message);
    });
  }

  messageFunction(String message) {
    Map<String, dynamic> decoded = json.decode(message);
    Order order = Order.fromJson(decoded);
    bloc.addLocal(order);
    String msg = "New order : " + order.type + " " + order.details + " for table " + order.table + ".";
    Fluttertoast.showToast(msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0
    );
    WebSocketListener.msg = "";
  }


}
