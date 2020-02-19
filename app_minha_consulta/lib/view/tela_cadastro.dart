import 'package:flutter/material.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<TelaCadastro> {
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
