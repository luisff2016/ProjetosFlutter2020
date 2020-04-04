import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import 'ArqVideosModel.dart';

/// ********************************************************************************************************************
/// Database provider class for arqVideoss.
/// ********************************************************************************************************************
class ArqVideosDB {
  /// Static instance and private constructor, since this is a singleton.
  ArqVideosDB._();
  static final ArqVideosDB db = ArqVideosDB._();

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
      print("##121 arqVideoss ArqVideosDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("##122 ERRO _db: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "arqVideos.db");
    print("##123 arqVideoss ArqVideosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS arqVideos ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a arqVideos from a Map.
  ArqVideo arqVideoFromMap(Map inMap) {
    print("##124 arqVideoss ArqVideosDB.arqVideoFromMap(): inMap = $inMap");
    ArqVideo arqVideo = ArqVideo();
    arqVideo.id = inMap["id"];
    arqVideo.title = inMap["title"];
    arqVideo.description = inMap["description"];
    arqVideo.apptDate = inMap["apptDate"];
    arqVideo.apptTime = inMap["apptTime"];
    print("##125 arqVideos ArqVideosDB.arqVideoFromMap(): arqVideo = $arqVideo");

    return arqVideo;
  } /* End arqVideoFromMap(); */

  /// Create a Map from a arqVideos.
  Map<String, dynamic> arqVideoToMap(ArqVideo inArqVideo) {
    print("##126 arqVideo ArqVideosDB.arqVideoToMap(): inArqVideo = $inArqVideo");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inArqVideo.id;
    map["title"] = inArqVideo.title;
    map["description"] = inArqVideo.description;
    map["apptDate"] = inArqVideo.apptDate;
    map["apptTime"] = inArqVideo.apptTime;
    print("##127 arqVideos ArqVideosDB.arqVideoToMap(): map = $map");

    return map;
  } /* End arqVideoToMap(). */

  /// Create a arqVideos.
  ///
  /// @param inArqVideo the arqVideos object to create.
  Future create(ArqVideo inArqVideo) async {
    print("##128 arqVideos ArqVideosDB.create(): inArqVideo = $inArqVideo");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM arqVideos");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO arqVideos (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inArqVideo.title,
          inArqVideo.description,
          inArqVideo.apptDate,
          inArqVideo.apptTime
        ]);
  } /* End create(). */

  /// Get a specific arqVideos.
  ///
  /// @param  inID The ID of the arqVideos to get.
  /// @return      The corresponding arqVideos object.
  Future<ArqVideo> get(int inID) async {
    print("##129 arqVideoss ArqVideosDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("arqVideos", where: "id = ?", whereArgs: [inID]);
    print("##130 arqVideoss ArqVideosDB.get(): rec.first = $rec.first");
    return arqVideoFromMap(rec.first);
  } /* End get(). */

  /// Get all arqVideoss.
  ///
  /// @return A List of arqVideos objects.
  Future<List> getAll() async {
    try {
      Database db = await database;
      var recs = await db.query("arqVideos");
      var list =
          recs.isNotEmpty ? recs.map((m) => arqVideoFromMap(m)).toList() : [];
      print("##131 arqVideoss ArqVideosDB.getAll(): list = $list");
      return list;
    } catch (e) {
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a arqVideos.
  ///
  /// @param inArqVideo The arqVideos to update.
  Future update(ArqVideo inArqVideo) async {
    print("##133 arqVideo ArqVideosDB.update(): inArqVideo = $inArqVideo");

    Database db = await database;
    return await db.update("arqVideos", arqVideoToMap(inArqVideo),
        where: "id = ?", whereArgs: [inArqVideo.id]);
  } /* End update(). */

  /// Delete a arqVideos.
  ///
  /// @param inID The ID of the arqVideos to delete.
  Future delete(int inID) async {
    print("##134 arqVideoss ArqVideosDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("arqVideos", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */
} /* End class. */