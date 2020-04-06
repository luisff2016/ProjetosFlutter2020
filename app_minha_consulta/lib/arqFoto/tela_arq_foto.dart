import 'ArqFotosForm.dart';
import 'ArqFotosList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "../consulta/ConsultasModel.dart" show ConsultasModel, consultasModel;

class TelaArqFoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## TelaArqFoto: inicio");
    return ScopedModel<ConsultasModel>(
        model: consultasModel,
        child: ScopedModelDescendant<ConsultasModel>(builder:
            (BuildContext inContext, Widget inChild, ConsultasModel inModel) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            ArqFotosForm();
          }),
              appBar: AppBar(
                title: Text("Fotos"),
                backgroundColor: Colors.blueAccent,
                              ),
              body: ArqFotosList(),
          );
        }));
  }
}

/**
 * 
 */

/**
 * SingleChildScrollView(
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
                    "Sobre a empresa",
                    style: TextStyle(fontSize: 40, color: Colors.deepOrange),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text("escrever texto aqui 123......." +
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
 */
