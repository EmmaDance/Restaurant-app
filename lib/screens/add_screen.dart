import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/bloc.dart';

import '../widgets/add_screen_form.dart';

class AddScreen extends StatelessWidget{
  final OrderBloc bloc;

  const AddScreen({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New order"),
      ),
      body: AddScreenForm(bloc: bloc,),
    );
  }

}