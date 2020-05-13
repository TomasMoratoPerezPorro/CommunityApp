
import 'package:cloud_firestore/cloud_firestore.dart';

class Reserves {
  String id;
  DocumentReference espai;
  DocumentReference usuari;
  bool compartir;
  Timestamp dataIni;
  Timestamp dataFinal;
  
  Reserves(this.id, this.espai, this.dataIni, this.dataFinal, this.usuari, [this.compartir = true]);
  Reserves.fromFirestore(DocumentSnapshot docReserva) {
    id = docReserva.documentID;
    espai = docReserva.data['Espai'];
    usuari = docReserva.data['Usuari'];
    dataIni = docReserva.data['Data_ini'];
    dataFinal = docReserva.data['Data_final'];
    compartir = docReserva.data['Compartir'];
  }
}

Stream<List<Reserves>> reservesSnapshots() {
  return Firestore.instance.collection('Comunitat').document('ePxrAIn3mpLvfJBvBKtZ').collection('Reserves').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docsReserves = query.documents;
    return docsReserves.map((docReserva) => Reserves.fromFirestore(docReserva)).toList();
  });
}


