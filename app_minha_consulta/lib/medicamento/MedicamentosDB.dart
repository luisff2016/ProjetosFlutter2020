import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "../utils.dart" as utils;
import "MedicamentosModel.dart";

/// ********************************************************************************************************************
/// Database provider class for Medicamentos.
/// ********************************************************************************************************************
class MedicamentosDB {
  /// Static instance and private constructor, since this is a singleton.
  MedicamentosDB._();
  static final MedicamentosDB db = MedicamentosDB._();

  /// The one and only database instance.
  Database _db;

  /// Get singleton instance, create if not available yet.
  ///
  /// @return The one and only Database instance.
  Future get database async {
    try {
      if (_db == null) {
        _db = await init();
      }

      print("##19 Medicamentos MedicamentosDB.get-database(): _db = $_db");

      return _db;
    } catch (e) {
      print("##20 ERRO MedicamentosDB.get-database(): $e ");
    }
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("##21 Medicamentos MedicamentosDB.init()");

    String path = join(utils.docsDir.path, "medicamentos.db");
    print("##22 Medicamentos MedicamentosDB.init(): path = $path");
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
      await inDB.execute("CREATE TABLE IF NOT EXISTS medicamentos ("
          "id INTEGER PRIMARY KEY,"
          "description TEXT,"
          "dueDate TEXT,"
          "completed TEXT"
          ")");
    });
    return db;
  } /* End init(). */

  /// Create a medicamento from a Map.
  Medicamento medicamentoFromMap(Map inMap) {
    print("##23 Medicamentos MedicamentosDB.medicamentoFromMap(): inMap = $inMap");

    Medicamento medicamento = Medicamento();
    medicamento.id = inMap["id"];
    medicamento.description = inMap["description"];
    medicamento.dueDate = inMap["dueDate"];
    medicamento.completed = inMap["completed"];

    print("##24 Medicamentos MedicamentosDB.medicamentoFromMap(): medicamento = $medicamento");

    return medicamento;
  } /* End medicamentoFromMap(); */

  /// Create a Map from a medicamento.
  Map<String, dynamic> medicamentoToMap(Medicamento inMedicamento) {
    print("##25 Medicamentos MedicamentosDB.medicamentoToMap(): inMedicamento = $inMedicamento");

    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inMedicamento.id;
    map["description"] = inMedicamento.description;
    map["dueDate"] = inMedicamento.dueDate;
    map["completed"] = inMedicamento.completed;

    print("##26 Medicamentos MedicamentosDB.medicamentoToMap(): map = $map");

    return map;
  } /* End medicamentoToMap(). */

  /// Create a medicamento.
  ///
  /// @param  inMedicamento The medicamento object to create.
  /// @return        Future.
  Future create(Medicamento inMedicamento) async {
    print("##27 Medicamentos MedicamentosDB.create(): inMedicamento = $inMedicamento");

    Database db = await database;

    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM medicamentos");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }

    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO medicamentos (id, description, dueDate, completed) VALUES (?, ?, ?, ?)",
        [id, inMedicamento.description, inMedicamento.dueDate, inMedicamento.completed]);
  } /* End create(). */

  /// Get a specific medicamento.
  ///
  /// @param  inID The ID of the medicamento to get.
  /// @return      The corresponding medicamento object.
  Future<Medicamento> get(int inID) async {
    print("##28 Medicamentos MedicamentosDB.get(): inID = $inID");

    Database db = await database;
    var rec = await db.query("Medicamentos", where: "id = ?", whereArgs: [inID]);

    print("##29 Medicamentos MedicamentosDB.get(): rec.first = $rec.first");

    return medicamentoFromMap(rec.first);
  } /* End get(). */

  /// Get all Medicamentos.
  ///
  /// @return A List of medicamento objects.
  Future<List> getAll() async {
    print("##30 Medicamentos MedicamentosDB.getAll()");
    try {
      Database db = await database;
      var recs = await db.query("medicamentos");
      var list =
          recs.isNotEmpty ? recs.map((m) => medicamentoFromMap(m)).toList() : [];

      print("##31 Medicamentos MedicamentosDB.getAll(): list = $list");

      return list;
    } catch (e) {
      print("##32 ERRO MedicamentosDB.getAll(): $e ");
      return null;
    }
  } /* End getAll(). */

  /// Update a medicamento.
  ///
  /// @param  inMedicamento The medicamento to update.
  /// @return        Future.
  Future update(Medicamento inMedicamento) async {
    print("##33 Medicamentos MedicamentosDB.update(): inMedicamento = $inMedicamento");

    Database db = await database;
    return await db.update("medicamentos", medicamentoToMap(inMedicamento),
        where: "id = ?", whereArgs: [inMedicamento.id]);
  } /* End update(). */

  /// Delete a medicamento.
  ///
  /// @param  inID The ID of the medicamento to delete.
  /// @return      Future.
  Future delete(int inID) async {
    print("##34 Taasks MedicamentosDB.delete(): inID = $inID");

    Database db = await database;
    return await db.delete("medicamentos", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
