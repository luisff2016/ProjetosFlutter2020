import 'package:flutter/material.dart';

import 'home_page.dart';
import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final TextEditingController _prontuarioController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 10.0),
          Column(
            children: <Widget>[
              Container(
                height: 75,
                width: 500,
                child: Image.asset(
                  'assets/images/logo.png',
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
          const SizedBox(height: 20.0),
          PrimaryColorOverride(
            color: Colors.blue,
            child: Container(
              child: TextField(
                controller: _prontuarioController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prontuario',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          PrimaryColorOverride(
            color: Colors.blue,
            child: Container(
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'E-mail',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          PrimaryColorOverride(
            color: Colors.blue,
            child: Container(
              child: TextField(
                controller: _senhaController,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Senha',
                ),
              ),
            ),
          ),
          Wrap(
            children: <Widget>[
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: RaisedButton(
                          padding: EdgeInsets.all(8),
                          child: const Text('CADASTRAR'),
                          elevation: 8.0,
                          shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: RaisedButton(
                          child: const Text('RECUPERAR'),
                          elevation: 8.0,
                          shape: const BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0)),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
