import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/models/ListaIgrica.dart';
import 'package:nextgame_mobile/pages/gameListAdd.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class gameList extends StatefulWidget {
  final Korisnik? user;
  bool showNavi;
  gameList({Key? key, this.user, this.showNavi=true}) : super(key: key);

  @override
  _gameListState createState() => _gameListState();
}

class _gameListState extends State<gameList> {
  @override
  Widget build(BuildContext context) {
    Future<List<ListaIgrica>> GetListu() async {
      ListaIgrica _filter = new ListaIgrica(Id: 0, korisnik: widget.user);
      var igra = await APIService.Get('ListaIgrica', _filter.toJsonSearch());
      var listaIgra = igra!.map((i) => ListaIgrica.fromJson(i)).toList();
      return listaIgra.where((element) => element.korisnik!.Id == widget.user!.Id).toList();
    }

    DataRow redoviWidget(data) {
      return DataRow(cells: [
        DataCell(
          Text(data!.igrica!.naziv, style: TextStyle(color: Colors.white)),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => gameListAdd(
                        user: widget.user,
                        igrica: data!.igrica,
                      ispis: "Edituj listu igrica",
                    igralista: data,
                      ))).then((value) => setState(() {})),
        ),
        DataCell(
          Text(data!.ocjena.toString() + "/5", style: TextStyle(color: Colors.white)),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => gameListAdd(
                        user: widget.user,
                        igrica: data!.igrica,
                      ispis: "Edituj listu igrica",
                    igralista: data,
                      ))).then((value) => setState(() {})),
        ),
        DataCell(
          Text(data!.sati + "h", style: TextStyle(color: Colors.white)),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => gameListAdd(
                        user: widget.user,
                        igrica: data!.igrica,
                        ispis: "Edituj listu igrica",
                    igralista: data,
                      ))).then((value) => setState(() {}))
        )
      ]);
    };

    Widget bodyWidget() {
      return FutureBuilder<List<ListaIgrica>>(
          future: GetListu(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ListaIgrica>> snapshot) {
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
                return DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      "Igrica",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    )),
                    DataColumn(
                        label: Text(
                          "Ocjena",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        numeric: true),
                    DataColumn(
                        label: Text(
                          "Vrijeme igranja",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        numeric: true),
                  ],
                  rows: snapshot.data!.map((data) => redoviWidget(data)).toList(),
                );
              }
            }
          });
    }

    return Scaffold(
      appBar: widget.showNavi ? AppBar(
        title: Text('Lista igrica'),
      ) : null,
      body: SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: bodyWidget()),
    );
  }
}
