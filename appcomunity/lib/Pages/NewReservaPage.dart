import 'package:appcomunity/Widgets/LlistaEspaisWidget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewReservaPage extends StatefulWidget {
  @override
  _NewReservaPageState createState() => _NewReservaPageState();
}

class _NewReservaPageState extends State<NewReservaPage> {
  TextEditingController _controller;
  DateTime pickedDate;

  @override
  void initState() {
    _controller = TextEditingController();
    pickedDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('New Reserva')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[    
              LlistaEspaisWidget(),                       
              RaisedButton(
                child: Text('Add Palabra'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ));
  }
}


