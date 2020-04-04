import 'package:app_minha_consulta/view/tela_login.dart';
import "package:flutter/material.dart";
import 'simuladorAGHUBD.dart';
import 'registro.dart';
import 'consulta.dart';
import 'dart:async';

/// ********************************************************************************************************************
/// Inserir dados no banco de dados para SimuladorAGHU do aplicativo
/// ********************************************************************************************************************
class SimuladorAGHU extends StatelessWidget {
  /// Constructor.
  SimuladorAGHU() {
    print("##200 SimuladorAGHU ok ");
  } /* End constructor. */

  Future<void> _inserirDadosExemplo() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      var dbSimuladorAGHU = new SimuladorAGHUBD();
      int contagem = await dbSimuladorAGHU.pegarContagem(dbSimuladorAGHU.tabelaRegistro);
      if (contagem <= 0) {
        _inserirRegistros(dbSimuladorAGHU);
        _listarRegistros(dbSimuladorAGHU);
        print("existem $contagem Registros cadastrados");
        _inserirConsultas(dbSimuladorAGHU);
        _listarConsultas(dbSimuladorAGHU);
      } else {
        print("Banco tem $contagem itens");
      }
    } catch (e) {
      print("Erro ao criar o banco SimuladorAGHUBD(): $e");
    }
  }

  _inserirRegistros(SimuladorAGHUBD dbSimuladorAGHU) async {
    int registroSalvo;
    // Registro (prontuario,cpf,nome);
    var registro3 = new Registro("000001", "10101010101", "Luis Fernando");
    registroSalvo = await dbSimuladorAGHU.inserirRegistro(registro3);
    print("Registro inserido: $registroSalvo");

    var registro2 = new Registro("000002", "20202020202", "Anderson Garcia");
    registroSalvo = await dbSimuladorAGHU.inserirRegistro(registro2);
    print("Registro inserido: $registroSalvo");

    Registro regSimuladorAGHU = (await dbSimuladorAGHU.pegarRegistro(1));
    print(regSimuladorAGHU.toString());
  }

  _listarRegistros(SimuladorAGHUBD dbSimuladorAGHU) async {
    List _todosRegistros;

    _todosRegistros =
        await dbSimuladorAGHU.pegarTodos(dbSimuladorAGHU.tabelaRegistro);

    for (int i = 0; i < _todosRegistros.length; i++) {
      Registro registro = Registro.map(_todosRegistros[i]);
      print(
          "Registro: prontuario ${registro.prontuario}, cpf ${registro.cpf}, nome ${registro.nome}");
    }
  }

  Future<void> _inserirConsultas(SimuladorAGHUBD dbSimuladorAGHU) async {
    int consultaSalva;

    int nRegistros = await dbSimuladorAGHU.pegarContagem(dbSimuladorAGHU.tabelaRegistro);
    // Registro (prontuario,cpf,nome);
    for (int i = 1; i < nRegistros; i++) {
      for (int j = 1; j < 10; j++) {
        var consulta =
            new Consulta(
              medico: "Dr. Hider", 
              especialidade: "geral", 
              dataConsulta: "01/01/2020", 
              horaConsulta: "15:00", 
              predio: "HU",
              sala :"sala " + j.toString(),
              tipoConsulta: "primeira vez",
              status: "agendada",
              fkConsulta: j,
              idConsulta: i
              );

        consultaSalva = await dbSimuladorAGHU.inserirConsulta(consulta);

        print("Consulta inserida: $consultaSalva");
      }
    }
  }

  _listarConsultas(SimuladorAGHUBD dbSimuladorAGHU) async {
    List _todasConsultas;

    _todasConsultas =
        await dbSimuladorAGHU.pegarTodos(dbSimuladorAGHU.tabelaConsulta);

    for (int i = 0; i < _todasConsultas.length; i++) {
      Consulta consulta = Consulta.map(_todasConsultas[i]);
      print(consulta.toString());
    }
  }

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## SimuladorAGHU SimuladorAGHU.build()");
    _inserirDadosExemplo();
    print("## SimuladorAGHU SimuladorAGHU: dados incluidos com sucesso");
    return TelaLogin();
  } /* End build(). */

} /* End class. */
