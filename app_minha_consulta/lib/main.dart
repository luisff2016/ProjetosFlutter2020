//import 'package:app_minha_consulta/anexos/app_hospital/hospital_main.dart';
import 'package:flutter/material.dart';

import 'view/tela_login.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,

    theme: ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
    ),
    //home: HomePage(),
    home: TelaLogin(),
    //home: TabBarDemo(),
  ));
}
