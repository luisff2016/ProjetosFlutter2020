import 'package:flutter/material.dart';

class TelaConsulta extends StatefulWidget {
  @override
  _TelaConsultaState createState() => _TelaConsultaState();
}

class _TelaConsultaState extends State<TelaConsulta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultas"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Image.asset("imagens/detalhe_empresa.png"),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Sobre a empresa",
                      style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......." +
                    "escrever texto aqui ......."),
              )
            ],
          ),
        ),
      ),
    );
  }
}
