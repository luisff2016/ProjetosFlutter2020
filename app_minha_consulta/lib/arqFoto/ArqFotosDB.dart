import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import 'ArqFotosModel.dart';


/// ********************************************************************************************************************
/// Database provider class for arqFotos.
/// ********************************************************************************************************************

class ArqFotosDB {
  /// Static instance and private constructor, since this is a singleton.
  ArqFotosDB._();

  static final ArqFotosDB db = ArqFotosDB._();
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

      print("##121 arqFotos ArqFotosDB.get-database(): _db = $_db");

      return _db;

    } catch (e) {

      print("##122 ERRO _db: try_catch($e)");

    }

  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {

    String path = join(utils.docsDir.path, "arqFotos.db");

    print("##123 arqFotos ArqFotosDB.init(): path = $path");

    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS arqFotos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });

    return db;

  } /* End init(). */

  /// Create a arqFotos from a Map.
  ArqFoto arqFotosFromMap(Map inMap) {

    print("##124 arqFotos ArqFotosDB.arqFotosFromMap(): inMap = $inMap");

    ArqFoto arqFotos = ArqFoto();

    arqFotos.id = inMap["id"];

    arqFotos.title = inMap["title"];

    arqFotos.description = inMap["description"];

    arqFotos.apptDate = inMap["apptDate"];

    arqFotos.apptTime = inMap["apptTime"];

    print("##125 arqFotos ArqFotosDB.arqFotosFromMap(): arqFotos = $arqFotos");

    return arqFotos;

  } /* End arqFotosFromMap(); */

  /// Create a Map from a arqFotos.
  Map<String, dynamic> arqFotoToMap(ArqFoto inArqFotos) {

    print("##126 arqFotos ArqFotosDB.arqFotoToMap(): inArqFotos = $inArqFotos");

    Map<String, dynamic> map = Map<String, dynamic>();

    map["id"] = inArqFotos.id;

    map["title"] = inArqFotos.title;

    map["description"] = inArqFotos.description;

    map["apptDate"] = inArqFotos.apptDate;

    map["apptTime"] = inArqFotos.apptTime;

    print("##127 arqFotos ArqFotosDB.arqFotoToMap(): map = $map");

    return map;

  } /* End arqFotoToMap(). */

  /// Create a arqFotos.
  ///
  /// @param inArqFotos the arqFotos object to create.
  Future create(ArqFoto inArqFotos) async {

    print("##128 arqFotos ArqFotosDB.create(): inArqFotos = $inArqFotos");

    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arqFotos");

    int id = val.first["id"];

    if (id == null) {

      id = 1;

    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO arqFotos (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inArqFotos.title,
          inArqFotos.description,
          inArqFotos.apptDate,
          inArqFotos.apptTime
        ]);

  } /* End create(). */

  /// Get a specific arqFotos.
  ///
  /// @param  inID The ID of the arqFotos to get.
  /// @return      The corresponding arqFotos object.
  Future<ArqFoto> get(int inID) async {

    print("##129 arqFotos ArqFotosDB.get(): inID = $inID");

    Database db = await database;

    var rec = await db.query("arqFotos", where: "id = ?", whereArgs: [inID]);

    print("##130 arqFotos ArqFotosDB.get(): rec.first = $rec.first");

    return arqFotosFromMap(rec.first);

  } /* End get(). */

  /// Get all arqFotos.
  ///
  /// @return A List of arqFotos objects.
  Future<List> getAll() async {

    try {

      Database db = await database;

      var recs = await db.query("arqFotos");

      var list =
          recs.isNotEmpty ? recs.map((m) => arqFotosFromMap(m)).toList() : [];

      print("##131 arqFotos ArqFotosDB.getAll(): list = $list");

      return list;

    } catch (e) {

      print("##132 ERRO getAll(): $e ");

      return null;

    }

  } /* End getAll(). */

  /// Update a arqFotos.
  ///
  /// @param inArqFotos The arqFotos to update.
  Future update(ArqFoto inArqFotos) async {

    print("##133 arqFotos ArqFotosDB.update(): inArqFotos = $inArqFotos");

    Database db = await database;

    return await db.update("arqFotos", arqFotoToMap(inArqFotos),
        where: "id = ?", whereArgs: [inArqFotos.id]);

  } /* End update(). */

  /// Delete a arqFotos.
  ///
  /// @param inID The ID of the arqFotos to delete.
  Future delete(int inID) async {

    print("##134 arqFotos ArqFotosDB.delete(): inID = $inID");

    Database db = await database;

    return await db.delete("arqFotos", where: "id = ?", whereArgs: [inID]);

  } /* End delete(). */

} /* End class. */