import 'package:app_minha_consulta/view/tela_menu.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

 @override
  Widget build(BuildContext context) {
    print("## HomePage: Menu da aplicacao");
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Minha Consulta - HOME"),
          backgroundColor: Colors.blueAccent,
        ),
        body: TelaMenu(),
    );
  }
  
}

/**
 * var connection = new PostgreSQLConnection(
    "localhost", 5432, "SistemaAGHU", 
    username: "dart", password: "dart"
    );
    //await connection.open();
 */