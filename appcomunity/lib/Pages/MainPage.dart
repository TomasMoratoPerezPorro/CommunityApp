import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CommunityApp"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            EspaisWidget(),
          ],
        ),
      ),
    );
  }
}

class EspaisWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Card(
          child: Column(
            children: <Widget>[
              Container(
                child: Text("Espais"),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: Icon(Icons.home),
                  ),
                  Text("TERRAT"),
                ],
              )
            ],
          ),
        ));
  }
}
