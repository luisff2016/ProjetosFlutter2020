import 'package:app_minha_consulta/paciente/Pacientes.dart';
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
      print("## paciente Classe PacientesDB: ERRO _db: null");
      _db = await init();
    }
    print("## paciente PacientesDB.get-database(): _db = $_db");
    return _db;
  } /* End database getter. */

  /// Initialize database.
  ///
  /// @return A Database instance.
  Future<Database> init() async {
    print("## paciente PacientesDB.init()");
    String path = join(utils.docsDir.path, "pacientes.db");
    print("## paciente PacientesDB.init(): path = $path");
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

  /// Create a pacientes from a Map.
  Paciente pacienteFromMap(Map inMap) {
    print("## pacientes pacientessDB.pacientesFromMap(): inMap = $inMap");
    Paciente paciente = Paciente();
    paciente.id = inMap["id"];
    paciente.protocolo = inMap["protocolo"];
    paciente.cpf = inMap["cpf"];
    paciente.nome = inMap["nome"];
    paciente.color = inMap["color"];
    print("## paciente PacientesDB.pacientesFromMap(): pacientes = $paciente");
    return paciente;
  } /* End pacientesFromMap(); */

  /// Create a Map from a pacientes.
  Map<String, dynamic> pacienteToMap(Paciente inPacientes) {
    print("## paciente PacientessDB.pacientesToMap(): inPacientes = $inPacientes");
    Map<String, dynamic> map = Map<String, dynamic>();
    map["id"] = inPacientes.id;
    map["protocolo"] = inPacientes.protocolo;
    map["cpf"] = inPacientes.cpf;
    map["nome"] = inPacientes.nome;
    map["color"] = inPacientes.color;
    print("## pacientes pacientessDB.pacientesToMap(): map = $map");
    return map;
  } /* End pacientesToMap(). */

  /// Create a pacientes.
  ///
  /// @param  inPacientes The pacientes object to create.
  /// @return        Future.
  Future create(Paciente inPacientes) async {
    print("## paciente PacientesDB.create(): inPacientes = $inPacientes");
    Database db = await database;
    // Get largest current id in the table, plus one, to be the new ID.
    var val = await db.rawQuery("SELECT MAX(id) + 1 AS id FROM pacientes");
    int id = val.first["id"];
    if (id == null) {
      id = 1;
    }
    print("## paciente PacientesDB.create(): id = $id");
    // Insert into table.
    return await db.rawInsert(
        "INSERT INTO pacientes (id, protocolo, cpf, color) VALUES (?, ?, ?, ?)",
        [
          id,
          inPacientes.protocolo,
          inPacientes.cpf,
          inPacientes.nome,
          inPacientes.color
        ]);
  } /* End create(). */

  /// Get a specific pacientes.
  ///
  /// @param  inID The ID of the pacientes to get.
  /// @return      The corresponding pacientes object.
  Future<Paciente> get(int inID) async {
    print("## paciente PacientesDB.get(): inID = $inID");
    Database db = await database;
    var rec = await db.query("pacientes", where: "id = ?", whereArgs: [inID]);
    print("## paciente PacientesDB.get(): rec.first = $rec.first");
    return pacienteFromMap(rec.first);
  } /* End get(). */

  /// Get all pacientess.
  ///
  /// @return A List of pacientes objects.
  Future<List> get getAll async {
    print("## paciente PacientesDB.getAll()");
    Database db = await database;
    var recs = await db.query("pacientess");
    var list =
        recs.isNotEmpty ? recs.map((m) => pacienteFromMap(m)).toList() : [];
    print("## pacientes pacientessDB.getAll(): list = $list");
    return list;
  } /* End getAll(). */

  /// Update a pacientes.
  ///
  /// @param inPacientes The pacientes to update.
  /// @return       Future.
  Future update(Paciente inPacientes) async {
    print("## pacientes pacientessDB.update(): inPacientes = $inPacientes");
    Database db = await database;
    return await db.update("pacientess", pacienteToMap(inPacientes),
        where: "id = ?", whereArgs: [inPacientes.id]);
  } /* End update(). */

  /// Delete a pacientes.
  ///
  /// @param inID The ID of the pacientes to delete.
  /// @return     Future.
  Future delete(int inID) async {
    print("## paciente PacientesDB.delete(): inID = $inID");
    Database db = await database;
    return await db.delete("pacientes", where: "id = ?", whereArgs: [inID]);
  } /* End delete(). */

} /* End class. */
