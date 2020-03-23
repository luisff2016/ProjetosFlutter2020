import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "PacientesModel.dart";

/// ********************************************************************************************************************
/// Classe do provedor de banco de dados
/// ********************************************************************************************************************

class PacientesDB {
  /// Static instance and private constructor, since this is a singleton.
  PacientesDB._();
  static final PacientesDB db = PacientesDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    if (_db == null) {
      print("## pacientes Classe PacientesDB: ERRO _db: null");
      _db = await init();
    }
    print("## pacientes PacientesDB.get-database(): _db = $_db");
    return _db;
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("## pacientes PacientesDB.init()");
    String path = join(utils.docsDir.path, "pacientes.db");
    print("## pacientes PacientesDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS pacientes ("
          "id INTEGER PRIMARY KEY,"
          "protocolo INT,"
          "cpf INT,"
          "nome TEXT,"
          "color TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a uPacientessuario from a Map.
  Pacientes pacientesFromMap(Map inMap) {
    print("## uPacientessuario UPacientessuariosDB.uPacientessuarioFromMap(): inMap = $inMap");
    UPacientessuario uPacientessuario = UPacientessuario();
    uPacientessuario.id = inMap["id"];
    uPacientessuario.protocolo = inMap["protocolo"];
    uPacientessuario.cpf = inMap["cpf"];
    uPacientessuario.nome = inMap["nome"];
    uPacientessuario.color = inMap["color"];
    print("## uPacientessuario UPacientessuariosDB.uPacientessuarioFromMap(): uPacientessuario = $uPacientessuario");
    return uPacientessuario;
  } /* End uPacientessuarioFromMap(); */

  /// Create a Map from a uPacientessuario.
  Map<String, dynamic> uPacientessuarioToMap(UPacientessuario inUPacientessuario) {
    print("## uPacientessuario UPacientessuariosDB.uPacientessuarioToMap(): inUPacientessuario = $inUPacientessuario");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inUPacientessuario.id;
    map["protocolo"] = inUPacientessuario.protocolo;
    map["cpf"] = inUPacientessuario.cpf;
    map["nome"] = inUPacientessuario.nome;
    map["color"] = inUPacientessuario.color;
    print("## uPacientessuario UPacientessuariosDB.uPacientessuarioToMap(): map = $map");
    return map;
  } /* End uPacientessuarioToMap(). */

  /// Create a uPacientessuario.
  ///
  /// @param  inUPacientessuario The uPacientessuario object to create.
  /// @return        Future.
  Future create(UPacientessuario inUPacientessuario) async {
    print("## uPacientessuario UPacientessuariosDB.create(): inUPacientessuario = $inUPacientessuario");
    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM uPacientessuarios");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }
    print("## uPacientessuarios UPacientessuariosDB.create(): id = $id");
    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO UPacientessuarios (id, protocolo, cpf, color) VALUES (?, ?, ?, ?)",
        [
          id,
          inUPacientessuario.protocolo,
          inUPacientessuario.cpf,
          inUPacientessuario.nome,
          inUPacientessuario.color
        ]);
  } /* End create(). */

  /// Get a specific uPacientessuario.
  ///
  /// @param  inID The ID of the uPacientessuario to get.
  /// @return      The corresponding uPacientessuario object.
  Future<UPacientessuario> get(int inID) async {
    print("## uPacientessuario UPacientessuariosDB.get(): inID = $inID");
    Database db = await database;
    var rec = await db.query("uPacientessuarios", where: "id = ?", whereArgs: [inID]);
    print("## uPacientessuario UPacientessuariosDB.get(): rec.first = $rec.first");
    return uPacientessuarioFromMap(rec.first);
  } /* End get(). */

  /// Get all UPacientessuarios.
  ///
  /// @return A List of uPacientessuario objects.
  Future<List> get getAll async {
    print("## suario UPacientessuariosDB.getAll()");
    Database db = await database;
    var recs = await db.query("uPacientessuarios");
    var list =
        recs.isNotEmpty ? recs.map((m) => uPacientessuarioFromMap(m)).toList() : [];
    print("## uPacientessuario UPacientessuariosDB.getAll(): list = $list");
    return list;
  } /* End getAll(). */

  /// Update a uPacientessuario.
  ///
  /// @param inUPacientessuario The uPacientessuario to update.
  /// @return       Future.
  Future update(UPacientessuario inUPacientessuario) async {
    print("## uPacientessuario UPacientessuariosDB.update(): inUPacientessuario = $inUPacientessuario");
    Database db = await database;
    return await db.update("uPacientessuarios", uPacientessuarioToMap(inUPacientessuario),
        where: "id = ?", whereArgs: [inUPacientessuario.id]);
  } /* End update(). */

  /// Delete a uPacientessuario.
  ///
  /// @param inID The ID of the uPacientessuario to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("## uPacientessuario UPacientessuariosDB.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("uPacientessuarios", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
