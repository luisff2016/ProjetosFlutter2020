import 'package:app_minha_consulta/arquivos/Arquivos.dart';
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;


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
    try{
if (_db == null) {
      print("##120 ERRO _db: null");
      _db = await init();
    }
    print("##121 arquivoss ArquivosDB.get-database(): _db = $_db");
    return _db;
    }catch(e){
      print("##122 ERRO _db: try_catch($e)");
    }

    

  } /* End database getter. */


  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {

    String path = join(utils.docsDir.path, "arquivos.db");
    print("##123 arquivoss ArquivosDB.init(): path = $path");
    Database db = await openDatabase(path, version : 1, onOpen : (db) { },
      onCreate : (Database inDB, int inVersion) async {
        await inDB.execute(
          "CREATE TABLE IF NOT EXISTS arquivos ("
            "id INTEGER PRIMARY KEY,"
            "title TEXT,"
            "description TEXT,"
            "apptDate TEXT,"
            "apptTime TEXT"
          ")"
        );
      }
    );
    return db;

  } /* End init(). */


  /// Create a arquivos from a Map.
  Arquivos arquivosFromMap(Map inMap) {

    print("##124 arquivoss ArquivosDB.arquivosFromMap(): inMap = $inMap");
    Arquivos arquivos = Arquivos();
    arquivos.id = inMap["id"];
    arquivos.title = inMap["title"];
    arquivos.description = inMap["description"];
    arquivos.apptDate = inMap["apptDate"];
    arquivos.apptTime = inMap["apptTime"];
    print("##125 arquivoss ArquivosDB.arquivosFromMap(): arquivos = $arquivos");

    return arquivos;

  } /* End arquivosFromMap(); */


  /// Create a Map from a arquivos.
  Map<String, dynamic> arquivosToMap(Arquivos inArquivos) {

    print("##126 arquivoss ArquivosDB.arquivosToMap(): inArquivos = $inArquivos");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inArquivos.id;
    map["title"] = inArquivos.title;
    map["description"] = inArquivos.description;
    map["apptDate"] = inArquivos.apptDate;
    map["apptTime"] = inArquivos.apptTime;
    print("##127 arquivoss ArquivosDB.arquivosToMap(): map = $map");

    return map;

  } /* End arquivosToMap(). */


  /// Create a arquivos.
  ///
  /// @param inArquivos the arquivos object to create.
  Future create(Arquivos inArquivos) async {

    print("##128 arquivoss ArquivosDB.create(): inArquivos = $inArquivos");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arquivos");
    int id = val.first["id"];
    if (id == null) { id = 1; }

    // Insert into table.
    return await db.rawInsert(
      "INSERT INTO arquivos (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
      [
        id,
        inArquivos.title,
        inArquivos.description,
        inArquivos.apptDate,
        inArquivos.apptTime
      ]
    );

  } /* End create(). */


  /// Get a specific arquivos.
  ///
  /// @param  inID The ID of the arquivos to get.
  /// @return      The corresponding arquivos object.
  Future<Arquivos> get(int inID) async {

    print("##129 arquivoss ArquivosDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("arquivos", where : "id = ?", whereArgs : [ inID ]);
    print("##130 arquivoss ArquivosDB.get(): rec.first = $rec.first");
    return arquivosFromMap(rec.first);

  } /* End get(). */


  /// Get all arquivoss.
  ///
  /// @return A List of arquivos objects.
  Future<List> getAll() async {
    try{
      Database db = await database;
      var recs = await db.query("arquivos");
      var list = recs.isNotEmpty ? recs.map((m) => arquivosFromMap(m)).toList() : [ ];
      print("##131 arquivoss ArquivosDB.getAll(): list = $list");
      return list;
    }catch(e){
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */


  /// Update a arquivos.
  ///
  /// @param inArquivos The arquivos to update.
  Future update(Arquivos inArquivos) async {

    print("##133 arquivoss ArquivosDB.update(): inArquivos = $inArquivos");

    Database db = await database;
    return await db.update(
      "arquivoss", arquivosToMap(inArquivos), where : "id = ?", whereArgs : [ inArquivos.id ]
    );

  } /* End update(). */


  /// Delete a arquivos.
  ///
  /// @param inID The ID of the arquivos to delete.
  Future delete(int inID) async {

    print("##134 arquivoss ArquivosDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("arquivos", where : "id = ?", whereArgs : [ inID ]);

  } /* End delete(). */


} /* End class. */