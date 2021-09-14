import 'dart:convert';
import 'dart:io' as Io;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nextgame_mobile/models/Adresa.dart';
import 'package:nextgame_mobile/models/Kontakt.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/Home.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class userProfile extends StatefulWidget {
  final Korisnik? user;
  userProfile({Key? key, this.user}) : super(key: key);

  @override
  _userProfileState createState() => _userProfileState();
}

class _userProfileState extends State<userProfile> {
  TextEditingController opisController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  TextEditingController datumController = new TextEditingController();
  TextEditingController gradController = new TextEditingController();
  TextEditingController postanskiBrojController = new TextEditingController();
  TextEditingController drzavaController = new TextEditingController();
  TextEditingController imeController = new TextEditingController();
  TextEditingController prezimeController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController brojTelefonaController = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  final _formKey = GlobalKey<FormState>();
  var result;
  late Korisnik user;
  DateFormat dateFormat = new DateFormat("dd/MM/yyyy");
  String? continentDropDown;
  Future<void> updateData() async {
    var pickedImage;
    if (image != null) {
      final bytes = await Io.File(image!.path).readAsBytes();
      pickedImage = base64Encode(bytes);
    }
    Korisnik noviUser = new Korisnik(
      Id: widget.user!.Id,
      Opis: widget.user?.Opis == null
          ? opisController.text.isEmpty
              ? ""
              : opisController.text
          : opisController.text.isEmpty
              ? widget.user!.Opis
              : opisController.text,
      Username: widget.user!.Username,
      Slika: image == null ? widget.user!.Slika : base64Decode(pickedImage),
      datumRodenja: widget.user?.datumRodenja == null
          ? datumController.text.isEmpty
              ? null
              : datumController.text
          : datumController.text.isEmpty
              ? widget.user!.datumRodenja
              : datumController.text,
      kontakt: new Kontakt(
        Id: widget.user?.kontakt == null ? 0 : widget.user!.kontakt!.Id,
        ime: widget.user?.kontakt?.ime == null
            ? imeController.text.isEmpty
                ? ""
                : imeController.text
            : imeController.text.isEmpty
                ? widget.user!.kontakt!.ime
                : imeController.text,
        prezime: widget.user?.kontakt?.prezime == null
            ? prezimeController.text.isEmpty
                ? ""
                : prezimeController.text
            : prezimeController.text.isEmpty
                ? widget.user!.kontakt!.prezime
                : prezimeController.text,
        brojTelefona: widget.user?.kontakt?.brojTelefona == null
            ? brojTelefonaController.text.isEmpty
                ? ""
                : brojTelefonaController.text
            : brojTelefonaController.text.isEmpty
                ? widget.user!.kontakt!.brojTelefona
                : brojTelefonaController.text,
        email: widget.user?.kontakt?.email == null
            ? emailController.text.isEmpty
                ? ""
                : emailController.text
            : emailController.text.isEmpty
                ? widget.user!.kontakt!.email
                : emailController.text,
      ),
      adresa: new Adresa(
        Id: widget.user?.adresa == null ? 0 : widget.user!.adresa!.Id,
        kontinent: widget.user?.adresa?.kontinent == null
            ? continentDropDown == null || continentDropDown!.isEmpty
                ? ""
                : continentDropDown
            : continentDropDown == null || continentDropDown!.isEmpty
                ? widget.user!.adresa!.kontinent
                : continentDropDown,
        drzava: widget.user?.adresa?.drzava == null
            ? drzavaController.text.isEmpty
                ? ""
                : drzavaController.text
            : drzavaController.text.isEmpty
                ? widget.user!.adresa!.drzava
                : drzavaController.text,
        postanskiBroj: widget.user?.adresa?.postanskiBroj == null
            ? postanskiBrojController.text.isEmpty
                ? ""
                : postanskiBrojController.text
            : postanskiBrojController.text.isEmpty
                ? widget.user!.adresa!.postanskiBroj
                : postanskiBrojController.text,
        grad: widget.user?.adresa?.grad == null
            ? gradController.text.isEmpty
                ? ""
                : gradController.text
            : gradController.text.isEmpty
                ? widget.user!.adresa!.grad
                : gradController.text,
      ),
    );
    result = await APIService.Update(
        'Korisnik', jsonEncode(noviUser.toJsonUpdate()), widget.user!.Id);
    if (result != null) {
      Korisnik tempUser =
          new Korisnik(Id: 0, Username: widget.user!.Username, Slika: []);
      var userRequest =
          await APIService.Get('Korisnik', tempUser.toJsonSearch());
      user = userRequest!.map((e) => Korisnik.fromJson(e)).single;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget prikaziSliku() {
      if (image == null) {
        return CircleAvatar(
            backgroundColor: Theme.of(context).canvasColor,
            radius: 80,
            backgroundImage:
                MemoryImage(Uint8List.fromList(widget.user!.Slika)));
      } else {
        return CircleAvatar(
            backgroundColor: Theme.of(context).canvasColor,
            radius: 80,
            backgroundImage: FileImage(Io.File(image!.path)));
      }
    }

    final userPicture = Container(
      height: MediaQuery.of(context).size.height / 5,
      child: TextButton(
          onPressed: () async {
            var slika = await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              image = slika;
            });
          },
          child: prikaziSliku()),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value != password2Controller.text) {
          return "Passwordi nisu isti!";
        }
      },
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "password",
          labelText: "Novi password:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final password2Field = TextFormField(
      controller: password2Controller,
      validator: (value) {
        if (value != passwordController.text) {
          return "Passwordi nisu isti!";
        }
      },
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "password",
          labelText: "Ponovo unesite novi password:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final datumField = TextFormField(
      controller: datumController,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        try {
          if (datumController.text.isNotEmpty) {
            var date = DateFormat.yMd().parse(datumController.text);
          }
        } on Exception catch (_) {
          return "Unesite datum u validnom formatu!";
        }
      },
      //keyboardType: TextInputType.text,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.user?.datumRodenja == null
            ? "(dd/MM/yyyy)"
            : widget.user!.datumRodenja,
        labelText: "Datum rođenja:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final opisField = TextFormField(
      controller: opisController,
      maxLines: 8,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText:
            widget.user?.Opis == null ? "Vaš opis ovdje..." : widget.user!.Opis,
        labelText: "Opis:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final userAccountFields = Padding(
      padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: passwordField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: password2Field),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: datumField),
          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: opisField),
        ],
      ),
    );

    final kontinentField = DropdownButton<String>(
      value: widget.user?.adresa?.kontinent == null
          ? continentDropDown
          : widget.user!.adresa!.kontinent!.isEmpty
              ? continentDropDown
              : widget.user!.adresa!.kontinent,
      isExpanded: true,
      hint: Text(
        "Kontinent",
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.white,
      ),
      iconSize: 24,
      dropdownColor: Color.fromRGBO(33, 66, 68, 1),
      style: const TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        width: 100,
        color: Colors.white,
      ),
      onChanged: (String? newValue) {
        setState(() {
          continentDropDown = newValue!;
        });
      },
      items: <String>[
        'Azija',
        'Afrika',
        'Sjeverna Amerika',
        'Australija',
        'Antarktika',
        'Europa',
        'Južna Amerika'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );

    final drzavaField = TextFormField(
      controller: drzavaController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: widget.user?.adresa?.drzava == null
              ? "Država"
              : widget.user!.adresa!.drzava,
          labelText: "Država:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final gradField = TextFormField(
      controller: gradController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.user?.adresa?.grad == null
            ? "Grad"
            : widget.user!.adresa!.grad,
        labelText: "Grad:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final postanskiBrojField = TextFormField(
      controller: postanskiBrojController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.user?.adresa?.postanskiBroj == null
            ? "Poštanski broj."
            : widget.user!.adresa!.postanskiBroj,
        labelText: "Poštanski broj:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final userAdressFields = Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: kontinentField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: drzavaField),
          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: gradField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: postanskiBrojField),
        ],
      ),
    );

    final imeField = TextFormField(
      controller: imeController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: widget.user?.kontakt?.ime == null
              ? "Ime"
              : widget.user!.kontakt!.ime,
          labelText: "Ime:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final prezimeField = TextFormField(
      controller: prezimeController,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: widget.user?.kontakt?.prezime == null
              ? "Prezime"
              : widget.user!.kontakt!.prezime,
          labelText: "Prezime:",
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final emailField = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.user?.kontakt?.email == null
            ? "E-mail"
            : widget.user!.kontakt!.email,
        labelText: "E-mail:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final brojTelefonaField = TextFormField(
      controller: brojTelefonaController,
      keyboardType: TextInputType.phone,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: widget.user?.kontakt?.brojTelefona == null
            ? "Broj telefona."
            : widget.user!.kontakt!.brojTelefona,
        labelText: "Broj telefona:",
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        hintStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final userContactFields = Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: imeField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: prezimeField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: emailField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: brojTelefonaField),
        ],
      ),
    );

    final submitButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color.fromRGBO(33, 66, 68, 1),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Text(
          "Sačuvaj promjene",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await updateData();
            if (result != null) {
              final snackBar = SnackBar(
                  content: const Text("Uspjesno ste se ažurirali podatke!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            user: user,
                          )));
            }
          }
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Ažuriranje profila'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    children: [
                      userPicture,
                      Text(
                        "Promijeni sliku",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  )),
              userAccountFields,
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Kontakt informacije:",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              userContactFields,
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Adresa:",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
              userAdressFields,
              submitButton
            ],
          ),
        ),
      ),
    );
  }
}
