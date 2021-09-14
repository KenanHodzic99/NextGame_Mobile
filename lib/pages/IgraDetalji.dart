import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Recenzija.dart';
import 'package:nextgame_mobile/pages/RecenzijaUnosEdit.dart';
import 'package:nextgame_mobile/pages/gameListAdd.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:convert';
import 'package:nextgame_mobile/pages/publishingLabel.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class IgraDetalji extends StatefulWidget {
  final Igra? igrica;
  final Korisnik? user;
  IgraDetalji({Key? key, this.igrica, this.user}) : super(key: key);

  @override
  _IgraDetaljiState createState() => _IgraDetaljiState();
}

class _IgraDetaljiState extends State<IgraDetalji> {
  @override
  Widget build(BuildContext context) {

    Future<List<Recenzija>> GetRecenzija() async {
      Recenzija tempRecenzija= new Recenzija(Id: 0, igrica: widget.igrica);
      var recenzija =
      await APIService.Get('Recenzija', tempRecenzija.toJsonSearch());
      var listaRecenzija = recenzija!.map((i) => Recenzija.fromJson(i)).toList();
      return listaRecenzija;
    }

    Future<void> UpdateRecenzija(stararecenzija, isPrijavljena) async {
      Recenzija novaRecenzija = new Recenzija(
          Id: stararecenzija.Id,
          isPrijavljena: isPrijavljena
      );
      var recenzija = await APIService.Update(
          "Recenzija", jsonEncode(novaRecenzija.toJsonUpdate()), novaRecenzija.Id);
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
                  child: IconButton(
                      onPressed: (){
                        setState(() {
                          UpdateRecenzija(recenzija, true);
                          setState(() {

                          });
                        });
                      },
                      icon: Icon(
                        Icons.report,
                        size: 30,
                        color: recenzija.isPrijavljena ? Colors.red : Colors.black,
                      )),
                )
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
          if(snapshot.data!.length < 1){
            return SpinKitFadingFour(
              color: Colors.white,
              size: 50.0,
            );
          }
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
              if(snapshot.data!.length < 1){
                return SpinKitFadingFour(
                  color: Colors.white,
                  size: 50.0,
                );
              }
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
          title: Text('Detalji igrice'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 35),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Image(
                          image:
                              MemoryImage(Uint8List.fromList(widget.igrica!.slika))),
                    ),
                    Text(
                      widget.igrica!.naziv,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 35),
                child: Column(
                  children: [
                    Icon(
                      Icons.stars,
                      size: 70,
                      color: Colors.white,
                    ),
                    Text(
                      widget.igrica!.ocjena == "0"
                          ? "Nema ocjene."
                          : widget.igrica!.ocjena.toString().length>4 ? widget.igrica!.ocjena.toString().substring(0,4) + "/5" : widget.igrica!.ocjena.toString()+ "/5",
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
                  widget.igrica!.opis,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Wrap(direction: Axis.vertical, children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Datum izdavanja:",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.igrica!.datumIzdavanja!.day.toString() +
                                    "." +
                                    widget.igrica!.datumIzdavanja!.month.toString() +
                                    "." +
                                    widget.igrica!.datumIzdavanja!.year.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 0, 0, 20),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => publishingLabel(
                                            izdavackaKuca:
                                                widget.igrica!.izdavackaKuca,
                                          )));
                            },
                            child: Column(
                              children: [
                                Text(
                                  "Izdavačka kuća:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Text(
                                    widget.igrica!.izdavackaKuca!.naziv,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Više o izdavaču...",
                                  style: TextStyle(
                                    color: Colors.indigo,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ]),
              Wrap(direction: Axis.vertical, children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 35),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text(
                                "Žanr:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  widget.igrica!.zanrovi,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 0, 0, 35),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Text(
                                "Tip:",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  widget.igrica!.tip,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 20, 35),
                      child: Column(
                        children: [
                          Text(
                            "Cijena:",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Text(
                              widget.igrica!.cijena + "€",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Minimalni potrebni hardver:",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      "OS: " + widget.igrica!.sysReq!.operativniSistem,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "CPU: " + widget.igrica!.sysReq!.procesor,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "GPU: " + widget.igrica!.sysReq!.grafickaKartica,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "RAM: " + widget.igrica!.sysReq!.ram,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Memorija: " + widget.igrica!.sysReq!.memorija,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "Korisničke recenzije:",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 130.0),
                          child: IconButton(
                            onPressed: () => {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => RecenzijaUnosEdit(
                            igrica: widget.igrica,
                              user: widget.user,
                            )))
                            },
                            icon: Icon(Icons.add_box_sharp, color: Colors.white, size: 30,),
                          ),
                        ),
                      ],
                    )),
              ),
              recenzijaBuilder()
            ],
          ),
        ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => gameListAdd(
                user: widget.user,
                igrica: widget.igrica,
              ))),
      child: const Icon(Icons.add),
    ),);
  }
}
