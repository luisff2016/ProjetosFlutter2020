import 'package:flutter/material.dart';

import 'AnotacoesForm.dart';

class TelaAnotacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            AnotacoesForm();
          }),
      appBar: AppBar(
        title: Text("Anotacao"),
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
                  'assets/images/logo_hu1.jpg',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Listar as anotacoes ...",
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Em construção... ......."),
              )
            ],
          ),
        ),
      ),
    );
  }
}
