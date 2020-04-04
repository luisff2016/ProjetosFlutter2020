import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "ConsultasModel.dart";

/// ********************************************************************************************************************
/// Database provider class for Consultas.
/// ********************************************************************************************************************
class ConsultasDB {
  /// Static instance and private constructor, since this is a singleton.
  ConsultasDB._();
  static final ConsultasDB db = ConsultasDB._();

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
      print("##121 Consultas ConsultasDB.get-database(): _db = $_db");
      return _db;
    } catch (e) {
      print("##122 ERRO _db: try_catch($e)");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    String path = join(utils.docsDir.path, "consultas.db");
    print("##123 Consultas ConsultasDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS consultas ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "description TEXT,"
          "apptDate TEXT,"
          "apptTime TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a consulta from a Map.
  Consulta consultaFromMap(Map inMap) {
    print("##124 Consultas ConsultasDB.consultaFromMap(): inMap = $inMap");
    Consulta consulta = Consulta();
    consulta.id = inMap["id"];
    consulta.title = inMap["title"];
    consulta.description = inMap["description"];
    consulta.apptDate = inMap["apptDate"];
    consulta.apptTime = inMap["apptTime"];
    print(
        "##125 Consultas ConsultasDB.consultaFromMap(): consulta = $consulta");

    return consulta;
  } /* End consultaFromMap(); */

  /// Create a Map from a consulta.
  Map<String, dynamic> consultaToMap(Consulta inConsulta) {
    print(
        "##126 Consultas ConsultasDB.consultaToMap(): inConsulta = $inConsulta");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inConsulta.id;
    map["title"] = inConsulta.title;
    map["description"] = inConsulta.description;
    map["apptDate"] = inConsulta.apptDate;
    map["apptTime"] = inConsulta.apptTime;
    print("##127 Consultas ConsultasDB.consultaToMap(): map = $map");

    return map;
  } /* End consultaToMap(). */

  /// Create a consulta.
  ///
  /// @param inConsulta the consulta object to create.
  Future create(Consulta inConsulta) async {
    print("##128 Consultas ConsultasDB.create(): inConsulta = $inConsulta");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM Consultas");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO Consultas (id, title, description, apptDate, apptTime) VALUES (?, ?, ?, ?, ?)",
        [
          id,
          inConsulta.title,
          inConsulta.description,
          inConsulta.apptDate,
          inConsulta.apptTime
        ]);
  } /* End create(). */

  /// Get a specific consulta.
  ///
  /// @param  inID The ID of the consulta to get.
  /// @return      The corresponding consulta object.
  Future<Consulta> get(int inID) async {
    print("##129 Consultas ConsultasDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("Consultas", where: "id = ?", whereArgs: [inID]);
    print("##130 Consultas ConsultasDB.get(): rec.first = $rec.first");
    return consultaFromMap(rec.first);
  } /* End get(). */

  /// Get all Consultas.
  ///
  /// @return A List of consulta objects.
  Future<List> getAll() async {
    try {
      Database db = await database;
      var recs = await db.query("Consultas");
      var list =
          recs.isNotEmpty ? recs.map((m) => consultaFromMap(m)).toList() : [];
      print("##131 Consultas ConsultasDB.getAll(): list = $list");
      return list;
    } catch (e) {
      print("##132 ERRO getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a consulta.
  ///
  /// @param inConsulta The consulta to update.
  Future update(Consulta inConsulta) async {
    print("##133 Consultas ConsultasDB.update(): inConsulta = $inConsulta");

    Database db = await database;
    return await db.update("Consultas", consultaToMap(inConsulta),
        where: "id = ?", whereArgs: [inConsulta.id]);
  } /* End update(). */

  /// Delete a consulta.
  ///
  /// @param inID The ID of the consulta to delete.
  Future delete(int inID) async {
    print("##134 Consultas ConsultasDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("Consultas", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
