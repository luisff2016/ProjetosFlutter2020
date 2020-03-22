import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'registro.dart';
import 'consulta.dart';

class SistemaAGHUBD {
  SistemaAGHUBD._internal();
  static final SistemaAGHUBD _instance = new SistemaAGHUBD._internal();

  factory SistemaAGHUBD() => _instance;
  // Tabela de registro simulando os dados do Sistema AGHU
  final String tabelaRegistro = "tabelaRegistro";
  final String colunaIdRegistro = "idRegistro";
  final String colunaProntuario = "prontuario";
  final String colunaCpf = "cpf";
  final String colunaNome = "nome";
   // Tabela de consultas simulando os dados do Sistema AGHU
  final String tabelaConsulta = "tabelaConsulta";
  final String colunaIdConsulta = "idConsulta";
  final String colunaMedico = "medico";
  final String colunaEspecialidade = "especialidade";
  final String colunaConsultorio = "consultorio";
  final String colunaFkConsulta = "idRegistro";
  final String colunaFkRegConsulta = "fk_RegConsulta";
  

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initSistemaAGHUBD();
    return _db;
  }

  initSistemaAGHUBD() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();

    String caminho = join(documentoDiretorio.path, "SistemaAGHUbd_teste.db");

    var nossoSistemaAGHUBD =
        await openDatabase(caminho, version: 1, onCreate: _onCreate);

    return nossoSistemaAGHUBD;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE  TABLE $tabelaRegistro"
        "($colunaIdRegistro INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colunaProntuario VARCHAR,"
        "$colunaCpf VARCHAR,"
        "$colunaNome VARCHAR)");

    await db.execute("CREATE TABLE $tabelaConsulta"
        "($colunaIdConsulta INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colunaMedico VARCHAR,"
        "$colunaEspecialidade VARCHAR,"
        "$colunaConsultorio VARCHAR,"
        "$colunaFkConsulta INTEGER,"
        " CONSTRAINT $colunaFkRegConsulta"
        " FOREIGN KEY ($colunaFkConsulta) REFERENCES $tabelaRegistro ($colunaIdRegistro))");
  }

  Future<int> inserirConsulta(Consulta consulta) async {
    var sistemaAGHUBDteste = await db;

    int res = await sistemaAGHUBDteste.insert(tabelaConsulta, consulta.toMap());

    return res;
  }

  Future<int> inserirRegistro(Registro registro) async {
    var sistemaAGHUBDteste = await db;

    int res = await sistemaAGHUBDteste.insert(tabelaRegistro, registro.toMap());

    return res;
  }

  Future<List> pegarTodos(String tabela) async {
    var sistemaAGHUBDteste = await db;

    var res =
        await sistemaAGHUBDteste.rawQuery("SELECT * FROM $tabela");

    return res.toList();
  }

  Future<int> pegarContagem(String tabela) async {
    var sistemaAGHUBDteste = await db;

    return Sqflite.firstIntValue(await sistemaAGHUBDteste
        .rawQuery("SELECT COUNT(*) FROM $tabela"));
  }

  Future<Registro> pegarRegistro(int id) async {
    var sistemaAGHUBDteste = await db;

    var res = await sistemaAGHUBDteste.rawQuery("SELECT * FROM $tabelaRegistro"
        " WHERE $colunaIdRegistro = $id");

    if (res.length == 0) return null;

    return new Registro.fromMap(res.first);
  }

  Future<Consulta> pegarConsulta(int id) async {
    var sistemaAGHUBDteste = await db;

    var res = await sistemaAGHUBDteste.rawQuery("SELECT * FROM $tabelaConsulta"
        " WHERE $colunaIdConsulta = $id");

    if (res.length == 0) return null;

    return new Consulta.fromMap(res.first);
  }

  Future<Registro> validarRegistro(String prontuario, String cpf) async {
    var sistemaAGHUBDteste = await db;

    var res = await sistemaAGHUBDteste.query(tabelaRegistro,
        where: " $colunaProntuario = ? AND $colunaCpf = ?",
        whereArgs: [prontuario, cpf]);

    if (res == null) return null;

    return new Registro.fromMap(res.first);
  }

  Future<int> apagarRegistro(int id) async {
    var sistemaAGHUBDteste = await db;

    return await sistemaAGHUBDteste.delete(tabelaRegistro,
        where: "$colunaIdRegistro = ?", whereArgs: [id]);
  }

  Future<int> editarRegistro(Registro registro) async {
    var sistemaAGHUBDteste = await db;

    return await sistemaAGHUBDteste.update(tabelaRegistro, registro.toMap(),
        where: "$colunaIdRegistro = ?", whereArgs: [registro.idRegistro]);
  }

  Future fecharSistemaAGHUBD() async {
    var sistemaAGHUBDteste = await db;

    return await sistemaAGHUBDteste.close();
  }
}
