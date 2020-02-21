import 'package:app_minha_consulta/anotacoes/Anotacoes.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "AnotacoesModel.dart";

/// ********************************************************************************************************************
/// Database provider class for anotacoess.
/// ********************************************************************************************************************
class AnotacoesDB {
  /// Static instance and private constructor, since this is a singleton.
  AnotacoesDB._();
  static final AnotacoesDB db = AnotacoesDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    try {
      if (_db == null) {
        print("##120 ERRO _db: null");
        _db = await init();
      }
      print("##121 anotacoes AnotacoesDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("##122 ERRO _db: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "anotacoes.db");
    print("##123 anotacoes AnotacoesDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS anotacoes ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a anotacoes from a Map.
  Anotacao anotacaoFromMap(Map inMap) {
    print("##124 anotacoess AnotacoesDB.anotacoesFromMap(): inMap = $inMap");
    Anotacao anotacao = Anotacao();
    anotacao.id = inMap["id"];
    anotacao.title = inMap["title"];
    anotacao.description = inMap["description"];
    anotacao.apptDate = inMap["apptDate"];
    anotacao.apptTime = inMap["apptTime"];
    print(
        "##125 anotacoes AnotacoesDB.anotacaoFromMap(): anotacao = $anotacao");

    return anotacao;
  } /* End anotacoesFromMap(); */

  /// Create a Map from a anotacoes.
  Map<String, dynamic> anotacaoToMap(Anotacao inAnotacao) {
    print(
        "##126 anotacoess AnotacoesDB.anotacoesToMap(): inAnotacao = $inAnotacao");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inAnotacao.id;
    map["title"] = inAnotacao.title;
    map["description"] = inAnotacao.description;
    map["apptDate"] = inAnotacao.apptDate;
    map["apptTime"] = inAnotacao.apptTime;
    print("##127 anotacoess AnotacoesDB.anotacaoToMap(): map = $map");
    return map;
  } /* End anotacoesToMap(). */

  /// Create a anotacoes.
  ///
  /// @param inAnotacao the anotacoes object to create.
  Future create(Anotacao inAnotacao) async {
    print("##128 anotacoess AnotacoesDB.create(): inAnotacao = $inAnotacao");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM anotacoess");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO anotacoess (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inAnotacao.title,
          inAnotacao.description,
          inAnotacao.apptDate,
          inAnotacao.apptTime
        ]);
  } /* End create(). */

  /// Get a specific anotacoes.
  ///
  /// @param  inID The ID of the anotacoes to get.
  /// @return      The corresponding anotacoes object.
  Future<Anotacao> get(int inID) async {
    print("##129 anotacoes AnotacoesDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("anotacoes", where: "id = ?", whereArgs: [inID]);
    print("##130 anotacoess AnotacoesDB.get(): rec.first = $rec.first");
    return anotacaoFromMap(rec.first);
  } /* End get(). */

  /// Get all anotacoess.
  ///
  /// @return A List of anotacoes objects.
  Future<List> getAll() async {
    try {
      Database db = await database;
      var recs = await db.query("anotacoes");
      var list =
          recs.isNotEmpty ? recs.map((m) => anotacaoFromMap(m)).toList() : [];
      print("##131 anotacoes AnotacoesDB.getAll(): list = $list");
      return list;
    } catch (e) {
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a anotacoes.
  ///
  /// @param inAnotacao The anotacoes to update.
  Future update(Anotacao inAnotacao) async {
    print("##133 anotacoess AnotacoesDB.update(): inAnotacao = $inAnotacao");

    Database db = await database;
    return await db.update("anotacoes", anotacaoToMap(inAnotacao),
        where: "id = ?", whereArgs: [inAnotacao.id]);
  } /* End update(). */

  /// Delete a anotacoes.
  ///
  /// @param inID The ID of the anotacoes to delete.
  Future delete(int inID) async {
    print("##134 anotacoess AnotacoesDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("anotacoes", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
