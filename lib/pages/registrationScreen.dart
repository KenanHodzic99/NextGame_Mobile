import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nextgame_mobile/services/APIService.dart';
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:flutter/services.dart' show rootBundle;

class registrationScreen extends StatefulWidget {
  const registrationScreen({Key? key}) : super(key: key);

  @override
  _registrationScreenState createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  var result;

  Future<void> getData(Korisnik _korisnik) async {
    result =
        await APIService.Post('Korisnik', jsonEncode(_korisnik.toJson()), true);
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File imageFile = new File.fromUri(myUri);
    late Uint8List bytes;
    await imageFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logo = Image.asset(
      "assets/images/DefaultProfilePicture.png",
      height: mq.size.height / 4,
    );

    final usernameField = TextFormField(
      controller: usernameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite username!";
        }
      },
      //keyboardType: TextInputType.text,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: "Korisničko ime",
        labelText: "Korisničko ime:",
        labelStyle: TextStyle(
          color: Color.fromRGBO(65, 130, 133, 1),
        ),
        hintStyle: TextStyle(
          color: Color.fromRGBO(65, 130, 133, 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromRGBO(65, 130, 133, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );

    final passwordField = TextFormField(
      controller: passwordController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Unesite password!";
        }
      },
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "password",
          labelText: "Password:",
          labelStyle: TextStyle(
            color: Color.fromRGBO(65, 130, 133, 1),
          ),
          hintStyle: TextStyle(
            color: Color.fromRGBO(65, 130, 133, 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(65, 130, 133, 1),
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
        if (value == null || value.isEmpty) {
          return "Unesite password ponovo!";
        } else {
          if (value != passwordController.text) {
            return "Passwordi nisu isti!";
          }
        }
      },
      obscureText: true,
      style: TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
          hintText: "password",
          labelText: "Ponovo unesite password:",
          labelStyle: TextStyle(
            color: Color.fromRGBO(65, 130, 133, 1),
          ),
          hintStyle: TextStyle(
            color: Color.fromRGBO(65, 130, 133, 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromRGBO(65, 130, 133, 1),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          )),
    );

    final fields = Padding(
      padding: EdgeInsets.fromLTRB(10, 60, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: usernameField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: passwordField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: password2Field),
        ],
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color.fromRGBO(33, 66, 68, 1),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Text(
          "Registruj se",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ByteData bytes = await rootBundle
                .load('assets/images/DefaultProfilePicture.png');
            var buffer = bytes.buffer;
            var slika = base64.encode(Uint8List.view(buffer));
            Korisnik noviKorisnik = new Korisnik(
                Id: 0,
                Username: usernameController.text,
                Password: passwordController.text,
                Slika: base64Decode(slika));
            await getData(noviKorisnik);
            if (result != null) {
              final snackBar = SnackBar(
                  content: const Text("Uspjesno ste se registrovali!"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.of(context).pushReplacementNamed('/login');
            }
          }
        },
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        registerButton,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Već registrovan?",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            MaterialButton(
              child: Text(
                "Prijavi se",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
          ],
        )
      ],
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 33, 40, 1),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: logo),
              fields,
              bottom
            ],
          ),
        ),
      ),
    );
  }
}
