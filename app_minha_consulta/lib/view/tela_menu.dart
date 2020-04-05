import 'package:flutter/material.dart';
import '../alergia/tela_alergia.dart';
import '../anotacao/tela_anotacao.dart';
import '../arquivo/tela_arquivo.dart';
import '../contato/tela_contato.dart';
import '../medicamento/tela_medicamento.dart';
import '../consulta/tela_consulta.dart';

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

  void _abrirMedicamento() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaMedicamento()));
  }

  void _abrirNota() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaAnotacao()));
  }

  void _abrirAlergia() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaAlergia()));
  }

  @override
  Widget build(BuildContext context) {
    print("## TelaMenu: ");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 75,
          width: 500,
          child: Image.asset(
            'assets/images/logo_hu1.jpg',
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
}
