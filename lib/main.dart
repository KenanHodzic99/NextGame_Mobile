import 'package:flutter/material.dart';
import 'package:nextgame_mobile/pages/IgraSearch.dart';
import 'package:nextgame_mobile/pages/Objava.dart';
import 'package:nextgame_mobile/pages/userProfile.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nextgame_mobile/pages/userSearch.dart';
import 'pages/Home.dart';
import 'pages/Loading.dart';
import 'pages/Login.dart';
import 'pages/Game.dart';
import 'pages/IgraDetalji.dart';
import 'pages/openingScreen.dart';
import 'pages/registrationScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  initializeDateFormatting('eu', null).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromRGBO(12, 33, 40, 1),
        canvasColor: Color.fromRGBO(65, 130, 133, 1),
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: Color.fromRGBO(33, 66, 68, 1)),
      ),
      home:openingScreen(),
      routes: {
        '/loading':(context)=>Loading(),
        '/home':(context)=>Home(),
        '/igra':(context)=>Game(),
        '/registrationScreen':(context)=>registrationScreen(),
        '/login':(context) => Login(),
        '/userProfile':(context) => userProfile(),
        '/objava':(context) => Post(),
        '/userSearch':(context) => userSearch(),
        '/igraSearch':(context) => IgraSearch(),
        '/igraDetalji':(context) => IgraDetalji()
      },
    );
  }
}





