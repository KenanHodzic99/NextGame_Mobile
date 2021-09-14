import 'package:flutter/material.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/IzdavackaKuca.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/Game.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class IgraSearch extends StatefulWidget {
  DateTime pickedDate = DateTime.now();
  bool odabrano = false;
  final Korisnik? user;
  IgraSearch({Key? key, this.user}) : super(key: key);

  @override
  _IgraSearchState createState() => _IgraSearchState();
}

class _IgraSearchState extends State<IgraSearch> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nazivController = new TextEditingController();
  TextEditingController ocjenaController = new TextEditingController();
  TextEditingController cijenaController = new TextEditingController();
  List<DropdownMenuItem> items = [];
  IzdavackaKuca? _odabranaKuca;
  @override
  Widget build(BuildContext context) {
    final nazivField = TextFormField(
      controller: nazivController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "Naziv igre...",
          labelText: "Naziv igre:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: widget.pickedDate,
          firstDate: DateTime(1990),
          lastDate: DateTime(2101));
      if (picked != null && picked != widget.pickedDate)
        setState(() {
          widget.pickedDate = picked;
          widget.odabrano = true;
        });
    }

    final ocjenaPicker = TextFormField(
      controller: ocjenaController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (ocjenaController.text.isNotEmpty) {
          if (int.parse(value!) > 5 || int.parse(value) < 0) {
            return "Ocjena mora biti između 0 i 5!";
          }
        }
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "Unesite ocjenu ovdje...",
          labelText: "Ocjena:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final cijenaPicker = TextFormField(
      controller: cijenaController,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "Unesite cijenu ovdje...",
          labelText: "Cijena:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    Future<List<IzdavackaKuca>> getIzdavacka() async {
      var izdavacka = await APIService.Get('IzdavackaKuca', null);
      var listIzdavacka =
          izdavacka!.map((i) => IzdavackaKuca.fromJson(i)).toList();

      items = listIzdavacka.map((IzdavackaKuca item) {
        return DropdownMenuItem<IzdavackaKuca>(
          child: Text(item.naziv),
          value: item,
        );
      }).toList();

      return listIzdavacka;
    }

    Widget dropDownWidget() {
      return FutureBuilder<List<IzdavackaKuca>>(
          future: getIzdavacka(),
          builder: (BuildContext context,
              AsyncSnapshot<List<IzdavackaKuca>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: DropdownButton<dynamic>(
                    hint: Text(
                      'Odaberite izdavacku kuću',
                      style: TextStyle(color: Colors.white),
                    ),
                    isExpanded: true,
                    items: items,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    iconSize: 24,
                    dropdownColor: Color.fromRGBO(33, 66, 68, 1),
                    style: const TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      width: 100,
                      color: Colors.white,
                    ),
                    onChanged: (newVal) {
                      setState(() {
                        _odabranaKuca = newVal;
                      });
                    },
                  ),
                );
              }
            }
          });
    }

    final searchFields = Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: nazivField),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(33, 66, 68, 1),
                      minimumSize: Size(double.infinity, 50)),
                  onPressed: () => _selectDate(context),
                  child: Text('Odaberite godinu izdanja'),
                ),
                Text(
                  widget.odabrano == false
                      ? ""
                      : "Odabrana godina: " + widget.pickedDate.year.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10), child: ocjenaPicker),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10), child: cijenaPicker),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
              child: dropDownWidget()),
        ],
      ),
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color.fromRGBO(33, 66, 68, 1),
      child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width / 1.2,
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Text(
            "Pretraži",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              Igra _filter = new Igra(
                  igraId: 0,
                  naziv:
                      nazivController.text.isEmpty ? "" : nazivController.text,
                  ocjena: ocjenaController.text.isEmpty
                      ? ""
                      : ocjenaController.text,
                  opis: "",
                  slika: [],
                  sysReq: null,
                  datumIzdavanja: widget.odabrano ? widget.pickedDate : null,
                  izdavackaKuca: _odabranaKuca,
                  tip: "",
                  cijena: cijenaController.text.isEmpty
                      ? ""
                      : cijenaController.text,
                  zanrovi: "");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Game(
                            filter: _filter,
                        user: widget.user,
                          )));
            }
          }),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pretraga igrica'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Column(
            children: [searchFields, submitButton],
          ),
        ),
      ),
    );
  }
}
