import 'package:appcomunity/Model/Espais.dart';
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
        child: Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  child: Text("Reserves"),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: GridView.count(
                    physics: new NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    children: <Widget>[
                      for (int i = 0; i < 10; i++) ReservaItem()
                    ],
                  )),
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
        ));
  }
}

class ReservaItem extends StatelessWidget {
  const ReservaItem({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text('Heart Shaker'),
            subtitle: Text('TWICE'),
          ),
        ],
      ),
    );
  }
}
