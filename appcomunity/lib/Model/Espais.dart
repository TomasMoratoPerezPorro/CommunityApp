
import 'package:cloud_firestore/cloud_firestore.dart';

class Espais {
  String id;
  String nom;
  Timestamp limitIni;
  Timestamp limitFinal;
  
  Espais(this.id, this.nom, this.limitIni, this.limitFinal);
  Espais.fromFirestore(DocumentSnapshot docEspai) {
    id = docEspai.documentID;
    nom = docEspai.data['Name'];
    limitIni = docEspai.data['Limit_ini'];
    limitFinal = docEspai.data['Limit_final'];
  }
}

Stream<List<Espais>> espaisSnapshots() {
  return Firestore.instance.collection('Comunitat').document('ePxrAIn3mpLvfJBvBKtZ').collection('Espais').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docsEspais = query.documents;
    return docsEspais.map((docEspai) => Espais.fromFirestore(docEspai)).toList();
  });
}