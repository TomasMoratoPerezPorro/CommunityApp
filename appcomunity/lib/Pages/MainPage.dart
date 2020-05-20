import 'package:appcomunity/Model/Espais.dart';
import 'package:appcomunity/Model/Reserves.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CommunityApp"),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            EspaisWidget(),
            ReservesWidget(),
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
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "Espais",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                StreamBuilder<List<Espais>>(
                  stream: espaisSnapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Espais>> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('ERROR: ${snapshot.error.toString()}'));
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        // Estem esperant el primer valor
                        return Center(child: Text("Waiting..."));
                      case ConnectionState.active:
                        List<Espais> espais = snapshot.data;
                        return Column(
                          children: <Widget>[
                            for (int i = 0; i < espais.length; i++)
                              PastillaEspai(espai: espais[i]),
                          ],
                        );

                      // return Text("${snapshot.data.length}");
                      case ConnectionState.done:
                        return Center(child: Text("Done!"));
                      case ConnectionState.none:
                      default:
                        return Placeholder();
                    }
                  },
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 50,
                  width: 50,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ));
  }
}

class PastillaEspai extends StatelessWidget {
  const PastillaEspai({
    Key key,
    @required this.espai,
  }) : super(key: key);

  final Espais espai;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        color: Colors.grey[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              child: Icon(Icons.home),
            ),
            Text(espai.nom),
            Container(
              margin: EdgeInsets.only(left: 200),
              height: 70,
              width: 10,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5))),
            )
          ],
        ),
      ),
    );
  }
}

class ReservesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Column(
              children: <Widget>[
                Container(
                  child: Text("Reserves"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: StreamBuilder<List<Reserves>>(
                    stream: reservesSnapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Reserves>> snapshotReserves) {
                      if (snapshotReserves.hasError) {
                        return Center(
                            child: Text(
                                'ERROR: ${snapshotReserves.error.toString()}'));
                      }
                      switch (snapshotReserves.connectionState) {
                        case ConnectionState.waiting:
                          // Estem esperant el primer valor
                          return Center(child: Text("Waiting..."));
                        case ConnectionState.active:
                          List<Reserves> reserves = snapshotReserves.data;
                          return GridView.count(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: <Widget>[
                              for (int i = 0; i < reserves.length; i++)
                                ReservaItem(reserva: reserves[i]),
                            ],
                          );

                        case ConnectionState.done:
                          return Center(child: Text("Done!"));
                        case ConnectionState.none:
                        default:
                          return Placeholder();
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 50,
                  width: 50,
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ));
  }
}

class ReservaItem extends StatelessWidget {
  const ReservaItem({
    Key key,
    @required this.reserva,
  }) : super(key: key);

  final Reserves reserva;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.album, size: 50),
          FutureBuilder<DocumentSnapshot>(
            future: reserva.espai.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data;
                String nomEspai = doc.data['Name'];
                debugPrint(nomEspai);
                debugPrint(reserva.espai.path.toString());

                return Text(nomEspai);
              } else {
                // TODO: Mostrar ... ???
                return Text('...');
              }
            },
          ),
          FutureBuilder<DocumentSnapshot>(
            future: reserva.usuari.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data;
                String nomUsuari = doc.data['Name'];
                debugPrint(nomUsuari);
                debugPrint(reserva.usuari.path.toString());
                return Text(nomUsuari);
              } else {
                // TODO: Mostrar ... ???
                return Text('...');
              }
            },
          ),
          Text(reserva.dataIni.toString()),
        ],
      ),
    );
  }
}

/* 
class ReservaItemStringEspai extends StatelessWidget {
  const ReservaItemStringEspai({
    Key key,
    @required this.reserva,
  }) : super(key: key);

  final Reserves reserva;

  @override
  Widget build(BuildContext context) {
    StreamBuilder<List<Espais>>(
      stream: espaisSnapshots(),
      builder: (BuildContext context, AsyncSnapshot<List<Espais>> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('ERROR: ${snapshot.error.toString()}'));
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // Estem esperant el primer valor
            return Center(child: Text("Waiting..."));
          case ConnectionState.active:
            List<Espais> espais = snapshot.data;
            return Column(
              children: <Widget>[
                for (int i = 0; i < espais.length; i++)
                  PastillaEspai(espai: espais[i]),
              ],
            );

          // return Text("${snapshot.data.length}");
          case ConnectionState.done:
            return Center(child: Text("Done!"));
          case ConnectionState.none:
          default:
            return Placeholder();
        }
      },
    );
  }
}
 */
