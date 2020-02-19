import 'package:app_minha_consulta/anexos/app_hospital/hosp_conta.dart';
import 'package:app_minha_consulta/anexos/app_hospital/hosp_inicio.dart';
import 'package:flutter/material.dart';

class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
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
            title: Text('Minha Consulta 2.0 HU'),
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
