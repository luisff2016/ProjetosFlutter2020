import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "NotasModel.dart";

/// ********************************************************************************************************************
/// Classe do provedor de banco de dados
/// ********************************************************************************************************************

class NotasDB {
  /// Static instance and private constructor, since this is a singleton.
  NotasDB._();
  static final NotasDB db = NotasDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    if (_db == null) {
      print("## nota Classe NotasDB: ERRO _db: null");
      _db = await init();
    }
    print("## nota NotasDB.get-database(): _db = $_db");
    return _db;
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("## nota NotasDB.init()");
    String path = join(utils.docsDir.path, "notas.db");
    print("## nota NotasDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS notas ("
          "id INTEGER PRIMARY KEY,"
          "titulo TEXT,"
          "conteudo TEXT,"
          "color TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a Nota from a Map.
  Nota notaFromMap(Map inMap) {
    print("## Notas NotasDB.notaFromMap(): inMap = $inMap");
    Nota nota = Nota();
    nota.id = inMap["id"];
    nota.titulo = inMap["titulo"];
    nota.conteudo = inMap["conteudo"];
    nota.color = inMap["color"];
    print("## nota NotasDB.notaFromMap(): nota = $nota");
    return nota;
  } /* End notaFromMap(); */

  /// Create a Map from a Nota.
  Map<String, dynamic> notaToMap(Nota inNota) {
    print("## nota NotasDB.notaToMap(): inNota = $inNota");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inNota.id;
    map["titulo"] = inNota.titulo;
    map["conteudo"] = inNota.conteudo;
    map["color"] = inNota.color;
    print("## nota NotasDB.notaToMap(): map = $map");
    return map;
  } /* End notaToMap(). */

  /// Create a nota.
  ///
  /// @param  inNota The Nota object to create.
  /// @return        Future.
  Future create(Nota inNota) async {
    print("## nota NotasDB.create(): inNota = $inNota");
    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM notas");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }
    print("## nota NotasDB.create(): id = $id");
    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO notas (id, titulo, conteudo, color) VALUES (?, ?, ?, ?)",
        [id, inNota.titulo, inNota.conteudo, inNota.color]);
  } /* End create(). */

  /// Get a specific nota.
  ///
  /// @param  inID The ID of the nota to get.
  /// @return      The corresponding Nota object.
  Future<Nota> get(int inID) async {
    print("## nota NotasDB.get(): inID = $inID");
    Database db = await database;
    var rec = await db.query("notas", where: "id = ?", whereArgs: [inID]);
    print("## nota NotasDB.get(): rec.first = $rec.first");
    return notaFromMap(rec.first);
  } /* End get(). */

  /// Get all notas.
  ///
  /// @return A List of Nota objects.
  Future<List> get getAll async {
    print("## nota NotasDB.getAll()");
    Database db = await database;
    var recs = await db.query("notas");
    var list = recs.isNotEmpty ? recs.map((m) => notaFromMap(m)).toList() : [];
    print("## nota NotasDB.getAll(): list = $list");
    return list;
  } /* End getAll(). */

  /// Update a nota.
  ///
  /// @param inNota The nota to update.
  /// @return       Future.
  Future update(Nota inNota) async {
    print("## nota NotasDB.update(): inNota = $inNota");
    Database db = await database;
    return await db.update("notas", notaToMap(inNota),
        where: "id = ?", whereArgs: [inNota.id]);
  } /* End update(). */

  /// Delete a nota.
  ///
  /// @param inID The ID of the nota to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("## nota NotasDB.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("notas", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
