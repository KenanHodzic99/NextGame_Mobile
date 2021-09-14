
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Recenzija.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class RecenzijaUnosEdit extends StatefulWidget {
  final Igra? igrica;
  final Korisnik? user;
  final String? ispis;
  final Recenzija? recenzija;
  const RecenzijaUnosEdit({Key? key, this.igrica, this.user, this.ispis, this.recenzija}) : super(key: key);

  @override
  _RecenzijaUnosEditState createState() => _RecenzijaUnosEditState();
}

class _RecenzijaUnosEditState extends State<RecenzijaUnosEdit> {
  TextEditingController sadrzajRecenzijeController = new TextEditingController();
  TextEditingController ocjenaController = new TextEditingController();
  TextEditingController vrijemeIgranjaController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var result;

  Future<void> postData(Recenzija _recenzija) async {
    result = await APIService.Post('Recenzija', jsonEncode(_recenzija.toJson()));
  }

  Future<void> updateData(Recenzija _recenzija) async {
    result = await APIService.Update('Recenzija', jsonEncode(_recenzija.toJsonUpdate()), _recenzija.Id);
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
        hintText: widget.ispis ==null ? "Ocjena igrice." : widget.recenzija!.ocjena.toString(),
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
        hintText: widget.ispis==null?"Vrijeme igranja igrice." : widget.recenzija!.vrijemeIgranja,
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

    final recenzijaField = TextFormField(
      controller: sadrzajRecenzijeController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite opis recenzije!";
        }
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.ispis==null?"Sadržaj recenzije.": widget.recenzija!.sadrzaj,
        labelText: "Recenzija:",
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
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: recenzijaField),
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
          widget.ispis==null?"Postavi recenziju": widget.ispis as String,
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
              Recenzija novaRecenzija = new Recenzija(
                  Id: 0,
                  korisnik: widget.user,
                  ocjena: double.parse(ocjenaController.text),
                  datumPostavljanja: DateTime.now().toLocal()
                      .toIso8601String()
                      .substring(0, 16),
                  igrica: widget.igrica,
                  isPrijavljena: false,
                  sadrzaj: sadrzajRecenzijeController.text,
                  vrijemeIgranja: vrijemeIgranjaController.text);
              await postData(novaRecenzija);
            }
            else{
              Recenzija novaRecenzija = new Recenzija(
                  Id: widget.recenzija!.Id,
                  korisnik: widget.user,
                  ocjena: ocjenaController.text.isNotEmpty ? double.parse(ocjenaController.text): widget.recenzija!.ocjena,
                  datumPostavljanja: DateTime.now().toLocal()
                      .toIso8601String()
                      .substring(0, 16),
                  igrica: widget.igrica,
                  isPrijavljena: widget.recenzija!.isPrijavljena,
                  sadrzaj: sadrzajRecenzijeController.text.isEmpty? widget.recenzija!.sadrzaj : sadrzajRecenzijeController.text,
                  vrijemeIgranja: vrijemeIgranjaController.text.isEmpty? widget.recenzija!.vrijemeIgranja : vrijemeIgranjaController.text);
              await updateData(novaRecenzija);
            }
            if (result != null) {
              final snackBar = SnackBar(
                  content: const Text("Uspjesno ste dodali/uredili recenziju!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );



    return Scaffold(appBar: AppBar(
      title: Text( widget.ispis==null?'Recenzija':widget.ispis as String),
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
