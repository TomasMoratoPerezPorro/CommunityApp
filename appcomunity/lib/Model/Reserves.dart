
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