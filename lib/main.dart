import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/screens/client_screen.dart';
import 'package:restaurant_app/screens/kitchen_screen.dart';
import 'package:restaurant_app/screens/waiter_screen.dart';
import 'package:restaurant_app/web_socket.dart';
import 'data/service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Home',)
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OrderBloc bloc = OrderBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription subscription;


  @override
  void initState() {
    subscription = Connectivity().onConnectivityChanged.listen((
        ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
        setState(() {
          Service.isConnected = true;
          bloc.sync();
        });
      else
        setState(() {
          Service.isConnected = false;
        });
    });

    isOnline();
    WebSocketListener ws = new WebSocketListener(bloc: bloc);
    ws.init();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
            onPressed: (){
              showWaiterSection();
            },
            child: Text('Waiter'),
            ),
            RaisedButton(
              onPressed: (){
                showKitchenSection();
              },
              child: Text('Kitchen'),
            ),
            RaisedButton(
              onPressed: (){
                showClientSection();
              },
              child: Text('Client'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showWaiterSection() {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => WaiterScreen(bloc: bloc,)),);
  }

  showKitchenSection() async {
    if(await isOnlineSnackBar())
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => KitchenScreen(bloc: bloc,)),);
  }

  void showClientSection() async {
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => ClientScreen(bloc: bloc,)),);
  }

  Future<bool> isOnline() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi){
      Service.isConnected = true;
      return true;
    }
    Service.isConnected = false;
    return false;
  }

  Future<bool> isOnlineSnackBar() async {
    if (await isOnline()){
      return true;
    }
    final snackBar = SnackBar(content: Text('You cannot access this while offline'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return false;
  }
}
