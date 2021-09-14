import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/userProfileShowcase.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class userSearch extends StatefulWidget {
  const userSearch({Key? key}) : super(key: key);

  @override
  _userSearchState createState() => _userSearchState();
}

class _userSearchState extends State<userSearch> {
  FloatingSearchBarController searchController = new FloatingSearchBarController();
  var _filter;
  @override
  Widget build(BuildContext context) {
    Widget buildFloatingSearchBar() {
      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      return FloatingSearchBar(
        hint: 'Pretraži...',
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
        transitionDuration: const Duration(milliseconds: 500),
        transitionCurve: Curves.easeInOut,
        physics: const BouncingScrollPhysics(),
        axisAlignment: isPortrait ? 0.0 : -1.0,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        debounceDelay: const Duration(milliseconds: 500),
        controller: searchController,
        onQueryChanged: (query) {
            _filter = query;
            setState(() {

            });
        },
        transition: SlideFadeFloatingSearchBarTransition(),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {

                });
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4.0,
              ),
            );
        },
      );
    }

    Future<List<Korisnik>> GetUsers() async {
      Korisnik tempKorisnik = new Korisnik(Id: 0, Username: _filter == null ? "" : _filter, Slika: []);
      var user = await APIService.Get('Korisnik', tempKorisnik.toJsonSearch());
      var listaUsera = user!.map((i) => Korisnik.fromJson(i)).toList();
      return listaUsera;
    }


    Widget korisnikWidget(korisnik) {
      return Card(
        color: Color.fromRGBO(172, 252, 217, 1),
        margin: EdgeInsets.all(12),
        child: Container(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            userProfileShowcase(
                              user: korisnik,
                            )));
              },
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 9,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Container(
                        width: 70,
                        height: 70,
                        child: Image(
                            image: MemoryImage(
                                Uint8List.fromList(korisnik!.Slika))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(korisnik!.Username,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            )),
      );
    }

    Widget bodyWidget() {
      return FutureBuilder<List<Korisnik>>(
        future: GetUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<Korisnik>> snapshot) {
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
              return ListView(
                children: snapshot.data!.map((e) => korisnikWidget(e)).toList(),
              );
            }
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pretraga korisnika'),
      ),
      body: Stack(
      fit: StackFit.expand,
    children: [
          buildFloatingSearchBar(),
          Container(
            margin: EdgeInsets.only(top: 70),
              child: bodyWidget())
    ],
      )
    );
  }
}
