import 'package:appcomunity/Model/Espais.dart';
import 'package:appcomunity/Model/Reserves.dart';
import 'package:appcomunity/Widgets/LlistaEspaisWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReservaProvider with ChangeNotifier {
  NewReservaProvider(reservesExistents) {
    this.reservesExistents = reservesExistents;
  }

  DateTime pickedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  Espais selectedEspai;
  int selectedDuracio = 1;
  List<Reserves> reservesExistents;
  bool coincidencia = false;

  void setDuracio(int duracio) {
    this.selectedDuracio = duracio;
    notifyListeners();
  }

  void setDate(DateTime date) {
    //  print(date.toString());
    this.pickedDate = date;
    notifyListeners();
    coincidencia = comprobarDisponibilitat();
    if(coincidencia){
      this.coincidencia=coincidencia;
      notifyListeners();
    }

  }

  void setTime(TimeOfDay hora) {
    //   print(hora.toString());
    this.time = hora;
    notifyListeners();
  }

  void setEspai(Espais espai) {
    this.selectedEspai = espai;
    notifyListeners();
  }

  void saveReserva() {
    addReserva(
        this.pickedDate, this.time, this.selectedEspai, this.selectedDuracio);
  }

  bool comprobarDisponibilitat() {
    for (var i = 0; i < this.reservesExistents.length; i++) {
      if (this.reservesExistents[i].dataIni.day == this.pickedDate.day) {
        return true;
      }
    }
    return false;
  }
}

class NewReservaPage extends StatelessWidget {
  const NewReservaPage({
    Key key,
    @required this.reserves,
  }) : super(key: key);

  final List<Reserves> reserves;
  @override
  Widget build(BuildContext context) {
    print("OBJECTE RESERVAS PUSH: ${reserves[0].dataIni}");
    return Scaffold(
        appBar: AppBar(title: Text('New Reserva')),
        body: FormNewReservaWidget(
          reserves: reserves,
        ));
  }
}

class FormNewReservaWidget extends StatelessWidget {
  const FormNewReservaWidget({
    Key key,
    @required this.reserves,
  }) : super(key: key);

  final List<Reserves> reserves;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewReservaProvider>(
        create: (context) => NewReservaProvider(reserves),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FieldEspaiWidget(),
              FieldDiaWidget(),
              FieldHoraWidget(),
              FieldDuracioWidget(),
              SubmitButton()
            ],
          ),
        ));
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NewReservaProvider>(context, listen: false);
    return RaisedButton(
      child: Text("Submit"),
      onPressed: () {
        myProvider.saveReserva();
      },
    );
  }
}

class FieldDuracioWidget extends StatelessWidget {
  const FieldDuracioWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NewReservaProvider>(context, listen: true);
    Color getColor(int i) {
      if (myProvider.selectedDuracio == i) {
        return Colors.red;
      } else {
        return Colors.grey[350];
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10),
              child: Text("Selecciona la hora de inici:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                for (var i = 1; i < 5; i++)
                  RaisedButton(
                    color: getColor(i),
                    onPressed: () {
                      myProvider.setDuracio(i);
                    },
                    child: Text("${i} Hora"),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FieldHoraWidget extends StatelessWidget {
  const FieldHoraWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NewReservaProvider>(context, listen: true);
    _pickTime() async {
      TimeOfDay t =
          await showTimePicker(context: context, initialTime: myProvider.time);

      if (t != null) myProvider.setTime(t);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Selecciona la hora de inici:"),
            ListTile(
              title: Text(
                  "Date: ${myProvider.time.hour}, ${myProvider.time.minute}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickTime,
            ),
          ],
        ),
      ),
    );
  }
}

class FieldDiaWidget extends StatelessWidget {
  const FieldDiaWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<NewReservaProvider>(context, listen: true);
    _pickDate() async {
      DateTime date = await showDatePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDate: myProvider.pickedDate,
      );

      if (date != null) myProvider.setDate(date);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Selecciona el dia:"),
            ListTile(
              title: Text(
                  "Date: ${myProvider.pickedDate.year}, ${myProvider.pickedDate.month}, ${myProvider.pickedDate.day}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickDate,
            ),
           myProvider.coincidencia ? Text("Hi ha reserves el mateix dia.") : Text(""),
          ],
        ),
      ),
    );
  }
}

class FieldEspaiWidget extends StatelessWidget {
  const FieldEspaiWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Selecciona el espai:",
            textAlign: TextAlign.left,
          ),
          LlistaEspaisWidget(),
        ],
      ),
    ));
  }
}
