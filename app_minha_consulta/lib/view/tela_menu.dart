//import 'dart:math';

import 'package:app_minha_consulta/alergia/AlergiasList.dart';
import 'package:app_minha_consulta/arquivo/ArquivosList.dart';
import 'package:app_minha_consulta/consulta/ConsultasList.dart';

import 'package:app_minha_consulta/contato/ContatosList.dart';
import 'package:app_minha_consulta/medicamento/MedicamentosList.dart';
import 'package:app_minha_consulta/nota/NotasList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "../nota/NotasModel.dart" show NotasModel, notasModel;

class TelaMenu extends StatefulWidget {
  @override
  _TelaMenuState createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {

  void _abrirConsulta() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConsultasList()));
  }

  void _abrirArquivo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArquivosList()));
  }

  void _abrirContato() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContatosList()));
  }

  void _abrirMedicamento() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MedicamentosList()));
  }

  void _abrirNota() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotasList()));
  }

  void _abrirAlergia() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AlergiasList()));
  }

  @override
  Widget build(BuildContext context) {
    print("## TelaMenu: ");
    return ScopedModel<NotasModel>(
      model : notasModel,
      child : ScopedModelDescendant<NotasModel>(
        builder : (BuildContext inContext, Widget inChild, NotasModel inModel) {
          return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 75,
          width: 500,
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        Expanded(
            child: Container(
          height: 600,
          width: 275,
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirConsulta,
                      child: Image.asset(
                        'assets/images/consultas.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Consultas"),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirArquivo,
                      child: Image.asset(
                        'assets/images/arquivos.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Arquivos"),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirContato,
                      child: Image.asset(
                        'assets/images/agenda.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Agenda"),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirMedicamento,
                      child: Image.asset(
                        'assets/images/horacerta.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Medicação"),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirNota,
                      child: Image.asset(
                        'assets/images/lembrete.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Lembrete"),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  Center(
                    child: GestureDetector(
                      onTap: _abrirAlergia,
                      child: Image.asset(
                        'assets/images/alergia.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text("Alergia"),
                  )
                ],
              ),
            ],
          ),
        )),
        // menu antigo
      ],
    );
        }
      )
    );
  }
}
