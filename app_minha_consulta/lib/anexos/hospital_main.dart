import 'package:flutter/material.dart';

void main() {
  runApp(TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: "INÍCIO",
                ),
                Tab(
                    icon: Icon(Icons.message),
                    text: "MENSAGENS",
                ),
                Tab(
                    icon: Icon(Icons.account_circle),
                    text: "CONTA",
                ),
              ],
            ),
            title: Text('Hospital Universitário'),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              Inicio(),
              Icon(Icons.directions_transit),
              Conta(),
            ],
          ),
        ),
      ),
    );
  }
}

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
          height:150,
          width: 350,
          child: Image.asset(
            'assets/images/logo.png',
          ),
        ),
        Expanded(
          child: Container(
            height: 600,
            width: 350,
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
                            width: 150,
                            height: 150,
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
                            width: 150,
                            height: 150,
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
                            width: 150,
                            height: 150,
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
                            width: 150,
                            height: 150,
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
                            width: 150,
                            height: 150,
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
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text("Alergia"),
                      )
                    ],
                  ),
                ]
            ),
          ),

        )
      ],
    );
  }
}
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Conta extends StatefulWidget {
  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height:150,
            width: 350,
            child: Image.asset(
              'assets/images/logo.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20,20,20,20),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail'
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20,5,20,20),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha'
              ),
            ),
          ),
          RaisedButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text("ENTRAR"),
            onPressed: (){},
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Center(
              child: Text(
                  "Recuperar minha senha",
              style: TextStyle(
                color: Colors.blueAccent
              ),),
            )
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
              child: Center(
                child: Text(
                    "Cadastre-se",
                  style: TextStyle(
                    color: Colors.blueAccent
                  ),),
              )
          )
        ],
      ),
    );
  }
}
