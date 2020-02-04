import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';
import 'package:restaurant_app/screens/add_screen.dart';

import '../widgets/ready_list.dart';

class WaiterScreen extends StatelessWidget{
  final OrderBloc bloc;
  const WaiterScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Waiter"),
      ),
      body:  ReadyList(bloc: bloc,),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddScreen(bloc: bloc,)),);
        },

      ),
    );
  }

  Future<bool> isOnline() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
      return true;
    return false;
  }

}