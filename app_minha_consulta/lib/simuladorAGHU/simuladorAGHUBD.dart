import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'registro.dart';
import 'consulta.dart';

class SimuladorAGHUBD {
  SimuladorAGHUBD._internal();
  static final SimuladorAGHUBD _instance = new SimuladorAGHUBD._internal();

  factory SimuladorAGHUBD() => _instance;
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
    _db = await initSimuladorAGHUBD();
    return _db;
  }

  initSimuladorAGHUBD() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();

    String caminho = join(documentoDiretorio.path, "Simulador.db");

    var nossoSimuladorAGHUBD =
        await openDatabase(caminho, version: 1, onCreate: _onCreate);

    return nossoSimuladorAGHUBD;
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
    var simuladorAGHUBDteste = await db;

    int res = await simuladorAGHUBDteste.insert(tabelaConsulta, consulta.toMap());

    return res;
  }

  Future<int> inserirRegistro(Registro registro) async {
    var simuladorAGHUBDteste = await db;

    int res = await simuladorAGHUBDteste.insert(tabelaRegistro, registro.toMap());

    return res;
  }

  Future<List> pegarTodos(String tabela) async {
    var simuladorAGHUBDteste = await db;

    var res =
        await simuladorAGHUBDteste.rawQuery("SELECT * FROM $tabela");

    return res.toList();
  }

  Future<int> pegarContagem(String tabela) async {
    var simuladorAGHUBDteste = await db;

    return Sqflite.firstIntValue(await simuladorAGHUBDteste
        .rawQuery("SELECT COUNT(*) FROM $tabela"));
  }

  Future<Registro> pegarRegistro(int id) async {
    var simuladorAGHUBDteste = await db;

    var res = await simuladorAGHUBDteste.rawQuery("SELECT * FROM $tabelaRegistro"
        " WHERE $colunaIdRegistro = $id");

    if (res.length == 0) return null;

    return new Registro.fromMap(res.first);
  }

  Future<Consulta> pegarConsulta(int id) async {
    var simuladorAGHUBDteste = await db;

    var res = await simuladorAGHUBDteste.rawQuery("SELECT * FROM $tabelaConsulta"
        " WHERE $colunaIdConsulta = $id");

    if (res.length == 0) return null;

    return new Consulta.fromMap(res.first);
  }

  Future<Registro> validarRegistro(String prontuario, String cpf) async {
    var simuladorAGHUBDteste = await db;

    var res = await simuladorAGHUBDteste.query(tabelaRegistro,
        where: " $colunaProntuario = ? AND $colunaCpf = ?",
        whereArgs: [prontuario, cpf]);

    if (res.first == null) return null;

    return new Registro.fromMap(res.first);
  }

  Future<int> apagarRegistro(int id) async {
    var simuladorAGHUBDteste = await db;

    return await simuladorAGHUBDteste.delete(tabelaRegistro,
        where: "$colunaIdRegistro = ?", whereArgs: [id]);
  }

  Future<int> editarRegistro(Registro registro) async {
    var simuladorAGHUBDteste = await db;

    return await simuladorAGHUBDteste.update(tabelaRegistro, registro.toMap(),
        where: "$colunaIdRegistro = ?", whereArgs: [registro.idRegistro]);
  }

  Future fecharSimuladorAGHUBD() async {
    var simuladorAGHUBDteste = await db;

    return await simuladorAGHUBDteste.close();
  }
}
