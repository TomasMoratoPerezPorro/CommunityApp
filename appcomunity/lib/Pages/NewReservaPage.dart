import 'package:flutter/material.dart';

class NewReservaPage extends StatefulWidget {
  @override
  _NewReservaPageState createState() => _NewReservaPageState();
}

class _NewReservaPageState extends State<NewReservaPage> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24),
              child: TextField(
                controller: _controller,
                onSubmitted: (what) {
                  Navigator.of(context).pop();
                },
              ),
            ),
            RaisedButton(
              child: Text('Add Palabra'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }
}
