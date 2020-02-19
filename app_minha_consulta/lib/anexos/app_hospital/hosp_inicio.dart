import 'package:flutter/material.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 100,
          width: 500,
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        Expanded(
          child: Container(
            height: 600,
            width: 300,
            child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: [
                  Column(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/consultas.png',
                            width: 125,
                            height: 125,
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
                          child: Image.asset(
                            'assets/images/arquivos.png',
                            width: 125,
                            height: 125,
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
                          child: Image.asset(
                            'assets/images/agenda.png',
                            width: 125,
                            height: 125,
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
                          child: Image.asset(
                            'assets/images/horacerta.png',
                            width: 125,
                            height: 125,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Hora Certa"),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/lembrete.png',
                            width: 125,
                            height: 125,
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
                          child: Image.asset(
                            'assets/images/alergia.png',
                            width: 125,
                            height: 125,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Alergia"),
                      )
                    ],
                  ),
                ]),
          ),
        )
      ],
    );
  }
}
