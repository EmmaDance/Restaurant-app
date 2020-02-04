import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';

import '../widgets/recorded_list.dart';

class KitchenScreen extends StatelessWidget{
  final OrderBloc bloc;


  const KitchenScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitchen"),
      ),
      body: RecordedList(bloc: bloc),
    );
  }

}