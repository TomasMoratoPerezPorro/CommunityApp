
import 'package:appcomunity/Model/Espais.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reserves {
  String id;
  DocumentReference espai;
  DocumentReference usuari;
  bool compartir;
  DateTime dataIni;
  DateTime dataFinal;
  

  DocumentReference get espairef => this.espai;
  
  Reserves(this.id, this.espai, this.dataIni, this.dataFinal, this.usuari, [this.compartir = true]);
  Reserves.fromFirestore(DocumentSnapshot docReserva) {
    id = docReserva.documentID;
    espai = docReserva.data['Espai'];
    usuari = docReserva.data['Usuari'];
    dataIni = docReserva.data['Data_ini'].toDate();
    dataFinal = docReserva.data['Data_final'].toDate();
    compartir = docReserva.data['Compartir'];
  }
}

addReserva(DateTime pickedTime, TimeOfDay time, Espais selectedEspai, int selectedDuracio) {
  
  DateTime dataIni = DateTime(pickedTime.year, pickedTime.month, pickedTime.day, time.hour, time.minute);
  
  final DocumentReference postRefEspai = Firestore.instance.document('Comunitat/ePxrAIn3mpLvfJBvBKtZ/Espais/${selectedEspai.id}');
  final DocumentReference postRefUsuari = Firestore.instance.document('Usuaris/rBusSKT1iicw0I2rUrhw');
  Firestore.instance.collection('Comunitat').document('ePxrAIn3mpLvfJBvBKtZ').collection('Reserves').add({
    'Data_ini': Timestamp.fromDate(dataIni),
    'Data_final': Timestamp.fromDate(dataIni.add(Duration(days: 0, hours: selectedDuracio, minutes: 0))),
    'Espai': postRefEspai,
    'Usuari': postRefUsuari,
  });
}

Stream<List<Reserves>> reservesSnapshots() {
  return Firestore.instance.collection('Comunitat').document('ePxrAIn3mpLvfJBvBKtZ').collection('Reserves').snapshots().map((QuerySnapshot query) {
    final List<DocumentSnapshot> docsReserves = query.documents;
    return docsReserves.map((docReserva) => Reserves.fromFirestore(docReserva)).toList();
  });
}







