import 'package:cloud_firestore/cloud_firestore.dart';


class Usuaris {
  String id;
  String nom;
  DocumentReference comunitat;
  String pis;
  
  Usuaris(this.id, this.nom, this.comunitat, this.pis);
  Usuaris.fromFirestore(DocumentSnapshot docUsuari) {
    id = docUsuari.documentID;
    nom = docUsuari.data['Name'];
    pis = docUsuari.data['Pis'];
    comunitat = docUsuari.data['Comunitat'];
  }
}

Stream<List<Usuaris>> usuarisSnapshots() {
  return Firestore.instance.collection('Usuaris').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docsUsuaris = query.documents;
    return docsUsuaris.map((docUsuari) => Usuaris.fromFirestore(docUsuari)).toList();
  });
}