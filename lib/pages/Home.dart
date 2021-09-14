import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/ListaIgrica.dart';
import 'package:nextgame_mobile/pages/IgraDetalji.dart';
import 'package:nextgame_mobile/pages/IgraSearch.dart';
import 'package:nextgame_mobile/pages/Objava.dart';
import 'package:nextgame_mobile/pages/RecenzijaPrikaz.dart';
import 'package:nextgame_mobile/pages/gameList.dart';
import 'package:nextgame_mobile/pages/userProfile.dart';
import 'package:nextgame_mobile/pages/userProfileShowcase.dart';
import 'package:nextgame_mobile/services/APIService.dart';
import 'dart:math';

class Home extends StatefulWidget {
  final Korisnik? user;
  const Home({Key? key, this.user}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? nazivPoPreporuci;
  @override
  Widget build(BuildContext context) {

    Future<List<Igra>> GetIgre() async {
      ListaIgrica filter = new ListaIgrica(Id: 0, korisnik: widget.user);
      var korisnikLista = await APIService.Get("ListaIgrica", filter.toJsonSearch());
      var lista = korisnikLista!.map((e) => ListaIgrica.fromJson(e)).toList();
      var korisnikovaLista = lista.where((element) => element.korisnik!.Id == widget.user!.Id).toList();
      final _random = new Random();
      var element = korisnikovaLista[_random.nextInt(korisnikovaLista.length)];
      nazivPoPreporuci = element.igrica!.naziv;
      var igra = await APIService.Get('Igrica/Recommend/${element.igrica!.igraId}', null);
      var listaIgra = igra!.map((i) => Igra.fromJson(i)).toList();
      return listaIgra;
    }

    Widget igreWidget(igra) {
      return Card(
        color: Color.fromRGBO(172, 252, 217, 1),
        margin: EdgeInsets.all(13),
        child: Container(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IgraDetalji(
                          igrica: igra,
                          user: widget.user,
                        )));
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 3.9,
                width: MediaQuery.of(context).size.width / 2.5,
                child: Image(image: MemoryImage(Uint8List.fromList(igra!.slika))),
              ),
            )),
      );
    }

    Widget bodyWidget() {
      return FutureBuilder<List<Igra>>(
        future: GetIgre(),
        builder: (BuildContext context, AsyncSnapshot<List<Igra>> snapshot) {
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
                    size: 50.0);
              }
              else{
                return Wrap(
                  direction: Axis.vertical,
                  children: snapshot.data!.map((e) => igreWidget(e)).toList(),
                );
              }
            }
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('NextGame')),
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 80,
                        backgroundImage: MemoryImage(
                            Uint8List.fromList(widget.user!.Slika))),
                    height: 50,
                    width: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    child: Text(
                      widget.user!.Username,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: Color.fromRGBO(12, 33, 40, 1)),
          ),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Objave',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Post(
                            korisnik: widget.user,
                          )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.desktop_windows_sharp,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Igrice',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IgraSearch(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Moja lista igrica',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => gameList(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.manage_search,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Pretraga korisnika',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/userSearch');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.beenhere_outlined,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Recenzije',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecenzijaPrikaz(
                        user: widget.user,
                      )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_box_sharp,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Pregled korisničkog profila',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => userProfileShowcase(
                            user: widget.user,
                          )));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.manage_accounts,
              color: Colors.white,
              size: 28,
            ),
            title: Text(
              'Ažuriraj korisnički profil',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => userProfile(
                            user: widget.user,
                          )));
            },
          ),
        ],
      )),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Text(
              nazivPoPreporuci == null ? "" : "Jer vam se svidio: " + nazivPoPreporuci!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20
              ),
            ),
          ),
          Expanded(child: bodyWidget()),
        ],
      ),
    );
  }
}
