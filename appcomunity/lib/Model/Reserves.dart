
import 'package:cloud_firestore/cloud_firestore.dart';

class Reserves {
  String id;
  String espai;
  bool compartir;
  DateTime dataIni;
  DateTime dataFinal;
  
  Reserves(this.espai, this.dataIni, this.dataFinal, [this.compartir = true]);
  Reserves.fromFirestore(DocumentSnapshot doc) {
    id = doc.documentID;
    espai = doc.data['Espai'];
    dataIni = doc.data['Data_ini'];
    dataFinal = doc.data['Data_final'];
    compartir = doc.data['Compartir'];
  }
}

Stream<List<Reserves>> todoListSnapshots() {
  return Firestore.instance.collection('Reserves').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docs = query.documents;
    return docs.map((doc) => Reserves.fromFirestore(doc)).toList();
  });
}
