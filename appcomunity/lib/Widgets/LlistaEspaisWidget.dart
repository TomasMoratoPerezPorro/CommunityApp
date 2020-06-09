import 'package:appcomunity/Pages/NewReservaPage.dart';
import 'package:flutter/material.dart';
import 'package:appcomunity/Model/Espais.dart';
import 'package:appcomunity/Pages/MainPage.dart';
import 'package:provider/provider.dart';

final Color mainColor = Color(0xFFff7f5c);
final Color secondaryColor = Color(0xFFfff7f5);

class LlistaEspaisWidget extends StatelessWidget {
  const LlistaEspaisWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Espais>>(
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

class PastillaEspai extends StatelessWidget {
  const PastillaEspai({
    Key key,
    @required this.espai,
  }) : super(key: key);

  final Espais espai;
  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NewReservaProvider>(context, listen: true);
    Color getColor() {
      if (myProvider.selectedEspai == this.espai) {
        return mainColor;
      } else {
        return secondaryColor;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          myProvider.setEspai(espai);
           myProvider.setFaltaEspai(false);
        },
        child: Card(
          color: getColor(),
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
      ),
    );
  }
}
