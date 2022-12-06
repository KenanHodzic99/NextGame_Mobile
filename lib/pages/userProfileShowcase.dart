import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/gameList.dart';

class userProfileShowcase extends StatelessWidget {
  final Korisnik? user;
  userProfileShowcase({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
    DateTime? datumRodenja;
    if (user?.datumRodenja != null) {
      datumRodenja = dateFormat.parse(user!.datumRodenja.toString());
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('Korisnički profil'),
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
                      child: CircleAvatar(
                          backgroundColor: Theme.of(context).canvasColor,
                          radius: 80,
                          backgroundImage:
                          MemoryImage(Uint8List.fromList(user!.Slika)))
                    ),
                    Text(
                      user!.Username,
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
                  user?.Opis == null
                      ? "Nema opisa."
                      : user!.Opis!.isEmpty
                          ? "Nema opisa."
                          : user!.Opis.toString(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 35),
                child: Text(
                  "Lične informacije",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(direction: Axis.vertical, children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ime: " +
                              (user?.kontakt?.ime == null
                                  ? "Nije uneseno."
                                  : user!.kontakt!.ime!.isEmpty
                                      ? "Nije uneseno."
                                      : user!.kontakt!.ime.toString()),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 25),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Prezime: " +
                                (user?.kontakt?.prezime == null
                                    ? "Nije uneseno."
                                    : user!.kontakt!.prezime!.isEmpty
                                        ? "Nije uneseno."
                                        : user!.kontakt!.prezime.toString()),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ]),
              Wrap(direction: Axis.vertical, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 25),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Datum rođenja: " +
                          (datumRodenja == null
                              ? "Nije unesen."
                              : datumRodenja.day.toString() +
                                  "." +
                                  datumRodenja.month.toString() +
                                  "." +
                                  datumRodenja.year.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 35),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "E-mail: " +
                          (user?.kontakt?.email == null
                              ? "Nije uneseno."
                              : user!.kontakt!.email!.isEmpty
                                  ? "Nije uneseno."
                                  : user!.kontakt!.email.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(80, 10, 20, 20),
                  child: Column(
                    children: [
                      Text(
                        "Lokacija",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        "Kontinent: " +
                            (user?.adresa?.kontinent == null
                                ? "Nije uneseno."
                                : user!.adresa!.kontinent!.isEmpty
                                    ? "Nije uneseno."
                                    : user!.adresa!.kontinent.toString()),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      "Država: " +
                          (user?.adresa?.drzava == null
                              ? "Nije uneseno."
                              : user!.adresa!.drzava!.isEmpty
                                  ? "Nije uneseno."
                                  : user!.adresa!.drzava.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Grad: " +
                          (user?.adresa?.grad == null
                              ? "Nije uneseno."
                              : user!.adresa!.grad!.isEmpty
                                  ? "Nije uneseno."
                                  : user!.adresa!.grad.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Poštanski broj: " +
                          (user?.adresa?.postanskiBroj == null
                              ? "Nije uneseno."
                              : user!.adresa!.postanskiBroj!.isEmpty
                                  ? "Nije uneseno."
                                  : user!.adresa!.postanskiBroj.toString()),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                child: Column(
                  children: [
                    Text(
                      "Korisnikova lista igara:",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: gameList(user: user, showNavi: false),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
