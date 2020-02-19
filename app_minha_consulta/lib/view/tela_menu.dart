//import 'dart:math';

import 'package:app_minha_consulta/view/tela_alergia.dart';
import 'package:app_minha_consulta/view/tela_arquivo.dart';
import 'package:app_minha_consulta/view/tela_consulta.dart';
import 'package:app_minha_consulta/view/tela_contato.dart';
import 'package:app_minha_consulta/view/tela_horario.dart';
import 'package:app_minha_consulta/view/tela_lembrete.dart';
import 'package:flutter/material.dart';

class TelaMenu extends StatefulWidget {
  @override
  _TelaMenuState createState() => _TelaMenuState();
}

class _TelaMenuState extends State<TelaMenu> {
  void _abrirConsulta() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaConsulta()));
  }

  void _abrirArquivo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaArquivo()));
  }

  void _abrirContato() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaContato()));
  }

  void _abrirHorario() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaHorario()));
  }

  void _abrirLembrete() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaLembrete()));
  }

  void _abrirAlergia() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaAlergia()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
                      onTap: _abrirHorario,
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
                      onTap: _abrirLembrete,
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
}
