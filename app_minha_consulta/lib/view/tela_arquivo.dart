import 'package:flutter/material.dart';

class TelaArquivo extends StatefulWidget {
  @override
  _TelaArquivoState createState() => _TelaArquivoState();
}

class _TelaArquivoState extends State<TelaArquivo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arquivo"),
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
                  'assets/logo/logo_hu1.png',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Clientes",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Cliente premium"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Cliente prata"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
