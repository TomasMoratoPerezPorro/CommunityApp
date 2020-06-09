import 'package:appcomunity/Model/Espais.dart';
import 'package:appcomunity/Model/Reserves.dart';
import 'package:appcomunity/Widgets/LlistaEspaisWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReservaProvider with ChangeNotifier {
  NewReservaProvider(reservesExistents) {
    this.reservesExistents = reservesExistents;
    coincidencia = comprobarDisponibilitat();
    if (coincidencia) {
      this.coincidencia = coincidencia;
      notifyListeners();
    }
  }

  DateTime pickedDate = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  Espais selectedEspai;
  int selectedDuracio = 1;
  List<Reserves> reservesExistents;
  bool coincidencia = false;
  bool faltaEspai = false;

  void setDuracio(int duracio) {
    this.selectedDuracio = duracio;
    notifyListeners();
  }

  setFaltaEspai(bool flag){
    this.faltaEspai=flag;
  }

  void setDate(DateTime date) {
    //  print(date.toString());
    this.pickedDate = date;
    notifyListeners();
    coincidencia = comprobarDisponibilitat();
    if (coincidencia) {
      this.coincidencia = coincidencia;
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

  bool comprobarEspai() {
    if (this.selectedEspai == null) {
      this.faltaEspai = true;
      notifyListeners();
      return false;
    } else {
      return true;
    }
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
        appBar: AppBar(
          title: Text('New Reserva'),
          backgroundColor: mainColor,
        ),
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
    final myProvider = Provider.of<NewReservaProvider>(context, listen: true);
    return Column(
      children: <Widget>[
        myProvider.faltaEspai ? AlertCoincidencia(fraseAlert: "Selecciona un espai !") : Text(""),
        Padding(
          padding: const EdgeInsets.all(20),
          child: RaisedButton(
            child: Container(
              margin: EdgeInsets.all(10),
              width: 200,
              child: Text(
                "RESERVA ARA",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            color: mainColor,
            onPressed: () {
              if (myProvider.comprobarEspai()) {
                myProvider.saveReserva();
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
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
        return mainColor;
      } else {
        return secondaryColor;
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
      TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: myProvider.time,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: mainColor, //Head background
              accentColor: mainColor, //selection color
              //dialogBackgroundColor: Colors.white,//Background color
              colorScheme: ColorScheme.light(primary: mainColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
      );

      if (t != null) myProvider.setTime(t);
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("Selecciona la hora de inici:"),
                margin: EdgeInsets.all(10),
              ),
              ListTile(
                title: Text(
                  "Date: ${myProvider.time.hour}, ${myProvider.time.minute}",
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickTime,
              ),
            ],
          ),
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
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: mainColor, //Head background
              accentColor: mainColor, //selection color
              //dialogBackgroundColor: Colors.white,//Background color
              colorScheme: ColorScheme.light(primary: mainColor),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          );
        },
      );

      if (date != null) myProvider.setDate(date);
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text("Selecciona el dia:"),
                margin: EdgeInsets.all(10),
              ),
              ListTile(
                title: Text(
                  "Date: ${myProvider.pickedDate.year}, ${myProvider.pickedDate.month}, ${myProvider.pickedDate.day}",
                  style:
                      TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                onTap: _pickDate,
              ),
              myProvider.coincidencia ? AlertCoincidencia(fraseAlert: "Hi ha reserves el mateix dia") : Text(""),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertCoincidencia extends StatelessWidget {
  const AlertCoincidencia({
    Key key,
    @required this.fraseAlert,
  }) : super(key: key);

  final String fraseAlert;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10),
      height: 30,
      width: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        color: Colors.red[300],
      ),
      child: Center(
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Icon(
              Icons.feedback,
              size: 14,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              this.fraseAlert,
              style: TextStyle(color: Colors.white),
            ),
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Selecciona el espai:",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              LlistaEspaisWidget(),
            ],
          ),
        )),
      ),
    );
  }
}
