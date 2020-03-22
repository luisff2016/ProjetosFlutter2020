import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'registro.dart';

class BD {
  BD._internal();
  static final BD _instance = new BD._internal();

  factory BD() => _instance;

  

  final String tabelaRegistro = "tabelaRegistro";
  final String colunaIdRegistro = "idRegistro";
  final String colunaProntuario = "prontuario";
  final String colunaCpf = "cpf";
  final String colunaNome = "nome";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initBD();
    return _db;
  }

  initBD() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();

    String caminho = join(documentoDiretorio.path, "bd_teste.db");

    var nossoBD = await openDatabase(caminho, version: 1, onCreate: _onCreate);

    return nossoBD;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE  TABLE $tabelaRegistro"
        "($colunaIdRegistro INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$colunaProntuario TEXT,"
        "$colunaCpf TEXT,"
        "$colunaNome TEXT)");
  }

  Future<int> inserirRegistro(Registro registro) async {
    var bdTeste = await db;

    int res = await bdTeste.insert(tabelaRegistro, registro.toMap());

    return res;
  }

  Future<List> pegarTodosRegistros() async {
    var bdTeste = await db;

    var res = await bdTeste.rawQuery("SELECT * FROM $tabelaRegistro");

    return res.toList();
  }

  Future<int> pegarContagemRegistros() async {
    var bdTeste = await db;

    return Sqflite.firstIntValue(
        await bdTeste.rawQuery("SELECT COUNT(*) FROM $tabelaRegistro"));
  }

  Future<Registro> pegarRegistro(int id) async {
    var bdTeste = await db;

    var res = await bdTeste.rawQuery("SELECT * FROM $tabelaRegistro"
        " WHERE $colunaIdRegistro = $id");

    if (res.length == 0) return null;

    return new Registro.fromMap(res.first);
  }

  Future<Registro> validarRegistro(String prontuario, String cpf) async {
    var bdTeste = await db;

    var res = await bdTeste.query(tabelaRegistro,
        where: " $colunaProntuario = ? AND $colunaCpf = ?",
        whereArgs: [prontuario, cpf]);

    if (res == null) return null;

    return new Registro.fromMap(res.first);
  }

  Future<int> apagarRegistro(int id) async {
    var bdTeste = await db;

    return await bdTeste
        .delete(tabelaRegistro, where: "$colunaIdRegistro = ?", whereArgs: [id]);
  }

  Future<int> editarRegistro(Registro registro) async {
    var bdTeste = await db;

    return await bdTeste.update(tabelaRegistro, registro.toMap(),
        where: "$colunaIdRegistro = ?", whereArgs: [registro.idRegistro]);
  }

  Future fecharBD() async {
    var bdTeste = await db;

    return await bdTeste.close();
  }
}
