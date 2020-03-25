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
    print("## simuladorAGHU SimuladorAGHU: ok ");
  } /* End constructor. */

  Future<void> _inserirDadosExemplo() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      var bancoTeste = new SimuladorAGHUBD();
      int contagem =
          await bancoTeste.pegarContagem(bancoTeste.tabelaRegistro);
      if (contagem <= 1) {
        _inserirRegistros(bancoTeste);
        _listarRegistros(bancoTeste);
        _inserirConsultas(bancoTeste);
        _listarConsultas(bancoTeste);
        
      } else {
        print(
            "## simuladorAGHU SimuladorAGHU._inserirDadosExemplo: Banco tem $contagem itens");
      }
    } catch (e) {
      print("## simuladorAGHU SimuladorAGHU._inserirDadosExemplo: Erro ao criar o banco de teste=> $e");
    }
  }

  _inserirRegistros(SimuladorAGHUBD bancoTeste) async {
    int registroSalvo;
    // Registro (prontuario,cpf,nome);
    var registro3 = new Registro("000001", "10101010101", "Luis Fernando");
    registroSalvo = await bancoTeste.inserirRegistro(registro3);
    print("Registro inserido: $registroSalvo");

    var registro2 = new Registro("000002", "20202020202", "Anderson Garcia");
    registroSalvo = await bancoTeste.inserirRegistro(registro2);
    print("Registro inserido: $registroSalvo");

  var contagem =
            await bancoTeste.pegarContagem(bancoTeste.tabelaRegistro);
        print(
            "## simuladorAGHU SimuladorAGHU._inserirDadosExemplo: existem $contagem Registros cadastrados");
      
  }

  _listarRegistros(SimuladorAGHUBD bancoTeste) async {
    List _todosRegistros;

    _todosRegistros = await bancoTeste.pegarTodos(bancoTeste.tabelaRegistro);

    for (int i = 0; i < _todosRegistros.length; i++) {
      Registro registro = Registro.map(_todosRegistros[i]);
      print(
          "Registro: prontuario ${registro.prontuario}, cpf ${registro.cpf}, nome ${registro.nome}");
    }
  }

  _inserirConsultas(SimuladorAGHUBD bancoTeste) async {
   
    int consultaSalva;

    var nRegistros = await bancoTeste.pegarContagem(bancoTeste.tabelaRegistro);
    // Registro (prontuario,cpf,nome);
    for (int i = 1; i < nRegistros; i++) {
      for (int j = 1; j < 10; j++) {
        var consulta =
            new Consulta("Dr. Hyder", "geral", "Consultorio" + j.toString(), i);

        consultaSalva = await bancoTeste.inserirConsulta(consulta);

        print("Consulta inserida: $consultaSalva");
      }
    }
    var contagem =
            await bancoTeste.pegarContagem(bancoTeste.tabelaConsulta);
        print(
            "## simuladorAGHU SimuladorAGHU._inserirDadosExemplo: existem $contagem Consultas cadastradas");
  }

  _listarConsultas(SimuladorAGHUBD bancoTeste) async {
    List _todasConsultas;

    _todasConsultas = await bancoTeste.pegarTodos(bancoTeste.tabelaConsulta);

    for (int i = 0; i < _todasConsultas.length; i++) {
      Consulta consulta = Consulta.map(_todasConsultas[i]);
      print("Consulta: medico=${consulta.medico},"
          " especialidade=${consulta.especialidade},"
          " consultorio=${consulta.consultorio}");
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
