import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nextgame_mobile/models/Korisnik.dart';
import 'package:nextgame_mobile/pages/Home.dart';
import 'package:nextgame_mobile/services/APIService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Korisnik? user;
  var result;
  Future<void> getData() async {
    result = await APIService.Get('Korisnik', null);
    if (result != null) {
      Korisnik tempUser =
          new Korisnik(Id: 0, Username: usernameController.text, Slika: []);
      var userRequest =
          await APIService.Get('Korisnik', tempUser.toJsonSearch());
      user = userRequest!.map((e) => Korisnik.fromJson(e)).single;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final logo = Image.asset(
      "assets/images/NextGameLogo.png",
      height: mq.size.height / 4,
    );

    final usernameField = TextFormField(
      controller: usernameController,
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

    final fields = Padding(
      padding: EdgeInsets.fromLTRB(10, 60, 10, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: usernameField),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 15), child: passwordField),
        ],
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25.0),
      color: Color.fromRGBO(33, 66, 68, 1),
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Text(
          "Prijavi se",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () async {
          APIService.password = passwordController.text;
          APIService.username = usernameController.text;
          await getData();
          if (result != null)
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          user: user,
                        )));
        },
      ),
    );

    final bottom = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        loginButton,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Nisi član?",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            MaterialButton(
              child: Text(
                "Registruj se",
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed("/registrationScreen");
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
              Padding(padding: EdgeInsets.only(top: 40), child: logo),
              fields,
              bottom
            ],
          ),
        ),
      ),
    );
  }
}
