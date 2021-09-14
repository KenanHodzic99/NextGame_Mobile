import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nextgame_mobile/models/Komentar.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Objava.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class KomentarUnosEdit extends StatelessWidget {
  final Korisnik? user;
  final Objava? objava;
  final String? ispis;
  final Komentar? komentar;
  KomentarUnosEdit({Key? key, this.objava, this.user, this.ispis, this.komentar}) : super(key: key);

  @override
  TextEditingController sadrzajKomentaraController =
      new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var result;

  Future<void> postData(Komentar _comment) async {
    result = await APIService.Post('Komentar', jsonEncode(_comment.toJson()));
  }

  Future<void> updateData(Komentar _comment) async {
    result = await APIService.Update('Komentar', jsonEncode(_comment.toJson()), _comment.Id);
  }

  Widget build(BuildContext context) {
    final commentField = TextFormField(
      controller: sadrzajKomentaraController,
      maxLines: 5,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite komentar!";
        }
      },
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: ispis == null ? "Sadržaj komentara." : komentar!.sadrzaj,
        labelText: "Komentar:",
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
          CircleAvatar(
              backgroundColor: Theme.of(context).canvasColor,
              radius: 80,
              backgroundImage: MemoryImage(Uint8List.fromList(user!.Slika))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: commentField),
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
          ispis==null ? "Postavi komentar" : ispis as String,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if(ispis == null) {
              Komentar noviKomentar = new Komentar(
                  Id: 0,
                  brojLajkova: 0,
                  sadrzaj: sadrzajKomentaraController.text,
                  objava: objava,
                  korisnik: user,
                  datumPostavljanja: DateTime.now().toIso8601String());
              await postData(noviKomentar);
            }
            else{
              Komentar noviKomentar = new Komentar(
                  Id: komentar!.Id,
                  brojLajkova: komentar!.brojLajkova,
                  sadrzaj: sadrzajKomentaraController.text.isEmpty ? komentar!.sadrzaj : sadrzajKomentaraController.text,
                  objava: objava,
                  korisnik: user,
                  datumPostavljanja: DateTime.now().toIso8601String());
              await updateData(noviKomentar);
            }
            if (result != null) {
              final snackBar = SnackBar(
                  content: const Text("Uspjesno ste dodali/uredili komentar!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Komentar'),
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
      ),
    );
  }
}
