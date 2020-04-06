import 'package:flutter/material.dart';


class TelaMedicamento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicação"),
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
                  "Listar medicamentos ...",
                  style: TextStyle(fontSize: 20, color: Colors.deepOrange),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Em construção... ......." ),
              )
            ],
          ),
        ),
      ),
    );
  }
}