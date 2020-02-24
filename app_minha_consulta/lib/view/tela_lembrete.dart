import 'package:flutter/material.dart';

class TelaLembrete extends StatefulWidget {
  @override
  _TelaLembreteState createState() => _TelaLembreteState();
}

class _TelaLembreteState extends State<TelaLembrete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lembrete"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                height: 75,
                width: 500,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Sobre a empresa",
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
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
