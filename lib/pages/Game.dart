import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:nextgame_mobile/models/Igra.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/IgraDetalji.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class Game extends StatefulWidget {
  final Igra? filter;
  final Korisnik? user;
  Game({Key? key, this.filter, this.user}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Igre'),
      ),
      body: Column(
        children: [
          //Center(
          //child: dropDownWidget()
          //),
          Expanded(child: bodyWidget())
        ],
      ),
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

  Future<List<Igra>> GetIgre() async {
    var igra = await APIService.Get('Igrica', widget.filter?.toJsonSearch());
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
}
