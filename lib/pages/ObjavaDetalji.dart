import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/IzdavackaKuca.dart';
import 'package:nextgame_mobile/models/Komentar.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Objava.dart';
import 'package:nextgame_mobile/pages/IgraDetalji.dart';
import 'package:nextgame_mobile/pages/KomentarUnosEdit.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class ObjavaDetalji extends StatefulWidget {
  final Objava? objava;
  final Korisnik? korisnik;
  const ObjavaDetalji({Key? key, this.objava, this.korisnik}) : super(key: key);

  @override
  _ObjavaDetaljiState createState() => _ObjavaDetaljiState();
}

class _ObjavaDetaljiState extends State<ObjavaDetalji> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    DateTime? datumObjave;
    if (widget.objava?.datumObjave != null) {
      datumObjave = dateFormat.parse(widget.objava!.datumObjave.toString());
    }
    Future<List<Komentar>> GetKomentar() async {
      Komentar tempKomentar = new Komentar(Id: 0, objava: widget.objava);
      var komentar =
          await APIService.Get('Komentar', tempKomentar.toJsonSearch());
      var listaKomentara = komentar!.map((i) => Komentar.fromJson(i)).toList();
      return listaKomentara;
    }

    Future<void> UpdateKomentar(komentar, brojLajkova) async {
      Komentar noviKomentar = new Komentar(
          Id: komentar.Id,
          datumPostavljanja: komentar.datumPostavljanja,
          objava: widget.objava,
          sadrzaj: komentar.sadrzaj,
          brojLajkova: brojLajkova);
      var kometar = await APIService.Update(
          "Komentar", jsonEncode(noviKomentar.toJsonUpdate()), noviKomentar.Id);
    }

    Widget commentWidget(komentar) {
      return Card(
        color: Color.fromRGBO(172, 252, 217, 1),
        margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: InkWell(
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => KomentarUnosEdit(
                      objava: widget.objava,
                      user: widget.korisnik,
                      ispis: "Edituj komentar",
                      komentar: komentar,
                    )))},
          child: Container(
            height: MediaQuery.of(context).size.height / 3.9,
            width: MediaQuery.of(context).size.width * 0.94,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
                  child: Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: Theme.of(context).canvasColor,
                          radius: 20,
                          backgroundImage: MemoryImage(
                              Uint8List.fromList(komentar!.korisnik!.Slika))),
                      Text(
                        komentar!.korisnik!.Username,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          "Postavljeno: " +
                              komentar!.datumPostavljanja.substring(0, 10),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          komentar!.sadrzaj,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Column(
                    children: [
                      Text(komentar!.brojLajkova.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                      IconButton(
                          onPressed: () async {
                            var temp = await UpdateKomentar(
                                komentar, komentar.brojLajkova + 1);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_circle_up,
                            color: Colors.black,
                            size: 40,
                          )),
                      IconButton(
                          onPressed: () async {
                            var temp = await UpdateKomentar(
                                komentar, komentar.brojLajkova - 1);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_circle_down,
                            color: Colors.black,
                            size: 40,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget bodyBuilder() {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 35),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  child: Image(
                      image: MemoryImage(
                          Uint8List.fromList(widget.objava!.igrica!.slika))),
                ),
                Text(
                  widget.objava!.naslov,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: Text(
              "Datum objavljivanja: " +
                  datumObjave!.day.toString() +
                  "." +
                  datumObjave.month.toString() +
                  "." +
                  datumObjave.year.toString(),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Text(
              "Autor: " + widget.objava!.autor,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 35),
            child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IgraDetalji(
                                  igrica: widget.objava!.igrica,
                                )));
                  },
                  child: Column(
                    children: [
                      Text(
                        widget.objava!.igrica!.naziv,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Više o igrici...",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.indigo,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
            child: Text(
              widget.objava!.sadrzaj,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      );
    }

    Widget commentBuilder() {
      return FutureBuilder<List<Komentar>>(
        future: GetKomentar(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Komentar>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitFadingFour(
              color: Colors.white,
              size: 50.0,
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return Wrap(
                direction: Axis.vertical,
                children: snapshot.data!.map((e) => commentWidget(e)).toList(),
              );
            }
          }
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Detalji objave'),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                bodyBuilder(),
                Text(
                  "Komentari",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => KomentarUnosEdit(
                                    objava: widget.objava,
                                    user: widget.korisnik,
                                  )));
                    },
                    child: Text("Dodaj novi komentar"),
                  ),
                ),
                commentBuilder(),
              ],
            )));
  }
}
