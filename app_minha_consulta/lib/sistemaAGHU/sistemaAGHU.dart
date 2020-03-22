import 'package:app_minha_consulta/view/tela_login.dart';
import "package:flutter/material.dart";
import 'sistemaAGHUBD.dart';
import 'registro.dart';
import 'consulta.dart';
import 'dart:async';

/// ********************************************************************************************************************
/// Inserir dados no banco de dados para SistemaAGHU do aplicativo
/// ********************************************************************************************************************
class SistemaAGHU extends StatelessWidget {
  /// Constructor.
  SistemaAGHU() {
    print("##200 SistemaAGHU ok ");
  } /* End constructor. */

  Future<void> _inserirDadosExemplo() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      var dbSistemaAGHU = new SistemaAGHUBD();
      int contagem = await dbSistemaAGHU.pegarContagem(dbSistemaAGHU.tabelaRegistro);
      if (contagem <= 0) {
        _inserirRegistros(dbSistemaAGHU);
        _listarRegistros(dbSistemaAGHU);
        print("existem $contagem Registros cadastrados");
        _inserirConsultas(dbSistemaAGHU);
        _listarConsultas(dbSistemaAGHU);
      } else {
        print("Banco tem $contagem itens");
      }
    } catch (e) {
      print("Erro ao criar o banco SistemaAGHUBD(): $e");
    }
  }

  _inserirRegistros(SistemaAGHUBD dbSistemaAGHU) async {
    int registroSalvo;
    // Registro (prontuario,cpf,nome);
    var registro3 = new Registro("000001", "10101010101", "Luis Fernando");
    registroSalvo = await dbSistemaAGHU.inserirRegistro(registro3);
    print("Registro inserido: $registroSalvo");

    var registro2 = new Registro("000002", "20202020202", "Anderson Garcia");
    registroSalvo = await dbSistemaAGHU.inserirRegistro(registro2);
    print("Registro inserido: $registroSalvo");

    Registro regSistemaAGHU = (await dbSistemaAGHU.pegarRegistro(1));
    print(regSistemaAGHU.toString());
  }

  _listarRegistros(SistemaAGHUBD dbSistemaAGHU) async {
    List _todosRegistros;

    _todosRegistros =
        await dbSistemaAGHU.pegarTodos(dbSistemaAGHU.tabelaRegistro);

    for (int i = 0; i < _todosRegistros.length; i++) {
      Registro registro = Registro.map(_todosRegistros[i]);
      print(
          "Registro: prontuario ${registro.prontuario}, cpf ${registro.cpf}, nome ${registro.nome}");
    }
  }

  Future<void> _inserirConsultas(SistemaAGHUBD dbSistemaAGHU) async {
    int consultaSalva;

    int nRegistros = await dbSistemaAGHU.pegarContagem(dbSistemaAGHU.tabelaRegistro);
    // Registro (prontuario,cpf,nome);
    for (int i = 1; i < nRegistros; i++) {
      for (int j = 1; j < 10; j++) {
        var consulta =
            new Consulta("Dr. Hider", "geral", "Consultorio" + j.toString(), i);

        consultaSalva = await dbSistemaAGHU.inserirConsulta(consulta);

        print("Consulta inserida: $consultaSalva");
      }
    }
  }

  _listarConsultas(SistemaAGHUBD dbSistemaAGHU) async {
    List _todasConsultas;

    _todasConsultas =
        await dbSistemaAGHU.pegarTodos(dbSistemaAGHU.tabelaConsulta);

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
    print("## SistemaAGHU SistemaAGHU.build()");
    _inserirDadosExemplo();
    print("## SistemaAGHU SistemaAGHU: dados incluidos com sucesso");
    return TelaLogin();
  } /* End build(). */

} /* End class. */
