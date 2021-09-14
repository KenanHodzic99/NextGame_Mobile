import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/IzdavackaKuca.dart';

class publishingLabel extends StatelessWidget {
  final IzdavackaKuca? izdavackaKuca;
  publishingLabel({Key? key, this.izdavackaKuca}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    DateTime? datumOsnivanja;
    if (izdavackaKuca?.datumOsnivanja != null) {
      datumOsnivanja =
          dateFormat.parse(izdavackaKuca!.datumOsnivanja.toString());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalji izdavačke kuće'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 35),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image(
                            image: MemoryImage(
                                Uint8List.fromList(izdavackaKuca!.slika))),
                      ),
                      Text(
                        izdavackaKuca!.naziv,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                  child: Text(
                    izdavackaKuca!.opis,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Text(
                    "Datum osnivanja: " +
                        datumOsnivanja!.day.toString() +
                        "." +
                        datumOsnivanja.month.toString() +
                        "." +
                        datumOsnivanja.year.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Text(
                    "Osnivači :" + izdavackaKuca!.osnivaci,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Text(
                    "Mjesto osnivnja: " + izdavackaKuca!.mjestoOsnivanja,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Text(
                    "Sjedište: " + izdavackaKuca!.sjediste,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                  child: Text(
                    "Broj zaposlenika: " + izdavackaKuca!.brojZaposlenika,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
