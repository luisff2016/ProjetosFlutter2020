import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import 'ArquivosModel.dart';

/// ********************************************************************************************************************
/// Database provider class for arquivoss.
/// ********************************************************************************************************************
class ArquivosDB {
  /// Static instance and private constructor, since this is a singleton.
  ArquivosDB._();
  static final ArquivosDB db = ArquivosDB._();

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
      print("##121 arquivoss ArquivosDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("##122 ERRO _db: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "arquivos.db");
    print("##123 arquivoss ArquivosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS arquivos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a arquivos from a Map.
  Arquivo arquivoFromMap(Map inMap) {
    print("##124 arquivoss ArquivosDB.arquivoFromMap(): inMap = $inMap");
    Arquivo arquivo = Arquivo();
    arquivo.id = inMap["id"];
    arquivo.title = inMap["title"];
    arquivo.description = inMap["description"];
    arquivo.apptDate = inMap["apptDate"];
    arquivo.apptTime = inMap["apptTime"];
    print("##125 arquivos ArquivosDB.arquivoFromMap(): arquivo = $arquivo");

    return arquivo;
  } /* End arquivoFromMap(); */

  /// Create a Map from a arquivos.
  Map<String, dynamic> arquivosToMap(Arquivo inArquivo) {
    print("##126 arquivoss ArquivosDB.arquivosToMap(): inArquivo = $inArquivo");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inArquivo.id;
    map["title"] = inArquivo.title;
    map["description"] = inArquivo.description;
    map["apptDate"] = inArquivo.apptDate;
    map["apptTime"] = inArquivo.apptTime;
    print("##127 arquivos ArquivosDB.arquivoToMap(): map = $map");

    return map;
  } /* End arquivosToMap(). */

  /// Create a arquivos.
  ///
  /// @param inArquivo the arquivos object to create.
  Future create(Arquivo inArquivo) async {
    print("##128 arquivos ArquivosDB.create(): inArquivo = $inArquivo");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arquivos");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO arquivos (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inArquivo.title,
          inArquivo.description,
          inArquivo.apptDate,
          inArquivo.apptTime
        ]);
  } /* End create(). */

  /// Get a specific arquivos.
  ///
  /// @param  inID The ID of the arquivos to get.
  /// @return      The corresponding arquivos object.
  Future<Arquivo> get(int inID) async {
    print("##129 arquivoss ArquivosDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("arquivos", where: "id = ?", whereArgs: [inID]);
    print("##130 arquivoss ArquivosDB.get(): rec.first = $rec.first");
    return arquivoFromMap(rec.first);
  } /* End get(). */

  /// Get all arquivoss.
  ///
  /// @return A List of arquivos objects.
  Future<List> getAll() async {
    try {
      Database db = await database;
      var recs = await db.query("arquivos");
      var list =
          recs.isNotEmpty ? recs.map((m) => arquivoFromMap(m)).toList() : [];
      print("##131 arquivoss ArquivosDB.getAll(): list = $list");
      return list;
    } catch (e) {
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a arquivos.
  ///
  /// @param inArquivo The arquivos to update.
  Future update(Arquivo inArquivo) async {
    print("##133 arquivos ArquivosDB.update(): inArquivo = $inArquivo");

    Database db = await database;
    return await db.update("arquivos", arquivosToMap(inArquivo),
        where: "id = ?", whereArgs: [inArquivo.id]);
  } /* End update(). */

  /// Delete a arquivos.
  ///
  /// @param inID The ID of the arquivos to delete.
  Future delete(int inID) async {
    print("##134 arquivoss ArquivosDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("arquivos", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */
} /* End class. */