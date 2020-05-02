import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import 'ArqDocumentosModel.dart';


/// ********************************************************************************************************************
/// Database provider class for arqDocumentos.
/// ********************************************************************************************************************

class ArqDocumentosDB {
  /// Static instance and private constructor, since this is a singleton.
  ArqDocumentosDB._();

  static final ArqDocumentosDB db = ArqDocumentosDB._();
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

      print("##121 arqDocumentos ArqDocumentosDB.get-database(): _db = $_db");

      return _db;
  
    } catch (e) {
 
      print("##122 ERRO _db: try_catch($e)");
 
    }
 
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
   
    String path = join(utils.docsDir.path, "arqDocumentos.db");

    print("##123 arqDocumentos ArqDocumentosDB.init(): path = $path");

    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS arqDocumentos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });

    return db;

  } /* End init(). */

  /// Create a arqDocumentos from a Map.
  ArqDocumento arqDocumentoFromMap(Map inMap) {
 
    print("##124 arqDocumentos ArqDocumentosDB.arqDocumentoFromMap(): inMap = $inMap");
 
    ArqDocumento arqDocumento = ArqDocumento();
 
    arqDocumento.id = inMap["id"];
 
    arqDocumento.title = inMap["title"];
 
    arqDocumento.description = inMap["description"];
 
    arqDocumento.apptDate = inMap["apptDate"];
 
    arqDocumento.apptTime = inMap["apptTime"];
 
    print("##125 arqDocumentos ArqDocumentosDB.arqDocumentoFromMap(): arqDocumento = $arqDocumento");

    return arqDocumento;
 
  } /* End arqDocumentoFromMap(); */

  /// Create a Map from a arqDocumentos.
  Map<String, dynamic> arqDocumentoToMap(ArqDocumento inArqDocumento) {
 
    print("##126 arqDocumento ArqDocumentosDB.arqDocumentoToMap(): inArqDocumento = $inArqDocumento");
 
    Map<String, dynamic> map = Map<String, dynamic>();
 
    map["id"] = inArqDocumento.id;
 
    map["title"] = inArqDocumento.title;
 
    map["description"] = inArqDocumento.description;
 
    map["apptDate"] = inArqDocumento.apptDate;
 
    map["apptTime"] = inArqDocumento.apptTime;
 
    print("##127 arqDocumento ArqDocumentosDB.arqDocumentoToMap(): map = $map");

    return map;
 
  } /* End arqDocumentoToMap(). */

  /// Create a arqDocumentos.
  ///
  /// @param inArqDocumento the arqDocumentos object to create.
  Future create(ArqDocumento inArqDocumento) async {
 
    print("##128 arqDocumento ArqDocumentosDB.create(): inArqDocumento = $inArqDocumento");

    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arqDocumentos");

    int id = val.first["id"];

    if (id == null) {

      id = 1;

    }
    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO arqDocumentos (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inArqDocumento.title,
          inArqDocumento.description,
          inArqDocumento.apptDate,
          inArqDocumento.apptTime
        ]);

  } /* End create(). */

  /// Get a specific arqDocumentos.
  ///
  /// @param  inID The ID of the arqDocumentos to get.
  /// @return      The corresponding arqDocumentos object.
  Future<ArqDocumento> get(int inID) async {

    print("##129 arqDocumento ArqDocumentosDB.get(): inID = $inID");

    Database db = await database;

    var rec = await db.query("arqDocumentos", where: "id = ?", whereArgs: [inID]);
    
    print("##130 arqDocumento ArqDocumentosDB.get(): rec.first = $rec.first");
    
    return arqDocumentoFromMap(rec.first);

  } /* End get(). */

  /// Get all arqDocumentos.
  ///
  /// @return A List of arqDocumentos objects.
  Future<List> getAll() async {

    try {

      Database db = await database;
    
      var recs = await db.query("arqDocumentos");
    
      var list =
          recs.isNotEmpty ? recs.map((m) => arqDocumentoFromMap(m)).toList() : [];
    
      print("##131 arqDocumento ArqDocumentosDB.getAll(): list = $list");
    
      return list;

    } catch (e) {

      print("##132 ERRO getAll(): $e ");
    
      return null;

    }
  
  } /* End getAll(). */

  /// Update a arqDocumentos.
  ///
  /// @param inArqDocumento The arqDocumentos to update.
  Future update(ArqDocumento inArqDocumento) async {

    print("##133 arqDocumento ArqDocumentosDB.update(): inArqDocumento = $inArqDocumento");

    Database db = await database;
  
    return await db.update("arqDocumentos", arqDocumentoToMap(inArqDocumento),
        where: "id = ?", whereArgs: [inArqDocumento.id]);

  } /* End update(). */

  /// Delete a arqDocumentos.
  ///
  /// @param inID The ID of the arqDocumentos to delete.
  Future delete(int inID) async {

    print("##134 arqDocumento ArqDocumentosDB.delete(): inID = $inID");

    Database db = await database;
  
    return await db.delete("arqDocumentos", where: "id = ?", whereArgs: [inID]);

  } /* End delete(). */

} /* End class. */