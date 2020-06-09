import 'package:appcomunity/Model/Espais.dart';
import 'package:appcomunity/Model/Reserves.dart';
import 'package:appcomunity/Pages/NewReservaPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final Color mainColor = Color(0xFFff7f5c);
final Color secondaryColor = Color(0xFFfff7f5);

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CommunityApp"),
        backgroundColor: mainColor,
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
        color: secondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            PastillaEspaiIcona(espai: espai.nom),
            Text(espai.nom),
            Container(
              margin: EdgeInsets.only(left: 200),
              height: 70,
              width: 10,
              decoration: BoxDecoration(
                  color: mainColor,
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

class PastillaEspaiIcona extends StatelessWidget {
  const PastillaEspaiIcona({
    Key key,
    @required this.espai,
  }) : super(key: key);

  final String espai;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: mainColor)),
      child: espai == "Piscina" ? Icon(Icons.pool) : Icon(Icons.beach_access),
    );
  }
}

class ReservesWidget extends StatelessWidget {
  List<Reserves> reservasPerLogica;
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
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Reservas",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
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
                          reservasPerLogica = reserves;
                          return GridView.count(
                            physics: new NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: <Widget>[
                            
                              for (int i = 0; i < reserves.length; i++)
                                if (reserves[i]
                                    .dataFinal
                                    .isAfter(DateTime.now()))
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
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return NewReservaPage(reserves: reservasPerLogica);
                        },
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                )
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

  String formatDate(DateTime data) {
    var newFormat = DateFormat("yMMMEd");
    String updatedDt = newFormat.format(data);

    return updatedDt;
  }

  String formatTime(DateTime data) {
    var newFormat = DateFormat("jm");
    String updatedDt = newFormat.format(data);

    return updatedDt;
  }

  

  @override
  Widget build(BuildContext context) {
    Color checkTodayColor(DateTime dataReserva){
      if(dataReserva.isAfter(DateTime.now().add(Duration(days: 1, hours: 0, minutes: 0)))){
        return Colors.orange[200];
      }else{
        return mainColor;
      }
    }
    return Card(
      color: secondaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder<DocumentSnapshot>(
            future: reserva.espai.get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DocumentSnapshot doc = snapshot.data;
                String nomEspai = doc.data['Name'];
                debugPrint(nomEspai);
                debugPrint(reserva.espai.path.toString());

                return Column(
                  children: <Widget>[
                    PastillaEspaiIcona(espai: nomEspai),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(nomEspai,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                );
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
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      nomUsuari.toUpperCase(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                );
              } else {
                // TODO: Mostrar ... ???
                return Text('...');
              }
            },
          ),
          Expanded(
            child: Container(
              color: checkTodayColor(reserva.dataIni),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 10),
                  Text(formatDate(reserva.dataIni),
                      style: TextStyle(
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: checkTodayColor(reserva.dataIni),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.zero,
                    bottomLeft: Radius.circular(3),
                    bottomRight: Radius.circular(3)),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Text(formatTime(reserva.dataIni),
                      style: TextStyle(
                          fontSize: 12,
                          // fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* reserva.dataIni.toString() */

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
