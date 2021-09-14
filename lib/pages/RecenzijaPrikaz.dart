import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Recenzija.dart';
import 'package:nextgame_mobile/pages/RecenzijaUnosEdit.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class RecenzijaPrikaz extends StatefulWidget {
  final Korisnik? user;
  const RecenzijaPrikaz({Key? key, this.user}) : super(key: key);

  @override
  _RecenzijaPrikazState createState() => _RecenzijaPrikazState();
}

class _RecenzijaPrikazState extends State<RecenzijaPrikaz> {
  @override
  Widget build(BuildContext context) {

    Future<List<Recenzija>> GetRecenzija() async {
      Recenzija tempRecenzija= new Recenzija(Id: 0, korisnik: widget.user);
      var recenzija =
      await APIService.Get('Recenzija', tempRecenzija.toJsonSearch());
      var listaRecenzija = recenzija!.map((i) => Recenzija.fromJson(i)).toList();
      return listaRecenzija;
    }

    Widget recenzijaWidget(recenzija) {
      return Card(
        color: Color.fromRGBO(172, 252, 217, 1),
        margin: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: InkWell(
          onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => RecenzijaUnosEdit(
          igrica: recenzija!.igrica,
          user: widget.user,
            ispis: "Edituj recenziju",
            recenzija: recenzija,
          )));},
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
                          backgroundImage:
                          MemoryImage(Uint8List.fromList(recenzija!.korisnik!.Slika))),
                      Text(
                        recenzija!.korisnik!.Username,
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
                              recenzija!.datumPostavljanja.substring(0, 10),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                        child: Text(
                          recenzija!.sadrzaj,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                          "Ocjena: " + recenzija!.ocjena.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,80.0,0, 0),
                        child: Icon(
                              Icons.report,
                              size: 30,
                              color: recenzija.isPrijavljena ? Colors.red : Colors.black,
                            )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Widget recenzijaBuilder() {
      return FutureBuilder<List<Recenzija>>(
        future: GetRecenzija(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Recenzija>> snapshot) {
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
                children: snapshot.data!.map((e) => recenzijaWidget(e)).toList(),
              );
            }
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Korisničke recenzije'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: recenzijaBuilder()),
    );
  }
}
