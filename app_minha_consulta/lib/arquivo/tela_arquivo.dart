import 'package:flutter/material.dart';
import '../arqAudio/tela_arq_audio.dart';
import '../arqDocumento/tela_arq_documento.dart';
import '../arqFoto/ArqFotos.dart';
import '../arqVideo/tela_arq_video.dart';

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
        context, MaterialPageRoute(builder: (context) => TelaArqDocumento()));
  }

// acessar Arquivo de Videos
  void _abrirVideo() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaArqVideo()));
  }

// acessar Arquivo de Audios
  void _abrirAudio() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TelaArqAudio()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arquivo"),
      ),
      body: Container(
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
              child: Text("Escolha o tipo de arquivo"),
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
                            'assets/images/icons-foto.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Foto"),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: _abrirDocumento,
                          child: Image.asset(
                            'assets/images/icons-documento.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Documento"),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: _abrirVideo,
                          child: Image.asset(
                            'assets/images/icons-video.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Video"),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          onTap: _abrirAudio,
                          child: Image.asset(
                            'assets/images/icons-audio.png',
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Audio"),
                      ),
                    ],
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
