import 'package:appcomunity/Pages/NewReservaPage.dart';
import 'package:flutter/material.dart';
import 'package:appcomunity/Model/Espais.dart';
import 'package:provider/provider.dart';

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
     Color getColor(){
       if(myProvider.selectedEspai==this.espai){
         return Colors.red;
       }else{
         return Colors.grey[350];
       }
     } 
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: (){
          myProvider.setEspai(espai);
        },
        child: Card(
          color: getColor(),
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
      ),
    );
  }
}
