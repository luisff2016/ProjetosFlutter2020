import 'package:app_minha_consulta/view/tela_login.dart';
import "package:flutter/material.dart";
import 'BD.dart';
import 'registro.dart';
import 'dart:async';

/// ********************************************************************************************************************
/// Inserir dados no banco de dados para teste do aplicativo
/// ********************************************************************************************************************
class Teste extends StatelessWidget {
  /// Constructor.
  Teste() {
    print("##200 Teste ok ");
  } /* End constructor. */

  Future<void> _inserirDadosExemplo() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      var dbTeste = new BD();
      int contagem = await dbTeste.pegarContagemRegistros();
      if (contagem <= 0) {
        List _todosRegistros;
        int registroSalvo;
        // Registro (prontuario,cpf,nome);
        var registro3 = new Registro("000001", "10101010101","Luis Fernando");
        registroSalvo = await dbTeste.inserirRegistro(registro3);
        print("Registro inserido: $registroSalvo");
        var registro2 = new Registro("000002", "20202020202", "Anderson Garcia");
        registroSalvo = await dbTeste.inserirRegistro(registro2);
        print("Registro inserido: $registroSalvo");

        print("existem $contagem Registros cadastrados");

        Registro regTeste = (await dbTeste.pegarRegistro(1));
        print(regTeste.toString());

        _todosRegistros = await dbTeste.pegarTodosRegistros();
        for (int i = 0; i < _todosRegistros.length; i++) {
          Registro registro = Registro.map(_todosRegistros[i]);
          print("Registro: prontuario ${registro.prontuario}, cpf ${registro.cpf}, nome ${registro.nome}");
        }
      } else {
        print("Banco tem $contagem itens");
      }
    } catch (e) {
      print("Erro ao criar o banco BD(): $e");
    }
  }

  /// The build() method.
  ///
  /// @param  inContext The BuildContext for this widget.
  /// @return           A Widget.
  Widget build(BuildContext inContext) {
    print("## teste Teste.build()");
    _inserirDadosExemplo();
    print("## teste Teste: dados incluidos com sucesso");
    return TelaLogin();
  } /* End build(). */

} /* End class. */

