import 'package:flutter/material.dart';

import 'package:app_minha_consulta/tela_consulta.dart';
import 'package:app_minha_consulta/tela_arquivo.dart';
import 'package:app_minha_consulta/tela_contato.dart';
import 'package:app_minha_consulta/tela_horario.dart';
import 'package:app_minha_consulta/tela_lembrete.dart';
import 'package:app_minha_consulta/tela_alergia.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  void _abrirConsulta(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaConsulta() ));
  }
  void _abrirArquivo(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaArquivo() ));
  }
  void _abrirContato(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaContato() ));
  }
  void _abrirHorario(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaHorario() ));
  }
  void _abrirLembrete(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaLembrete() ));
  }
  void _abrirAlergia(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> TelaAlergia() ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Minha Consulta - Home"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("imagens/logo_ufs_hu.png"),
            Row(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(32),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Consulta"),
                      GestureDetector(
                        onTap: _abrirConsulta,
                        child: Image.asset("imagens/medico.bmp"),
                        
                      ),
                      Text("Arquivo"),
                      GestureDetector(
                        onTap: _abrirArquivo,
                        child: Image.asset("imagens/medico.bmp"),
                      ),
                      Text("Contato"),
                      GestureDetector(
                        onTap: _abrirContato,
                        child: Image.asset("imagens/medico.bmp"),
                      ),
                    ],
                  ),
                ),
                Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: <Widget>[
                  Text("Horario"),
                  GestureDetector(
                    onTap: _abrirHorario,
                    child: Image.asset("imagens/medico.bmp"),
                  ),
                  Text("Lembrete"),
                  GestureDetector(
                    onTap: _abrirLembrete,
                    child: Image.asset("imagens/medico.bmp"),
                  ),
                  Text("Alergia"),
                  GestureDetector(
                    onTap: _abrirAlergia,
                    child: Image.asset("imagens/medico.bmp"),
                  ),
                ],
              ),
            ),
              ],
            ),
            
            
          ],
        ),
          ],
        )

      ),
    );
  }
}