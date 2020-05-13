import 'package:flutter/material.dart';
import 'package:appcomunity/Model/Reserves.dart';
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
            child: ListView(
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
                return ListView(
                  children: <Widget>[
                    for(int i=0;i<espais.length;i++)
                      PastillaEspai(),
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
              decoration: BoxDecoration(
                  color: Colors.green, shape: BoxShape.circle),
              child: Icon(Icons.home),
            ),
            Text("TERRAT"),
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
                  child: Card(
                    color: Colors.grey[100],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: Icon(Icons.home),
                        ),
                        Text("TERRAT"),
                        Container(
                          margin: EdgeInsets.only(left: 200),
                          color: Colors.green,
                          height: 40,
                          width: 10,
                        )
                      ],
                    ),
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
