
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/ListaIgrica.dart';
import 'package:nextgame_mobile/models/Recenzija.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class gameListAdd extends StatefulWidget {
  final Igra? igrica;
  final Korisnik? user;
  final String? ispis;
  final ListaIgrica? igralista;
  const gameListAdd({Key? key, this.igrica, this.user, this.ispis, this.igralista}) : super(key: key);

  @override
  _gameListAddState createState() => _gameListAddState();
}

class _gameListAddState extends State<gameListAdd> {
  TextEditingController ocjenaController = new TextEditingController();
  TextEditingController vrijemeIgranjaController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var result;

  Future<void> postData(ListaIgrica _gameList) async {
    result = await APIService.Post('ListaIgrica', jsonEncode(_gameList.toJson()));
  }

  Future<void> updateData(ListaIgrica _gameList) async {
    result = await APIService.Update('ListaIgrica', jsonEncode(_gameList.toJsonUpdate()),_gameList.Id);
  }

  @override
  Widget build(BuildContext context) {

    final ocjenaField = TextFormField(
      controller: ocjenaController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite ocjenu!";
        }
        if(double.parse(value) > 5.0 || double.parse(value) < 0.0){
          return "Ocjena mora biti između 0 i 5!";
        }
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.igralista == null ? "Ocjena igrice." : widget.igralista?.ocjena.toString(),
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
        ),
      ),
    );

    final vrijemeIgranjaField = TextFormField(
      controller: vrijemeIgranjaController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite vrijeme igranja!";
        }
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.igralista == null ? "Vrijeme igranja igrice." : widget.igralista?.sati,
        labelText: "Vrijeme igranja:",
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
        ),
      ),
    );

    final fields = Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image(
              image: MemoryImage(Uint8List.fromList(widget.igrica!.slika))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: ocjenaField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: vrijemeIgranjaField),
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
          widget.ispis == null ? "Dodaj u listu" : widget.ispis as String,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if(widget.ispis == null) {
              ListaIgrica nova = new ListaIgrica(
                Id: 0,
                korisnik: widget.user,
                igrica: widget.igrica,
                sati: vrijemeIgranjaController.text,
                ocjena: double.parse(ocjenaController.text),
              );
              await postData(nova);
            }
            else{
              ListaIgrica nova = new ListaIgrica(
                Id: widget.igralista?.Id,
                korisnik: widget.user,
                igrica: widget.igrica,
                sati: vrijemeIgranjaController.text.isEmpty ? widget.igralista?.sati : vrijemeIgranjaController.text,
                ocjena: ocjenaController.text.isNotEmpty? double.parse(ocjenaController.text) : widget.igralista?.ocjena,
              );
              await updateData(nova);
            }
            if (result != null) {
              final snackBar = SnackBar(
                  content: const Text("Uspjesno ste dodali/editovali igricu na listu!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );



    return Scaffold(appBar: AppBar(
      title: Text(widget.ispis == null ? 'Dodaj u listu igrica' : widget.ispis as String),
    ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [fields, submitButton],
          ),
        ),
      ),);
  }
}
