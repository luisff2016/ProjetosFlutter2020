import 'package:app_minha_consulta/arqAudio/ArqAudios.dart';
import 'package:app_minha_consulta/arqDocumento/ArqDocumentos.dart';
import 'package:app_minha_consulta/arqFoto/ArqFotos.dart';
import 'package:app_minha_consulta/arqVideo/ArqVideos.dart';
import 'package:flutter/material.dart';

class TelaArquivo extends StatefulWidget {
  @override
  _TelaArquivoState createState() => _TelaArquivoState();
}

class _TelaArquivoState extends State<TelaArquivo> {
  // acessar Arquivo de Fotos
  void _abrirFoto() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArqFotos()));
  }
// acessar Arquivo de Documentos
  void _abrirDocumento() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArqDocumentos()));
  }
// acessar Arquivo de Videos
  void _abrirVideo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArqVideos()));
  }
// acessar Arquivo de Audios
  void _abrirAudio() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArqAudios()));
  }


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
                  'assets/images/logo_hu1.jpg',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("Em construção... ......." ),
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
                      onTap: _abrirFoto,
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
                      onTap: _abrirDocumento,
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
                      onTap: _abrirVideo,
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
                      onTap: _abrirAudio,
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
              
            ],
          ),
        )),
        

            ],
          ),
        ),
      ),
    );
  }
}
