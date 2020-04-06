import 'ArqVideosForm.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "../consulta/ConsultasModel.dart" show ConsultasModel, consultasModel;

class TelaArqVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("## TelaArqVideo: inicio");
    return ScopedModel<ConsultasModel>(
        model: consultasModel,
        child: ScopedModelDescendant<ConsultasModel>(builder:
            (BuildContext inContext, Widget inChild, ConsultasModel inModel) {
          return Scaffold(
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add, color: Colors.white),
                  onPressed: () async {
                    ArqVideosForm();
                  }),
              appBar: AppBar(
                title: Text("Galeria de Videos"),
                backgroundColor: Colors.blueAccent,
              ),
              body: Text("listar arquivos de video ..."),
              );
        }));
  }
}
