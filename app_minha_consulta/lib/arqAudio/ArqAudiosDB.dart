import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import 'ArqAudiosModel.dart';


/// ********************************************************************************************************************
/// Database provider class for audios.
/// ********************************************************************************************************************

class ArqAudiosDB {

  /// Static instance and private constructor, since this is a singleton.
  ArqAudiosDB._();
  static final ArqAudiosDB db = ArqAudiosDB._();

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

      print("##121 arqAudio ArqAudiosDB.get-database(): _db = $_db");

      return _db;

    } catch (e) {

      print("##122 ERRO _db: try_catch($e)");

    }

  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "arqAudios.db");
    print("##123 arqAudios ArqAudiosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS arqAudios ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a arqAudio from a Map.
  ArqAudio arqAudioFromMap(Map inMap) {
    print("##124 arqAudio ArqAudiosDB.audioFromMap(): inMap = $inMap");
    ArqAudio arqAudio = ArqAudio();
    arqAudio.id = inMap["id"];
    arqAudio.title = inMap["title"];
    arqAudio.description = inMap["description"];
    arqAudio.apptDate = inMap["apptDate"];
    arqAudio.apptTime = inMap["apptTime"];
    print("##125 arqAudio ArqAudiosDB.audioFromMap(): arqAudio = $arqAudio");

    return arqAudio;
  } /* End audioFromMap(); */

  /// Create a Map from a arqAudio.
  Map<String, dynamic> arqAudioToMap(ArqAudio inArqAudio) {
    print("##126 arqAudio ArqAudiosDB.arqAudioToMap(): inArqAudio = $inArqAudio");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inArqAudio.id;
    map["title"] = inArqAudio.title;
    map["description"] = inArqAudio.description;
    map["apptDate"] = inArqAudio.apptDate;
    map["apptTime"] = inArqAudio.apptTime;
    print("##127 arqAudio ArqAudiosDB.arqAudioToMap(): map = $map");

    return map;
  } /* End audioToMap(). */

  /// Create a audios.
  ///
  /// @param inArqAudio the audios object to create.
  Future create(ArqAudio inArqAudio) async {
    print("##128 arqAudio ArqAudiosDB.create(): inArqAudio = $inArqAudio");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arqAudios");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO arqAudios (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inArqAudio.title,
          inArqAudio.description,
          inArqAudio.apptDate,
          inArqAudio.apptTime
        ]);
  } /* End create(). */

  /// Get a specific aArqAudios.
  ///
  /// @param  inID The ID of the aArqAudios to get.
  /// @return      The corresponding aArqAudios object.
  Future<ArqAudio> get(int inID) async {
    print("##129 audios ArqAudiosDB.get(): inID = $inID");

    Database db = await database;

    var rec = await db.query("arqAudios", where: "id = ?", whereArgs: [inID]);

    print("##130 arqAudio ArqAudiosDB.get(): rec.first = $rec.first");

    return arqAudioFromMap(rec.first);
  } /* End get(). */

  /// Get all audioss.
  ///
  /// @return A List of audios objects.
  Future<List> getAll() async {
    try {
      Database db = await database;

      var recs = await db.query("arqAudios");

      var list =
          recs.isNotEmpty ? recs.map((m) => arqAudioFromMap(m)).toList() : [];

      print("##131 arqAudio ArqAudiosDB.getAll(): list = $list");

      return list;
    } catch (e) {
      print("##132 ERRO getAll(): $e ");

      return null;
    }
  } /* End getAll(). */

  /// Update a aArqAudios.
  ///
  /// @param inArqAudio The aArqAudios to update.
  Future update(ArqAudio inArqAudio) async {
    print("##133 arqAudio ArqAudiosDB.update(): inArqAudio = $inArqAudio");

    Database db = await database;

    return await db.update("arqAudios", arqAudioToMap(inArqAudio),
        where: "id = ?", whereArgs: [inArqAudio.id]);
  } /* End update(). */

  /// Delete a audios.
  ///
  /// @param inID The ID of the ArqAudios to delete.
  Future delete(int inID) async {
    print("##134 arqAudio ArqAudiosDB.delete(): inID = $inID");

    Database db = await database;
    
    return await db.delete("arqAudios", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */
} /* End class. */