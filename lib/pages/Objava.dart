import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/Objava.dart';
import 'package:nextgame_mobile/pages/ObjavaDetalji.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class Post extends StatefulWidget {
  final Korisnik? korisnik;
  const Post({Key? key, this.korisnik}) : super(key: key);

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Objave'),
      ),
      body: Column(
        children: [Expanded(child: bodyWidget())],
      ),
    );
  }

  Widget bodyWidget() {
    return FutureBuilder<List<Objava>>(
      future: GetObjave(),
      builder: (BuildContext context, AsyncSnapshot<List<Objava>> snapshot) {
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
              children: snapshot.data!.map((e) => objavaWidget(e)).toList(),
            );
          }
        }
      },
    );
  }

  Future<List<Objava>> GetObjave() async {
    var objava = await APIService.Get('Objava', null);
    var listaObjava = objava!.map((i) => Objava.fromJson(i)).toList();
    return listaObjava;
  }

  Widget objavaWidget(objava) {
    return Card(
      color: Color.fromRGBO(172, 252, 217, 1),
      margin: EdgeInsets.all(12),
      child: Container(
          child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ObjavaDetalji(
                        objava: objava,
                        korisnik: widget.korisnik,
                      )));
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 9,
          width: MediaQuery.of(context).size.width,
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
                          Uint8List.fromList(objava!.igrica!.slika))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(objava!.naslov.toString(),
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
}
