import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "AlergiasModel.dart";

/// ********************************************************************************************************************
/// Database provider class for nAlergias.
/// ********************************************************************************************************************
class AlergiasDB {
  /// Static instance and private constructor, since this is a singleton.
  AlergiasDB._();
  static final AlergiasDB db = AlergiasDB._();

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
      print("##45 Alergias AlergiasDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("##46 ERRO get-database(): $e ");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("alergias AlergiasDB.init()");

    String path = join(utils.docsDir.path, "alergias.db");
    print("##47 alergias AlergiasDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS alergias ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "content TEXT,"
          "color TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a NAlergia from a Map.
  Alergia alergiaFromMap(Map inMap) {
    print("##48 alergias AlergiasDB.alergiaFromMap(): inMap = $inMap");

    Alergia alergia = Alergia();
    alergia.id = inMap["id"];
    alergia.title = inMap["title"];
    alergia.content = inMap["content"];
    alergia.color = inMap["color"];

    print("##49 alergias AlergiasDB.alergiaFromMap(): alergia = $alergia");

    return alergia;
  } /* End nAlergiaFromMap(); */

  /// Create a Map from a NAlergia.
  Map<String, dynamic> alergiaToMap(Alergia inAlergia) {
    print("##50 Alergias AlergiasDB.alergiaToMap(): inAlergia = $inAlergia");

    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inAlergia.id;
    map["title"] = inAlergia.title;
    map["content"] = inAlergia.content;
    map["color"] = inAlergia.color;
    print("##51 alergias AlergiasDB.alergiaToMap(): map = $map");
    return map;
  } /* End nAlergiaToMap(). */

  /// Create a nAlergia.
  ///
  /// @param  inNAlergia The NAlergia object to create.
  /// @return        Future.
  Future create(Alergia inAlergia) async {
    print("##52 Alergias AlergiasDB.create(): inAlergia = $inAlergia");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM alergias");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO alergias (id, title, content, color) VALUES (?, ?, ?, ?)",
        [id, inAlergia.title, inAlergia.content, inAlergia.color]);
  } /* End create(). */

  /// Get a specific nAlergia.
  ///
  /// @param  inID The ID of the nAlergia to get.
  /// @return      The corresponding NAlergia object.
  Future<Alergia> get(int inID) async {
    print("##53 Alergias AlergiasDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("alergias", where: "id = ?", whereArgs: [inID]);

    print("##54 Alergias AlergiasDB.get(): rec.first = $rec.first");

    return alergiaFromMap(rec.first);
  } /* End get(). */

  /// Get all nAlergias.
  ///
  /// @return A List of NAlergia objects.
  Future<List> get getAll async {
    print("##55 Alergias AlergiasDB.getAll()");
    try {
      Database db = await database;
      var recs = await db.query("alergias");
      var list =
          recs.isNotEmpty ? recs.map((m) => alergiaFromMap(m)).toList() : [];

      print("##56 Alergias AlergiasDB.getAll(): list = $list");

      return list;
    } catch (e) {
      print("##57 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a nAlergia.
  ///
  /// @param inNAlergia The nAlergia to update.
  /// @return       Future.
  Future update(Alergia inAlergia) async {
    print("##58 Alergias AlergiasDB.update(): inAlergia = $inAlergia");
    try {
      Database db = await database;
      return await db.update("alergias", alergiaToMap(inAlergia),
          where: "id = ?", whereArgs: [inAlergia.id]);
    } catch (e) {
      print("##59 ERRO AlergiasDB.update(): $e ");
    }
  } /* End update(). */

  /// Delete a nAlergia.
  ///
  /// @param inID The ID of the nAlergia to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("##60 Alergias AlergiasDB.delete(): inID = $inID");
    try {
      Database db = await database;
      return await db.delete("alergias", where: "id = ?", whereArgs: [inID]);
    } catch (e) {
      print("##61 ERRO AlergiasDB.delete(): $e ");
    }
  } /* End delete(). */
} /* End class. */
