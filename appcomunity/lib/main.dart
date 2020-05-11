import 'package:flutter/material.dart';
import 'package:appcomunity/Model/Reserves.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Pages/MainPage.dart';

void main() => runApp(CommunityApp());
class CommunityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:"CommunityApp",
      home: MainPage(),
      
    );
  }
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Reserves>>(
        stream: reservesSnapshots(),
        builder: (BuildContext context, AsyncSnapshot<List<Reserves>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('ERROR: ${snapshot.error.toString()}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              // Estem esperant el primer valor
              return Center(child: Text("Waiting..."));
            case ConnectionState.active:
              return Center(
                child: Text(
                  "${snapshot.data}",
                  style: TextStyle(fontSize: 40),
                ),
              );
            case ConnectionState.done:
              return Center(child: Text("Done!"));
            case ConnectionState.none:
            default:
              return Placeholder();
          }
        },
      ),
    );
  }
}

// DocumentSnapshot: "Foto" d'un document en un cert instant de temps.
// QuerySnapshot: "Foto" d'un consulta a una col·lecció.
